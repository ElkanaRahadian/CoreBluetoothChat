//
//  BroadcastViewController.swift
//  chatChat
//
//  Created by Arin Davoodian on 2/21/20.
//  Copyright © 2020 arin. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class BroadcastViewController: UIViewController, CBPeripheralManagerDelegate {
	
	var localBeacon: CLBeaconRegion!
	var beaconPeripheralData: NSDictionary!
	var peripheralManager: CBPeripheralManager!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
	
	@IBAction func startBroadcastTapped(_ sender: UIButton) {
		createBeaconRegionAndStart()
	}
	
	@IBAction func stopBroadcastTapped(_ sender: UIButton) {
		stopLocalBeacon()
	}
	
    
	func createBeaconRegionAndStart() {
		if localBeacon != nil {
            stopLocalBeacon()
        }

        let localBeaconUUID = "805C5247-1436-4624-8CD2-0DC65BECE2BB"
        let localBeaconMajor: CLBeaconMajorValue = 100
        let localBeaconMinor: CLBeaconMinorValue = 1
		let beaconID = "com.chatChat.App"

        let uuid = UUID(uuidString: localBeaconUUID)!
		localBeacon = CLBeaconRegion(uuid: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: beaconID)

        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
		
	}
	
	func stopLocalBeacon() {
        peripheralManager.stopAdvertising()
		peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
		print("Stopped Broadcast")
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
			print(beaconPeripheralData as Any)
        } else if peripheral.state == .poweredOff {
            peripheralManager.stopAdvertising()
			print("Stopped Broadcast State OFF")
        }
    }
	

}
