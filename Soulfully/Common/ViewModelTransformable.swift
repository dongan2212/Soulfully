import UIKit
import RxSwift
import RxCocoa

public protocol ViewModelTransformable: AnyObject {
	associatedtype Input
	associatedtype Output
	func transform(input: Input) -> Output
}

class ViewModel: NSObject {

	internal var disposeBag: DisposeBag!
	internal var appError = PublishSubject<AppError>()
	internal var activity = ActivityIndicator()

	public override init() {
		disposeBag = DisposeBag()
		super.init()
	}

	deinit {
		#if DEBUG
		print("\(String(describing: self)) deinit.")
		#endif
	}
}

extension ViewModel {
	func onError(error: AppError) {
		self.appError.onNext(error)
	}
}
