//
//  ViewController.swift
//  Bluenet
//
//  Created by Alex de Mulder on 11/04/16.
//  Copyright © 2016 Alex de Mulder. All rights reserved.
//

import UIKit
import BluenetLibIOS
import SwiftyJSON
import CoreBluetooth
import PromiseKit

class ViewController: UIViewController {
    
    var bluenet : Bluenet!
    var bluenetLocalization : BluenetLocalization!

    override func viewDidLoad() {
        super.viewDidLoad()
         print("view start created")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    // here to check if the user succesfully switched the permissions
    func appMovedToForeground() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        // important, set the viewcontroller and the appname in the library so we can trigger 
        // alerts for bluetooth and navigation usage.
        BluenetLibIOS.setBluenetGlobals(viewController: self, appName: "Crownstone")
        self.bluenet = Bluenet();
        self.bluenetLocalization = BluenetLocalization();
        
//        trackIBeacon()
        scanForCrownstones()
        
        // we bind a listener to the UIApplicationDidBecomeActiveNotification event to check if the user successfully turned on Bluetooth in the settings. If not, we can annoy him.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(ViewController.appMovedToForeground), name: UIApplicationDidBecomeActiveNotification, object: nil)
        
    }
    
    /**
     *   EXAMPLE I: Scanning for all BLE devices
     *      The scanning will give us the peripheral UUIDs like "5F1534C4-37A6-9BB3-08F9-86E092AB19D7"
     *      We will use this uuid in the next example.
     */
    func scanForBleDevices() {
        // first we subscribe to the event that will tell us all about the scan results.
        self.bluenet.on("advertisementData", {data -> Void in
            if let castData = data as? Advertisement {
                print (castData.getJSON()); // print it to the console in JSON format
            }
        })
        
        // start the scanning
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it for BLE things.
            .then({_ in self.bluenet.startScanning()}) // once the lib is ready, start scanning
            .error({err in print("error in example1 \(err)")}) // in case an error occurs, print it here.
    }
    
    
    /**
     *   EXAMPLE II: Scanning for all Crownstones
     *      The scanning will give us the peripheral UUIDs like "5F1534C4-37A6-9BB3-08F9-86E092AB19D7"
     *      We will use this uuid in the next example.
     */
    func scanForCrownstones() {
        // first we subscribe to the event that will tell us all about the scan results.
        self.bluenet.on("advertisementData", {data -> Void in
            if let castData = data as? Advertisement {
                print (castData.getJSON()); // print it to the console in JSON format
            }
        })
        
        // start the scanning
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it for BLE things.
            .then({_ in self.bluenet.startScanningForCrownstones()}) // once the lib is ready, start scanning
            .error({err in print("error in example1 \(err)")}) // in case an error occurs, print it here.
    }
    
    
    /**
     *   EXAMPLE III: connecting to a device and disconnect again
     */
    func connectAndDisconnectForFun() {
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
            .then({_ in return self.bluenet.connect("5F1534C4-37A6-9BB3-08F9-86E092AB19D7")})
            .then({_ in return self.bluenet.disconnect()})
            .error({err in print("error in example 2 \(err)")})
    }
    
    /**
     *   EXAMPLE IV: switching on a crownstone
     */
    func switchCrownstone() {
        // we return the promises so we can chain the then() calls.
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
            .then({_ in return self.bluenet.connect("5F1534C4-37A6-9BB3-08F9-86E092AB19D7")}) // connect
            .then({_ in return self.bluenet.setSwitchState(1)}) // switch
            .then({_ in return self.bluenet.disconnect()}) // disconnect
            .error({err in print("error in example 2 \(err)")}) // catch errors
    }
    
    
    /**
     *   EXAMPLE V: track an ibeacon UUID
     */
    func trackIBeacon() {
        // listen to the ibeacon events that will be received
        self.bluenetLocalization.on("iBeaconAdvertisement", {ibeaconData -> Void in
            var stringArray = [JSON]()
            if let data = ibeaconData as? [iBeaconPacket] {
                for packet in data {
                    stringArray.append(packet.getJSON())
                }
            }
            print(stringArray)
        })
        
        // track the ibeaconUUID
        self.bluenetLocalization.trackUUID("ddb79713-87ca-4044-84f0-e87072db8106",groupId: "groupId")
        
    }
    
    
    
    
    
    
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

