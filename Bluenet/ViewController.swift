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
        
        let settings = BluenetSettings(encryptionEnabled: true, adminKey: "32c7ce8f4b893b19080d9e79a9c22f1f", memberKey: "0c33ad0f252e01a0195948081e0cd5d0", guestKey: "3cd5a90170ba6538df24a02657345c5c")
        self.bluenet.setSettings(settings)
        
        scanForCrownstones()
        
//        let crownstoneUUID_iphone5 = "4CB3D0CC-FDA2-D5F7-51FC-6B9066611507"
//        let crownstoneUUID_iphone6s = "53CCAD7C-EBA3-4E20-00E9-0D0BC41614DF"
//
//        self.bluenet.isReady() // first check if the bluenet lib is ready before using it for BLE things.
//            .then({_ in self.bluenet.connect(crownstoneUUID_iphone6s)}) // once the lib is ready, start scanning

        
        
//        self.bluenet.isReady()
//            .then({_ in self.bluenet.control.recoverByFactoryReset(crownstoneUUID_iphone6s)})
//            .error({err in print("err \(err)")}) // once the lib is ready, start scanning
//        self.scanForCrownstones(crownstoneUUID_iphone5);
//        delay(5, {_ in
//            print("Starting to connect and switch")
//            self.bluenet.isReady() // first check if the bluenet lib is ready before using it for BLE things.
//                .then({_ in self.bluenet.connect(crownstoneUUID_iphone5)}) // once the lib is ready, start scanning
//                .then({_ in self.bluenet.control.recoverByFactoryReset(crownstoneUUID_iphone5)}) // once the lib is ready, start scanning
//                .then({_ in self.bluenet.control.disconnect()}) // once the lib is ready, start scanning
//                .then({_ in print("DONE")}) // once the lib is ready, start scanning
//                .error({err in print("err \(err)")}) // once the lib is ready, start scanning

//        })
        //
//        self.setupCrownstoneExample(crownstoneUUID_iphone5)
        
        // we bind a listener to the UIApplicationDidBecomeActiveNotification event to check if the user successfully turned on Bluetooth in the settings. If not, we can annoy him.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(ViewController.appMovedToForeground), name: UIApplicationDidBecomeActiveNotification, object: nil)
        
    }

   
//    func testFactoryReset(uuid: String) {
//        self.bluenet.settings.disableEncryptionTemporarily()
//        self.bluenet.isReady() // first check if the bluenet lib is ready before using it for BLE things.
//                    .then({_ in self.bluenet.connect(uuid)}) // once the lib is ready, start scanning
//                    .then({_ in self.bluenet.control.recoverByFactoryReset()}) // once the lib is ready, start scanning
//                    .then({_ in self.bluenet.disconnect()}) // once the lib is ready, start scanning
//                    .then({_ in self.bluenet.bleManager.waitToReconnect()}) // once the lib is ready, start scanning
//                    .then({_ in self.bluenet.connect(uuid)}) // once the lib is ready, start scanning
//                    .then({_ in self.bluenet.control.recoverByFactoryReset()}) // once the lib is ready, start scanning
//                    .then({_ in self.bluenet.disconnect()}) // once the lib is ready, start scanning
//                    .then({_ -> Void in self.bluenet.settings.restoreEncryption()})
//                    .error({err in print("error in example I \(err)")}) // in case an error occurs, print it here.
//
//    }
    
    func setupCrownstoneExample(uuid: String) {
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it for BLE things.
            .then({_ in self.bluenet.connect(uuid)}) // once the lib is ready, start scanning
            .then({_ in self.bluenet.setup.setup(32, adminKey: "adminKeyForCrown", memberKey: "memberKeyForHome", guestKey: "guestKeyForGirls", meshAccessAddress: 12324, ibeaconUUID: "b643423e-e175-4af0-a2e4-31e32f729a8a", ibeaconMajor: 123, ibeaconMinor: 456)}) // once the lib is ready, start scanning
            .then({_ in print("DONE")})
            .error({err in
                print("end of line \(err)")
                self.bluenet.disconnect()
            })
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
                print(castData.getJSON())
                //print ("uuid: \(castData.uuid) name: \(castData.name)"); // print it to the console in JSON format
            }
        })
        
        // start the scanning
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it for BLE things.
            .then({_ in self.bluenet.startScanning()}) // once the lib is ready, start scanning
            .error({err in print("error in example I \(err)")}) // in case an error occurs, print it here.
    }
    
    /**
     *   EXAMPLE I: Scanning for all BLE devices
     *      The scanning will give us the peripheral UUIDs like "5F1534C4-37A6-9BB3-08F9-86E092AB19D7"
     *      We will use this uuid in the next example.
     */
    func scanForCrownstonesUnique(filterUUID: String? = nil) {
        // first we subscribe to the event that will tell us all about the scan results.
        self.bluenet.on("advertisementData", {data -> Void in
            if let castData = data as? Advertisement {
                if (filterUUID != nil) {
                    if (castData.handle == filterUUID) {
                        print (castData.getJSON()); // print it to the console in JSON format
                    }
                }
                else {
                    print (castData.getJSON()); // print it to the console in JSON format
                }
            }
        })
        
        // start the scanning
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it for BLE things.
            .then({_ in self.bluenet.startScanningForCrownstonesUniqueOnly()}) // once the lib is ready, start scanning
            .error({err in print("error in example II \(err)")}) // in case an error occurs, print it here.

    }
    
    /**
     *   EXAMPLE II: Scanning for all Crownstones
     *      The scanning will give us the peripheral UUIDs like "5F1534C4-37A6-9BB3-08F9-86E092AB19D7"
     *      We will use this uuid in the next example.
     */
    func scanForCrownstones(filterUUID: String? = nil) {
        // first we subscribe to the event that will tell us all about the scan results.
        self.bluenet.on("advertisementData", {data -> Void in
            if let castData = data as? Advertisement {
                if (filterUUID != nil) {
                    if (castData.handle == filterUUID) {
                         print (castData.getJSON()); // print it to the console in JSON format
                    }
                }
                else {
                    print (castData.getJSON()); // print it to the console in JSON format
                }
            }
        })
        
        // start the scanning
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it for BLE things.
            .then({_ in self.bluenet.startScanningForCrownstones()}) // once the lib is ready, start scanning
            .error({err in print("error in example II \(err)")}) // in case an error occurs, print it here.
    }
    
    /**
     *   EXAMPLE III: Scanning for all Crownstones
     *      The scanning will give us the peripheral UUIDs like "5F1534C4-37A6-9BB3-08F9-86E092AB19D7"
     *      We will use this uuid in the next example.
     */
    func scanForVerifiedCrownstones(filterUUID: String? = nil) {
        // first we subscribe to the event that will tell us all about the scan results.
        self.bluenet.on("verifiedAdvertisementData", {data -> Void in
            if let castData = data as? Advertisement {
                if (filterUUID != nil) {
                    if (castData.handle == filterUUID) {
                        print (castData.getJSON()); // print it to the console in JSON format
                    }
                }
                else {
                    print (castData.getJSON()); // print it to the console in JSON format
                }
            }
        })
        
        // start the scanning
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it for BLE things.
            .then({_ in self.bluenet.startScanningForCrownstones()}) // once the lib is ready, start scanning
            .error({err in print("error in example II \(err)")}) // in case an error occurs, print it here.
    }

    
    
    /**
     *   EXAMPLE IV: connecting to a device and disconnect again
     */
    func connectAndDisconnectForFun() {
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
            .then({_ in return self.bluenet.connect("5F1534C4-37A6-9BB3-08F9-86E092AB19D7")})
            .then({_ in return self.bluenet.disconnect()})
            .error({err in print("error in example III \(err)")})
    }
    
    /**
     *   EXAMPLE V: switching on a crownstone
     */
    func switchCrownstone() {
        // we return the promises so we can chain the then() calls.
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
            .then({_ in return self.bluenet.connect("5F1534C4-37A6-9BB3-08F9-86E092AB19D7")}) // connect
            .then({_ in return self.bluenet.power.switchRelay(1)}) // switch
            .then({_ in return self.bluenet.disconnect()}) // disconnect
            .error({err in print("error in example IV \(err)")}) // catch errors
    }
    
    
    /**
     *   EXAMPLE VI: set an ibeacon UUID
     */
    func setIBeaconUUID() {
        // we return the promises so we can chain the then() calls.
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
            .then({_ in return self.bluenet.connect("0660CB83-2456-87A9-FED7-CFBADA6C4175")}) // connect
            .then({_ in return self.bluenet.config.setIBeaconUUID("b643423e-e175-4af0-a2e4-31e32f729a8a")}) // switch
            .then({_ in return self.bluenet.disconnect()}) // disconnect
            .error({err in print("error in example V \(err)")}) // catch errors
    }
    
    
    /**
     *   EXAMPLE VII: track an ibeacon UUID
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
        // self.bluenetLocalization.trackIBeacon("ddb79713-87ca-4044-84f0-e87072db8106",groupId: "groupId")
        self.bluenetLocalization.trackIBeacon("a643423e-e175-4af0-a2e4-31e32f729a8a",groupId: "groupId")
        
    }

    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

