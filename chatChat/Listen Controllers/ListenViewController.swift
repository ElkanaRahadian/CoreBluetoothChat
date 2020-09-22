//
//  ListenViewController.swift
//  chatChat
//
//  Created by Arin Davoodian on 2/21/20.
//  Copyright © 2020 arin. All rights reserved.
//

import UIKit
import CoreLocation


class ListenViewController: UIViewController, CLLocationManagerDelegate {

	var locationManager: CLLocationManager!
	
	@IBOutlet weak var listernerDataView: UITextView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.requestAlwaysAuthorization()
    }
    
	@IBAction func startListeningTapped(_ sender: UIButton) {
		startScanning()
	}
	
	@IBAction func stopListeningTapped(_ sender: UIButton) {
		let uuid = UUID(uuidString: "6B814174-BE5E-4C6F-B56D-7AD05A38C85B")
		let major = 100
		let minor = 1
		let beaconID = "com.chatChat.App"
		let beaconRegion = CLBeaconRegion(uuid: uuid!, major: CLBeaconMajorValue(major), minor: CLBeaconMinorValue(minor), identifier: beaconID)
		
		locationManager.stopMonitoring(for: beaconRegion)
		locationManager.stopRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid!, major: 100))
	}
	
	func startScanning() {
		let uuid = UUID(uuidString: "6B814174-BE5E-4C6F-B56D-7AD05A38C85B")
		let major = 100
		let minor = 1
		let beaconID = "com.chatChat.App"
		let beaconRegion = CLBeaconRegion(uuid: uuid!, major: CLBeaconMajorValue(major), minor: CLBeaconMinorValue(minor), identifier: beaconID)
		
		locationManager.startMonitoring(for: beaconRegion)
		locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid!, major: 100))
	}
	
	func updateDistance(_ distance: CLProximity) {
		switch distance {
			case .unknown:
				print("unknown")
			case .far:
				print("far")
			case .near:
				print("near")
			case .immediate:
				print("immediate")
			@unknown default:
				print("other")
		}
	}

}

extension ListenViewController {
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedAlways {
			if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
				if CLLocationManager.isRangingAvailable() {
					startScanning()
				}
			}
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
		if beacons.count > 0 {
			updateDistance(beacons[0].proximity)
		} else {
			updateDistance(.unknown)
		}
	}
}
