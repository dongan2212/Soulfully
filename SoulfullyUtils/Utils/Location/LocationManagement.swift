//
//  LocationManagement.swift
//  ServicePlatform
//
//

import CoreLocation
import RxSwift
import RxCocoa

public final class LocationServices: NSObject {

  public static var singleton = LocationServices()
  public var locationManager: CLLocationManager?
  public let location: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)
  public let locationStatusDidChange: PublishSubject<Bool> = PublishSubject()
  private var currentLocation: CLLocation?

  /// Used for faking location feature
  private var backupCurrent: CLLocation?

  public var denied: Bool {
    if CLLocationManager.locationServicesEnabled() {
      return .authorizedWhenInUse != CLLocationManager.authorizationStatus()
    }
    return true
  }
  public var waiting = false
  public var didTrigger = false
  /// Disable faking location feature for default
  public var isRelocateEnabled = false

  public override init() {
    super.init()

    locationManager = CLLocationManager()
    locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    locationManager?.delegate = self

    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
      locationManager?.startUpdatingLocation()
    } else {
      didTrigger = true
    }
  }

  // MARK: - Faking location feature
  public func relocate(lat: Double, lng: Double) {
    if backupCurrent.isNil {
      backupCurrent = location.value
    }
    currentLocation = nil
    location.accept(CLLocation(latitude: lat, longitude: lng))
  }

  public func restoreData() {
    location.accept(backupCurrent)
    backupCurrent = nil
  }
}

extension LocationServices: CLLocationManagerDelegate {

  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard !isRelocateEnabled else { return }
    location.accept(locations.last)
  }

  public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

    guard !isRelocateEnabled else { return }

    /// Re-enable user interaction on tabbar when the user allowed accessing location
    if didTrigger, status != .notDetermined {
      didTrigger = false
    }
    if status == .authorizedWhenInUse || status == .authorizedAlways {
      location.accept(manager.location)
      locationStatusDidChange.onNext(true)
    } else {
      locationStatusDidChange.onNext(false)
      currentLocation = nil
    }
    locationManager?.startUpdatingLocation()
  }

  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    guard !isRelocateEnabled else { return }

    location.accept(nil)
    currentLocation = nil
    /// Re-enable user interaction on tabbar although the user didn't allow accessing location
    if didTrigger {
      didTrigger = false
    }
  }
}
