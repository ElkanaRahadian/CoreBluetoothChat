//
//  ViewController.swift
//  chatChat
//
//  Created by Arin Davoodian on 8/9/19.
//  Copyright © 2019 arin. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralManagerDelegate{
    
    
    @IBOutlet weak var dataView: UITextView!
    
    @IBOutlet weak var toggleStateOutlet: UIButton!
    
    var centralManager: CBCentralManager!
    var peripheralManager: CBPeripheralManager!
    
    var isActive = true
    
    let WR_UUID = CBUUID(string: "36353433-3231-3039-3837-363534333231")
    let WR_PROPERTIES: CBCharacteristicProperties = .write
    let WR_PERMISSIONS: CBAttributePermissions = .writeable
    
    override func viewDidLoad() {
          super.viewDidLoad()
          
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue(label: "this", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: .global()))
		peripheralManager = CBPeripheralManager(delegate: self, queue: nil)

      }

    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
          case .unknown:
            print("central.state is .unknown")
          case .resetting:
            print("central.state is .resetting")
          case .unsupported:
            print("central.state is .unsupported")
          case .unauthorized:
            print("central.state is .unauthorized")
          case .poweredOff:
            print("central.state is .poweredOff")
          case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: nil)
        @unknown default:
            fatalError()
        }
    }
    
    @IBAction func stopPressed(_ sender: UIButton) {
        if isActive == true {
            isActive = false
			centralManager.stopScan()
            DispatchQueue.main.async {
                self.toggleStateOutlet.setTitle("Start", for: .normal)
            }
        } else {
            isActive = true
			centralManager.scanForPeripherals(withServices: nil, options: .none)
            DispatchQueue.main.async {
                self.toggleStateOutlet.setTitle("Stop", for: .normal)
            }
        }
        
    }
    
    @IBAction func scrollPressed(_ sender: UIButton) {
        textViewScrollToBottom()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if isActive {
            DispatchQueue.main.async {
                self.dataView.text.append("\(peripheral)" + "\n")
                self.dataView.text.append("\(advertisementData)" + "\n")
                self.dataView.text.append("\(RSSI)" + "\n")
            }
        }
        
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state == .poweredOn) {
            
            let serialService = CBMutableService(type: WR_UUID, primary: true)
            let writeCharacteristics = CBMutableCharacteristic(type: WR_UUID,
                                                               properties: WR_PROPERTIES, value: nil,
                                                               permissions: WR_PERMISSIONS)
            serialService.characteristics = [writeCharacteristics]
            peripheralManager.add(serialService)
                
            
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        
        for request in requests {
            if let value = request.value {
                
                //here is the message text that we receive, use it as you wish.
                let messageText = String(data: value, encoding: String.Encoding.utf8) as String?
				debugPrint(messageText as Any)
            }
            self.peripheralManager.respond(to: request, withResult: .success)
        }
    }
    
    
    
    private func textViewScrollToBottom() {
        let bottomRange = NSMakeRange(self.dataView.text.count - 1, 1)

        self.dataView.scrollRangeToVisible(bottomRange)
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        self.dataView.text = ""
    }
    

  

}

