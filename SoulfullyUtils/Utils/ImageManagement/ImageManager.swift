//
//  ImageManager.swift
//  ServicePlatform
//
//

import Kingfisher
import UIKit

// swiftlint:disable line_length
public struct ImageManager {
    
    public typealias Action = () -> Void
    static func maxMemory(cost: Int) {
        ImageCache.default.memoryStorage.config.totalCostLimit = cost
    }
    
    static func clearCache() {
        ImageCache.default.clearMemoryCache()
    }

    /// Automatic download image from url and cache then it in storage
    ///
    /// - Parameter urlStr: image url
    static func downloadImage(urlStr: String, completed: @escaping Action) {
        /// Ignore empty url string
        guard !urlStr.isEmpty else {
            /// Callback on main thread
            DispatchQueue.main.async {
                completed()
            }
            return
        }
        DispatchQueue.global(qos: .utility).async {
            if !ImageCache.default.imageCachedType(forKey: urlStr).cached {
                if let url = URL(string: urlStr) {
                    ImageDownloader.default.downloadImage(with: url, options: []) { (result) in
                        switch result {
                        case .success(let res):
                            /// If the downloaded file is gif then should process before storing in local
                            if (urlStr as NSString).pathExtension == "gif",
                               let gif = DefaultImageProcessor.default.process(item: .data(res.originalData), options: .init(nil)) {
                                KingfisherManager.shared.cache.store(gif, original: res.originalData, forKey: urlStr)
                            } else {
                                ImageCache.default.store(res.image, forKey: urlStr)
                            }
                        default: break
                        }
                        /// Callback on main thread
                        DispatchQueue.main.async {
                            completed()
                        }
                    }
                }
            } else {
                /// Callback on main thread
                DispatchQueue.main.async {
                    completed()
                }
            }
        }
    }
    
    public static func retrieveCachedImage(url: String?,
                                           options: KingfisherOptionsInfo?,
                                           completionHandler: ((_ image: UIImage?) -> Void)?) {
        guard let url = url else { return }
        ImageCache.default.retrieveImage(forKey: url, options: options) { rs in
            switch rs {
            case .success(let value):
                completionHandler?(value.image)
            case .failure:
                completionHandler?(nil)
            }
        }
    }
    
    /// As a part of image management, this function's for checking that whether image has been downloaded and cached in disk/memory from a respective url
    ///
    /// - Parameter url: image url
    /// - Returns: determined image being cached or not
    static func imageAvailable(url: String) -> Bool {
        return ImageCache.default.imageCachedType(forKey: url).cached
    }
    
    static func removeCachedImage(name: String) {
        ImageCache.default.removeImage(forKey: name)
    }
    
    static func imageToGif(img: UIImage) -> UIImage? {
        return DefaultImageProcessor.default.process(item: .image(img), options: .init(nil))
    }
    
    static func dataToGif(data: Data) -> UIImage? {
        return DefaultImageProcessor.default.process(item: .data(data), options: .init(nil))
    }
    
    public static func store(img: UIImage, original: Data? = nil, key: String) {
        KingfisherManager.shared.cache.store(img, original: original, forKey: key)
    }
    
    static func retrieveImages(urls: [String], completed: @escaping([UIImage]) -> Void, needDownload: Action? = nil) {
        DispatchQueue.main.async {
            var result = [UIImage]()
            urls.forEach({ url in
                ImageCache.default.retrieveImage(forKey: url, options: nil) { rs in
                    switch rs {
                    case .success(let value):
                        if let image = value.image {
                            result.append(image)
                            if result.count == urls.count {
                                completed(result)
                            }
                        } else {
                            needDownload?()
                        }
                    case .failure:
                        needDownload?()
                    }
                }
            })
        }
    }
    
    /// Checking the given image url is a gif file or not
    ///
    /// - Parameter url: given image url
    public static func isGif(_ url: String) -> Bool {
        return (url as NSString).pathExtension == "gif"
    }
    
    /// Downloading and caching image from url and then rendering to imageview
    ///
    /// - Parameter urlString: image url string
    public static func renderImage(imgView: UIImageView,
                                   urlString: String,
                                   blur: Bool = false,
                                   effect: Bool = true,
                                   placeholder: UIImage? = nil,
                                   completionHandler: ((_ image: UIImage?) -> Void)?=nil) {
        if let url = URL(string: urlString) {
            imgView.kf.indicatorType = .activity
            if effect {
                var options: KingfisherOptionsInfo = [.transition(.fade(0.25))]
                if blur {
                    options.append(.processor(BlurImageProcessor(blurRadius: 10)))
                }
                imgView.kf.setImage(with: url, placeholder: placeholder, options: options, completionHandler: { result in
                    switch result {
                    case .success(let value):
                        completionHandler?(value.image)
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                })
            } else {
                imgView.kf.setImage(with: url, placeholder: placeholder)
            }
        }
    }
    
    static func renderImageWithBlur(imgView: UIImageView,
                                    urlString: String,
                                    downloading: Action? = nil,
                                    downloaded: Action? = nil) {
        if let url = URL(string: urlString) {
            DispatchQueue.global(qos: .utility).async {
                ImageCache.default.retrieveImage(forKey: urlString, options: nil, completionHandler: { result in
                    switch result {
                    case .success(let value):
                        DispatchQueue.main.async {
                            imgView.image = value.image
                            downloaded?()
                        }
                    case .failure:
                        downloading?()
                        var options: KingfisherOptionsInfo?
                        if !ImageManager.isGif(urlString) {
                            options = [.backgroundDecode]
                        }
                        imgView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "icn-defaultAvatar"), options: options, completionHandler: { result in
                            switch result {
                            case .success: downloaded?()
                            case .failure(let error): print("Job failed: \(error.localizedDescription)")
                            }
                        })
                    }
                })
            }
        }
    }
    
    /// Retrieving image from storage by name first. Converting data to image if the image didn't exist in storage.
    /// Performing caching image to storage after converting data if the corresponding flag has been activated.
    ///
    /// - Parameters:
    ///   - imgView: target imageview
    ///   - imageNamed: image name for retrieving
    ///   - data: image data
    ///   - shouldCache: flag for determining that should cache image to storage or not
    static func renderImage(imgView: UIImageView, imageNamed: String, data: Data, shouldCache: Bool = true) {
        DispatchQueue.global(qos: .utility).async {
            if let gif = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: imageNamed) {
                DispatchQueue.main.async {
                    imgView.image = gif
                }
            } else {
                if let img = DefaultImageProcessor.default.process(item: .data(data), options: .init(nil)) {
                    DispatchQueue.main.async {
                        imgView.image = img
                    }
                    if shouldCache {
                        KingfisherManager.shared.cache.store(img, original: data, forKey: imageNamed)
                    }
                }
            }
        }
    }
    
    /// Downloading and caching image from url and then rendering to button
    ///
    /// - Parameter urlString: image url string
    static func renderImage(btn: UIButton, urlString: String) {
        if let url = URL(string: urlString) {
            btn.kf.setImage(with: url, for: .normal, placeholder: #imageLiteral(resourceName: "icn-defaultAvatar"), options: [.transition(.fade(0.25))])
        }
    }
    
    /// Force removing image from cached storage by its name
    ///
    /// - Parameter imageNamed: target image name
    static func removeImage(imageNamed: String) {
        KingfisherManager.shared.cache.removeImage(forKey: imageNamed)
    }
    
}
