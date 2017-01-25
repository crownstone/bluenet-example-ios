//
//  ViewController.swift
//  Bluenet
//
//  Created by Alex de Mulder on 11/04/16.
//  Copyright © 2016 Alex de Mulder. All rights reserved.
//

import UIKit
import BluenetLib
import SwiftyJSON
import CoreBluetooth
import PromiseKit


class ViewController: UIViewController {
    var target : String? = nil
    var targetStoneHandle : String? = nil
    var targetSetupHandle : String? = nil
    var targetValidatedStoneHandle : String? = nil
    
    var lastSetup = Date().timeIntervalSince1970
    var lastStone = Date().timeIntervalSince1970
    var lastValidatedStone = Date().timeIntervalSince1970

    var selectedHandle : String?
    
    @IBAction func touchRecovery(_ sender: AnyObject) {
        if (target != nil) {
            self.bluenet.control.recoverByFactoryReset(target!)
                .then{_    in self.label.text = "done"}
                .catch{err in self.label.text = "\(err)"}
            label.text = "start recovery"
        }
        else {
            label.text = "no target"
        }
    }
    @IBAction func touchsetup(_ sender: AnyObject) {
        if (target != nil) {
            self.setupCrownstoneExample(target!)
            label.text = "Starting setup"
        }
        else {
            label.text = "no target"
        }
    }
    
    @IBAction func touchdfu(_ sender: AnyObject) {
        if (target != nil) {
            self.putInDFUMode(target!)
            label.text = "startDFUSetting"
        }
        else {
            label.text = "no target"
        }
    }
    
    @IBOutlet weak var scanDuration: UITextField!
    @IBAction func putScanDuration(_ sender: Any) {
        if (target != nil) {
            if (scanDuration.text != nil) {
                let scanDurationInt = Int(scanDuration.text!)
                if (scanDurationInt != nil) {
                    if (scanDurationInt! > 0) {
                        let scanDurationNS = NSNumber(value: scanDurationInt!)
                        self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
                            .then{_ in return self.bluenet.connect(self.target!)} // connect
                            .then{_ in return self.bluenet.config.setScanDuration(scanDurationNS)} // switch
                            .then{_ in return self.bluenet.control.disconnect()} // disconnect
                            .then{_ in self.label.text = "DONE setting setScanDuration to \(scanDurationNS)"}
                            .catch{err in
                                _ = self.bluenet.disconnect()
                                self.label.text = "\(err)"
                        } // catch errors
                        label.text = "Putting scanDuration"
                    }
                    else {
                        label.text = "invalid scanDuration"
                    }
                }
                else {
                    label.text = "invalid scanDuration"
                }
                
            }
            else {
                label.text = "no Scan Duration given"
            }
        }
        else {
            label.text = "no target"
        }

    }
    
    @IBOutlet weak var scanSendDelay: UITextField!
    @IBAction func putScanSendDelay(_ sender: Any) {
        if (target != nil) {
            if (scanSendDelay.text != nil) {
                let scanSendDelayInt = Int(scanSendDelay.text!)
                if (scanSendDelayInt != nil) {
                    if (scanSendDelayInt! > 0) {
                        let scanSendDelayNS = NSNumber(value: scanSendDelayInt!)
                        self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
                            .then{_ in return self.bluenet.connect(self.target!)} // connect
                            .then{_ in return self.bluenet.config.setScanSendDelay(scanSendDelayNS)} // switch
                            .then{_ in return self.bluenet.control.disconnect()} // disconnect
                            .then{_ in self.label.text = "DONE setting setScanDelay to \(scanSendDelayNS)"}
                            .catch{err in
                                _ = self.bluenet.disconnect()
                                self.label.text = "\(err)"
                        } // catch errors
                        label.text = "Putting setScanDelay"
                    }
                    else {
                        label.text = "invalid setScanDelay"
                    }
                }
                else {
                    label.text = "invalid setScanDelay"
                }
                
            }
            else {
                label.text = "no Scan Delay given"
            }
        }
        else {
            label.text = "no target"
        }
    }
    
    @IBOutlet weak var scanBreakDuration: UITextField!
    @IBAction func putScanBreakDuration(_ sender: Any) {
        if (target != nil) {
            if (scanBreakDuration.text != nil) {
                let scanBreakDurationInt = Int(scanBreakDuration.text!)
                if (scanBreakDurationInt != nil) {
                    if (scanBreakDurationInt! > 0) {
                        let scanBreakDurationNS = NSNumber(value: scanBreakDurationInt!)
                        self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
                            .then{_ in return self.bluenet.connect(self.target!)} // connect
                            .then{_ in return self.bluenet.config.setScanBreakDuration(scanBreakDurationNS)} // switch
                            .then{_ in return self.bluenet.control.disconnect()} // disconnect
                            .then{_ in self.label.text = "DONE setting setScanFilterDuration to \(scanBreakDurationNS)"}
                            .catch{err in
                                _ = self.bluenet.disconnect()
                                self.label.text = "\(err)"
                        } // catch errors
                        label.text = "Putting setScanFilterDuration"
                    }
                    else {
                        label.text = "invalid setScanFilterDuration"
                    }
                }
                else {
                    label.text = "invalid setScanFilterDuration"
                }
                
            }
            else {
                label.text = "no scan filter duration given"
            }
        }
        else {
            label.text = "no target"
        }
    }
    
    @IBOutlet weak var scanFilter: UITextField!
    @IBAction func putScanFilter(_ sender: Any) {
        if (target != nil) {
            if (scanFilter.text != nil) {
                let scanFilterInt = Int(scanFilter.text!)
                if (scanFilterInt != nil) {
                    if (scanFilterInt! > 0 && scanFilterInt! < 4) {
                        let scanFilterNS = NSNumber(value: scanFilterInt!)
                        self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
                            .then{_ in return self.bluenet.connect(self.target!)} // connect
                            .then{_ in return self.bluenet.config.setScanFilter(scanFilterNS)} // switch
                            .then{_ in return self.bluenet.control.disconnect()} // disconnect
                            .then{_ in self.label.text = "DONE setting setScanFilter to \(scanFilterNS)"}
                            .catch{err in
                                _ = self.bluenet.disconnect()
                                self.label.text = "\(err)"
                        } // catch errors
                        label.text = "Putting scanFilter"
                    }
                    else {
                        label.text = "invalid scanFilter"
                    }
                }
                else {
                    label.text = "invalid scanFilter"
                }
                
            }
            else {
                label.text = "no scan filter given"
            }
        }
        else {
            label.text = "no target"
        }
    }
    
    
    @IBOutlet weak var scanFilterFraction: UITextField!
    @IBAction func putScanFilterFraction(_ sender: Any) {
        if (target != nil) {
            if (scanFilterFraction.text != nil) {
                let scanFilterFractionInt = Int(scanFilterFraction.text!)
                if (scanFilterFractionInt != nil) {
                    if (scanFilterFractionInt! > 0) {
                        let scanFilterFractionNS = NSNumber(value: scanFilterFractionInt!)
                        self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
                            .then{_ in return self.bluenet.connect(self.target!)} // connect
                            .then{_ in return self.bluenet.config.setScanFilterFraction(scanFilterFractionNS)} // switch
                            .then{_ in return self.bluenet.control.disconnect()} // disconnect
                            .then{_ in self.label.text = "DONE setting scanFilterFractionNS to \(scanFilterFractionNS)"}
                            .catch{err in
                                _ = self.bluenet.disconnect()
                                self.label.text = "\(err)"
                        } // catch errors
                        label.text = "Putting scanFilterFractionNS"
                    }
                    else {
                        label.text = "invalid scanFilterFractionNS"
                    }
                }
                else {
                    label.text = "invalid scanFilterFractionNS"
                }
                
            }
            else {
                label.text = "no scan filter fraction given"
            }
        }
        else {
            label.text = "no target"
        }
    }
    
   
    @IBAction func targetSetup(_ sender: AnyObject) {
        if (targetSetupHandle != nil) {
            target = targetSetupHandle!
            label.text = "target set to setupStone"
            selectedHandle = target
        }
        else {
            label.text = "no target"
        }
    }
    @IBAction func targetStone(_ sender: AnyObject) {
        if (targetStoneHandle != nil) {
            target = targetStoneHandle!
            label.text = "target set to nearestStone"
            selectedHandle = target
        }
        else {
            label.text = "no target"
        }
    }
    @IBAction func targetValidated(_ sender: AnyObject) {
        if (targetValidatedStoneHandle != nil) {
            target = targetValidatedStoneHandle!
            label.text = "target set to nearestValidatedStone"
            selectedHandle = target
        }
        else {
            label.text = "no target"
        }
    }
    
    func _evalLabels() {
        let now = Date().timeIntervalSince1970
        if (now - lastSetup > 4) {
            targetSetupHandle = nil
            nearestSetup.text = "None found"
        }
        if (now - lastStone > 4) {
            targetStoneHandle = nil
            nearestStone.text = "None found"
        }
        if (now - lastValidatedStone > 4) {
            targetValidatedStoneHandle = nil
            nearestValidated.text = "None found"
        }
    }
    
    @IBAction func EncryptionSwitch(_ sender: AnyObject) {
        if let mySwitch = sender as? UISwitch {
            if (mySwitch.isOn) {
                self.bluenet.setSettings(encryptionEnabled: true, adminKey: "adminKeyForCrown", memberKey: "memberKeyForHome", guestKey: "guestKeyForGirls", collectionId:"test")
                label.text = "Toggled Encryption On"
            }
            else {
                self.bluenet.setSettings(encryptionEnabled: false, adminKey: "adminKeyForCrown", memberKey: "memberKeyForHome", guestKey: "guestKeyForGirls", collectionId:"test")
                label.text = "Toggled Encryption OFF"
            }

        }
    }
    @IBAction func pwm(_ sender: AnyObject) {
        if let slider = sender as? UISlider {
            //label.text = "not added yet: \(slider.value)"
            let value : Float = NSNumber(value: slider.value).floatValue
            if (target != nil) {
                // we return the promises so we can chain the then() calls.
                self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
                    .then{_ in return self.bluenet.connect(self.target!)} // connect
                    .then{_ in return self.bluenet.control.switchPWM(value)} // switch
                    .then{_ in return self.bluenet.control.disconnect()} // disconnect
                    .then{_ in self.label.text = "DONE switching PWM to \(value)"}
                    .catch{err in
                        _ = self.bluenet.disconnect()
                        self.label.text = "\(err)"
                } // catch errors
                label.text = "setting PWM"
            }
            else {
                label.text = "no target"
            }

        }
    }
    
    
    
    @IBAction func toggleReset(_ sender: AnyObject) {
        if (target != nil) {
            self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
                .then{_ in return self.bluenet.connect(self.target!)} // connect
                .then{_ in return self.bluenet.control.reset()} // switch
                .then{_ in return self.bluenet.control.disconnect()} // disconnect
                .then{_ in self.label.text = "DONE RESET"}
                .catch{err in
                    _ = self.bluenet.disconnect()
                    self.label.text = "\(err)"
            } // catch errors
            label.text = "PERFORMING RESET"
        }
        else {
            label.text = "no target"
        }

    }
    
    
    
    @IBAction func putPwmPeriod(_ sender: AnyObject) {
        if (target != nil) {
            if (pwmPeriod.text != nil) {
                let periodHzDouble = Double(pwmPeriod.text!)
                if (periodHzDouble != nil) {
                    if (periodHzDouble! > 0) {
                        let nr : Double = ((1.0/(periodHzDouble!))*1000.0*1000.0)
                        let periodNr = NSNumber(value: nr)
                        self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
                            .then{_ in return self.bluenet.connect(self.target!)} // connect
                            .then{_ in return self.bluenet.config.setPWMPeriod(periodNr)} // switch
                            .then{_ in return self.bluenet.control.disconnect()} // disconnect
                            .then{_ in self.label.text = "DONE switching PWM period to \(periodHzDouble)"}
                            .catch{err in
                                _ = self.bluenet.disconnect()
                                self.label.text = "\(err)"
                        } // catch errors
                        
                        label.text = "Putting PWM period"
                    }
                    else {
                        label.text = "invalid period"
                    }
                }
                else {
                   label.text = "invalid period"
                }
                
            }
            else {
                label.text = "no pwm period given"
            }
        }
        else {
            label.text = "no target"
        }
    }

    @IBOutlet weak var pwmPeriod: UITextField!
   
    @IBOutlet weak var pwmSlider: UISlider!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var RelaySwitch: UISwitch!
    @IBOutlet weak var EncSwitch: UISwitch!
    @IBOutlet weak var advblob: UITextView!
    @IBOutlet weak var selectedTarget: UILabel!
    @IBOutlet weak var label: UITextView!
    @IBOutlet weak var nearestSetup: UILabel!
    @IBOutlet weak var nearestStone: UILabel!
    @IBOutlet weak var nearestValidated: UILabel!
    @IBOutlet weak var innerview: UIView!
    
    var bluenet : Bluenet!
    var bluenetLocalization : BluenetLocalization!
    var bluenetMotion : BluenetMotion!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    
        
//        scrollview.contentSize = CGSize(width: self.view.frame.width, height: 1200)
        
        print("contentSize \(self.view.frame.width)")
        print("view start created")
        // Do any additional setup after loading the view, typically from a nib.
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    // here to check if the user succesfully switched the permissions
    func appMovedToForeground() {
        
    }
    
    @IBAction func relaySwitch(_ sender: AnyObject) {
        if let mySwitch = sender as? UISwitch {
            if (mySwitch.isOn) {
                switchRelayOn()
            }
            else {
               switchRelayOff()
            }
        }
    }
    
    func switchRelayOn() {
        if (target != nil) {
            // we return the promises so we can chain the then() calls.
            self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
                .then{_ in return self.bluenet.connect(self.target!)} // connect
                .then{_ in return self.bluenet.control.switchRelay(1)} // switch
                .then{_ in return self.bluenet.control.disconnect()} // disconnect
                .then{_ in self.label.text = "DONE switching relay on"}
                .catch{err in
                    _ = self.bluenet.disconnect()
                    self.label.text = "\(err)"
            } // catch errors
            label.text = "switchRelayOn"
        }
        else {
            label.text = "no target"
        }
    }
    func switchRelayOff() {
        if (target != nil) {
            // we return the promises so we can chain the then() calls.
            self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
                .then{_ in return self.bluenet.connect(self.target!)} // connect
                .then{_ in return self.bluenet.control.switchRelay(0)} // switch
                .then{_ in return self.bluenet.control.disconnect()} // disconnect
                .then{_ in self.label.text = "DONE switching relay off"}
                .catch{err in
                    _ = self.bluenet.disconnect()
                    self.label.text = "\(err)"
            } // catch errors
            label.text = "switchRelayOff"
        }
        else {
            label.text = "no target"
        }
    }
    
    @IBOutlet weak var adminkey: UITextField!
    @IBOutlet weak var guestkey: UITextField!
    @IBAction func putSettings(_ sender: Any) {
        if (target != nil) {
            label.text = "Setting Settings"
            self.bluenet.setSettings(encryptionEnabled: true, adminKey: adminkey.text, memberKey: nil, guestKey: guestkey.text, collectionId: "test")
        }
        else {
            label.text = "no target"
        }
    }
    
    
    @IBAction func revertDevKeys(_ sender: Any) {
        self._revertDevKeys()
        label.text = "Setting Settings to dev standard"
    }
    
    func _revertDevKeys() {
        self.bluenet.setSettings(encryptionEnabled: true, adminKey: "adminKeyForCrown", memberKey: "memberKeyForHome", guestKey: "guestKeyForGirls", collectionId: "test")
    }
    
    func startLoop() {
        delay(0.5, { _ in
            self._evalLabels()
            self.startLoop()
        })
    }
    
    @IBOutlet weak var CountingLabelReference: UILabel!
    var counter = 0
    
    override func viewDidAppear(_ animated: Bool) {
        self.nearestSetup.text = "None found"
        self.nearestStone.text = "None found"
        self.nearestValidated.text = "None found"
        self.EncSwitch.setOn(true, animated: false)
        self.RelaySwitch.isEnabled = false
        self.pwmSlider.isEnabled = false
        
        // temporary disable of encryption off switch
        // self.EncSwitch.isEnabled = false
        
        scrollview.isScrollEnabled = true
        // Do any additional setup after loading the view
        scrollview.contentSize = CGSize(width: self.view.frame.width, height: 1800)
        
        self.startLoop()
        // important, set the viewcontroller and the appname in the library so we can trigger 
        // alerts for bluetooth and navigation usage.
        BluenetLib.setBluenetGlobals(viewController: self, appName: "Crownstone", loggingFile: true)
        self.bluenet = Bluenet()
        self.bluenetLocalization = BluenetLocalization()
        //self.bluenetMotion = BluenetMotion()
        
        // default
        self._revertDevKeys()
    
        
        // forward the navigation event stream to react native
        _ = self.bluenetLocalization.on("iBeaconAdvertisement", {ibeaconData -> Void in
            var returnArray = [NSDictionary]()
            if let data = ibeaconData as? [iBeaconPacket] {
                for packet in data {
                    returnArray.append(packet.getDictionary())
                }
            }
            self.counter = self.counter + 1
            self.CountingLabelReference.text = "\(self.counter) + \(self.bluenetLocalization.indoorLocalizationEnabled)"
        })
        
        
        
        _ = self.bluenetLocalization.on("lowLevelEnterRegion", {data -> Void in
            if let castData = data as? String {
                print("$$$ lowLevelEnterRegion \(castData)")
            }
        })
         _ = self.bluenetLocalization.on("lowLevelExitRegion", {data -> Void in
            if let castData = data as? String {
                print("$$$ lowLevelExitRegion \(castData)")
            }
        })
        
        _ = self.bluenet.on("setupProgress", {data -> Void in
            if let castData = data as? Int {
                self.label.text = "setupProgress \(castData)"
            }
        })
        _ = self.bluenet.on("nearestCrownstone", {data -> Void in
            if let castData = data as? NearestItem {
                self.lastStone = Date().timeIntervalSince1970
                let dict = castData.getDictionary()
                self.targetStoneHandle = dict["handle"] as? String
                self.nearestStone.text = "\(dict["name"]!) : \(dict["rssi"]!)"
                self._evalLabels()
            }
        })
        _ = self.bluenet.on("nearestVerifiedCrownstone", {data -> Void in
            if let castData = data as? NearestItem {
                self.lastValidatedStone = Date().timeIntervalSince1970
                
                let dict = castData.getDictionary()
                self.targetValidatedStoneHandle = dict["handle"] as? String
                self.nearestValidated.text = "\(dict["name"]!) : \(dict["rssi"]!)"
                self._evalLabels()
            }
        })
        _ = self.bluenet.on("nearestSetupCrownstone", {data -> Void in
            if let castData = data as? NearestItem {
                self.lastSetup = Date().timeIntervalSince1970
                
                let dict = castData.getDictionary()
                self.targetSetupHandle = dict["handle"] as? String
                self.nearestSetup.text = "\(dict["name"]!) : \(dict["rssi"]!)"
                self._evalLabels()
            }
        })
        _ = self.bluenet.on("advertisementData", {data -> Void in
            if let castData = data as? Advertisement {
                let dict = castData.getDictionary()
              
                if (self.selectedHandle == dict["handle"] as? String) {
                    self.selectedTarget.text = "\(dict["name"]!) : \(dict["rssi"]!)"
                    
                    self.advblob.text = "\(dict)"
                    if (self.RelaySwitch.isEnabled == false) {
                        self.RelaySwitch.isEnabled = true
                    }
                    if (self.pwmSlider.isEnabled == false) {
                        self.pwmSlider.isEnabled = true
                    }
                    
                    let serviceData = dict["serviceData"] as! NSDictionary
                    let state = serviceData["switchState"] as! Int
                    
                    if (state > 100 && self.RelaySwitch.isOn == false) {
                        self.RelaySwitch.isOn = true
                        let pwmState = state - 128;
                        self.pwmSlider.value = NSNumber(value: pwmState).floatValue / 100.0
                        
                    }
                    else if (state < 100 && self.RelaySwitch.isOn == true) {
                        self.RelaySwitch.isOn = false
                        self.pwmSlider.value = NSNumber(value: state).floatValue / 100.0
                    }
                    
                }
            }
        })
        
        //self.bluenetLocalization.clearTrackedBeacons()
        _ = self.bluenet.isReady()
            .then{_ in self.bluenet.startScanningForCrownstones()}
        
        self.bluenetLocalization.startIndoorLocalization();
        self.bluenetLocalization.trackIBeacon(uuid: "1843423e-e175-4af0-a2e4-31e32f729a8a", collectionId: "57f387e61153bd03000eb632")
    }

    
    func putInDFUMode(_ uuid: String) {
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it for BLE things.
            .then{_ in self.bluenet.connect(uuid)} // once the lib is ready, start scanning
            .then{_ in self.bluenet.control.putInDFU()}
            .then{_ -> Void in
                print("DONE")
                self.label.text = "DFU DONE"
                _ = self.bluenet.disconnect()
            }
            .catch{err in
                print("end of line \(err)")
                _ = self.bluenet.disconnect()
        }
    }
    
    func setupCrownstoneExample(_ uuid: String) {
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it for BLE things.
            .then{_ in return self.bluenet.connect(uuid)} // once the lib is ready, start scanning
            .then{_ in self.bluenet.setup.setup(crownstoneId: 32, adminKey: "adminKeyForCrown", memberKey: "memberKeyForHome", guestKey: "guestKeyForGirls", meshAccessAddress: "4f745905", ibeaconUUID: "1843423e-e175-4af0-a2e4-31e32f729a8a", ibeaconMajor: 123, ibeaconMinor: 456)} // once the lib is ready, start scanning
            .then{_ -> Void in
                self.label.text = "SETUP COMPLETE"
                print("DONE")
            }
            .catch{err in
                print("end of line \(err)")
                _ = self.bluenet.disconnect()
            }
    }
    
    /**
     *   EXAMPLE: Scanning for all BLE devices
     *      The scanning will give us the peripheral UUIDs like "5F1534C4-37A6-9BB3-08F9-86E092AB19D7"
     *      We will use this uuid in the next example.
     */
    func scanForBleDevices() {
        // first we subscribe to the event that will tell us all about the scan results.
        let unsubscribe = self.bluenet.on("advertisementData", {data -> Void in
            if let castData = data as? Advertisement {
                print(castData.getDictionary())
            }
        })
        
        // start the scanning
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it for BLE things.
            .then{_ in self.bluenet.startScanning()} // once the lib is ready, start scanning
            .catch{err in print("error in example I \(err)")} // in case an error occurs, print it here.
    }
    
    /**
     *   EXAMPLE: Scanning for all BLE devices
     *      The scanning will give us the peripheral UUIDs like "5F1534C4-37A6-9BB3-08F9-86E092AB19D7"
     *      We will use this uuid in the next example.
     */
    func scanForCrownstonesUnique(_ filterUUID: String? = nil) {
        // first we subscribe to the event that will tell us all about the scan results.
        let unsubscribe = self.bluenet.on("advertisementData", {data -> Void in
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
            .then{_ in self.bluenet.startScanningForCrownstonesUniqueOnly()} // once the lib is ready, start scanning
            .catch{err in print("error in example II \(err)")} // in case an error occurs, print it here.

    }
    
    /**
     *   EXAMPLE: Scanning for all BLE devices
     *      The scanning will give us the peripheral UUIDs like "5F1534C4-37A6-9BB3-08F9-86E092AB19D7"
     *      We will use this uuid in the next example.
     */
    func scanForVerifiedCrownstonesUnique(_ filterUUID: String? = nil) {
        // first we subscribe to the event that will tell us all about the scan results.
        let unsubscribe = self.bluenet.on("verifiedAdvertisementData", {data -> Void in
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
            .then{_ in self.bluenet.startScanningForCrownstonesUniqueOnly()} // once the lib is ready, start scanning
            .catch{err in print("error in example II \(err)")} // in case an error occurs, print it here.
        
    }
    
    /**
     *   EXAMPLE: Scanning for all Crownstones
     *      The scanning will give us the peripheral UUIDs like "5F1534C4-37A6-9BB3-08F9-86E092AB19D7"
     *      We will use this uuid in the next example.
     */
    func scanForCrownstones(_ filterUUID: String? = nil) {
        // first we subscribe to the event that will tell us all about the scan results.
        let unsubscribe = self.bluenet.on("advertisementData", {data -> Void in
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
            .then{_ in self.bluenet.startScanningForCrownstones()} // once the lib is ready, start scanning
            .catch{err in print("error in example II \(err)")} // in case an error occurs, print it here.
    }
    
    /**
     *   EXAMPLE: Scanning for all Crownstones
     *      The scanning will give us the peripheral UUIDs like "5F1534C4-37A6-9BB3-08F9-86E092AB19D7"
     *      We will use this uuid in the next example.
     */
    func scanForVerifiedCrownstones(_ filterUUID: String? = nil) {
        // first we subscribe to the event that will tell us all about the scan results.
        let unsubscribe = self.bluenet.on("verifiedAdvertisementData", {data -> Void in
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
            .then{_ in self.bluenet.startScanningForCrownstones()} // once the lib is ready, start scanning
            .catch{err in print("error in example II \(err)")} // in case an error occurs, print it here.
    }

    
    
    /**
     *   EXAMPLE: connecting to a device and disconnect again
     */
    func connectAndDisconnectForFun() {
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
            .then{_ in return self.bluenet.connect("5F1534C4-37A6-9BB3-08F9-86E092AB19D7")}
            .then{_ in return self.bluenet.disconnect()}
            .catch{err in print("error in example III \(err)")}
    }
    
    /**
     *   EXAMPLE V: switching on a crownstone
     */
    func switchCrownstone() {
        // we return the promises so we can chain the then() calls.
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
            .then{_ in return self.bluenet.connect("5F1534C4-37A6-9BB3-08F9-86E092AB19D7")} // connect
            .then{_ in return self.bluenet.power.switchRelay(1)} // switch
            .then{_ in return self.bluenet.disconnect()} // disconnect
            .catch{err in print("error in example IV \(err)")} // catch errors
    }
    
    
    /**
     *   EXAMPLE: set an ibeacon UUID
     */
    func setIBeaconUUID() {
        // we return the promises so we can chain the then() calls.
        self.bluenet.isReady() // first check if the bluenet lib is ready before using it.
            .then{_ in return self.bluenet.connect("0660CB83-2456-87A9-FED7-CFBADA6C4175")} // connect
            .then{_ in return self.bluenet.config.setIBeaconUUID("b643423e-e175-4af0-a2e4-31e32f729a8a")} // switch
            .then{_ in return self.bluenet.disconnect()} // disconnect
            .catch{err in print("error in example V \(err)")} // catch errors
    }
    
    
    /**
     *   EXAMPLE: track an ibeacon UUID
     */
    func trackIBeacon(_ uuid: String) {
        // listen to the ibeacon events that will be received
        let unsubscribe = self.bluenetLocalization.on("iBeaconAdvertisement", {ibeaconData -> Void in
            var stringArray = [JSON]()
            if let data = ibeaconData as? [iBeaconPacket] {
                for packet in data {
                    stringArray.append(packet.getJSON())
                }
            }
            print(stringArray)
        })
        
        // track the ibeaconUUID
        self.bluenetLocalization.trackIBeacon(uuid: uuid, collectionId: "ref")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

