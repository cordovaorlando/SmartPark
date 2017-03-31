//
//  ViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 9/5/16.
//  Copyright © 2016 Jose Cordova. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, HomeModelProtocal, AVCaptureMetadataOutputObjectsDelegate{
    
    @IBOutlet weak var mySwitch: UISwitch!
  

    @IBOutlet weak var messageLabel: UILabel!
    var bCode = String()
    var seguePerformed = false
    var seguePerformed2 = false

    var flashOff = false
    
    let settingsVC = SettingsViewController()
    
    var finalTotalInt = Float()
    var SERVICE_FEE:Float = 2.00


    var LocationNamesString = String()
    var LocationPricesString = String()
    var qrCodeString = String()
    var LocationIDString = String()
    
    var scanText = String()

    
    
    var feedItems: NSArray = NSArray()
    var feedItems2: NSArray = NSArray()
    var feedItems3: NSArray = NSArray()
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        mySwitch.tintColor = UIColor.white
        mySwitch.onTintColor = UIColor.white
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()
        
        seguePerformed = false
        seguePerformed2 = false
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            view.bringSubview(toFront: messageLabel)
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            print(error)
            return
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        messageLabel.text = "No barcode/QR code is detected"
        
        seguePerformed = false
        seguePerformed2 = false

        
        if (captureSession?.isRunning == false) {
            captureSession?.startRunning();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession?.stopRunning();
        }
        
        mySwitch.setOn(flashOff, animated: flashOff)
      
    }
    
    
    func itemsDownloaded(_ items: NSArray, _ items2: NSArray, _ items3: NSArray) {
        
        feedItems = items
        
        feedItems2 = items2
        
        feedItems3 = items3
        
            }
    
        


    
    
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {

        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No barcode/QR code is detected"
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
            if supportedBarCodes.contains(metadataObj.type) {
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
                bCode = metadataObj.stringValue
                
                if self.seguePerformed == false {
                
                    
                scanText = bCode
                    
                let index = scanText.index(scanText.startIndex, offsetBy: 1)
                var locationID = scanText.substring(to: index)
                
                
                let index2 = scanText.index(scanText.startIndex, offsetBy: 1)
                var ticketNumber = scanText.substring(from: index2)
                
                
                
                    let myUrl = URL(string: "http://spvalet.com/locs.php");
                    var request = URLRequest(url:myUrl!)
                    request.httpMethod = "POST"// Compose a query string
                    let postString = "id=\(locationID)&ticket=\(ticketNumber)";
                    request.httpBody = postString.data(using: String.Encoding.utf8);
                    let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                        if error != nil
                        {
                            print("error=\(error)")
                            return
                        }
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            if let parseJSON = json {
                                let resultValue = parseJSON["status"] as? String
                                let id = parseJSON["LocationID"] as? String
                                let restaurantName = parseJSON["LocationName"] as? String
                                let qrCode = parseJSON["TicketNumber"] as? String
                                let price = parseJSON["Price"] as? String
                                //print("Status: \(resultValue!)")
                                if(resultValue == "Success"){
                                    //self.locationID = resultValue3!
                                    print("It Works yes, go in!")
                                    self.LocationNamesString = restaurantName!
                                    self.LocationPricesString = price!
                                    self.qrCodeString = qrCode!
                                    self.LocationIDString = id!
                                     DispatchQueue.main.async(execute: { () -> Void in
                                        if self.seguePerformed2 == false {
                                            
                                            
                                            self.finalTotalInt = (Float(self.LocationPricesString)! + self.SERVICE_FEE)
                                            
                                            
                                            
                                            let checkoutViewController = CheckoutViewController(product: "SmartPark",
                                                                                                price: Int(self.finalTotalInt)*100,
                                                                                                settings: self.settingsVC.settings)
                                            
                                            print("Test inside the if statement")
                                            
                                            checkoutViewController.message = self.qrCodeString
                                            checkoutViewController.feedItems = self.LocationNamesString
                                            checkoutViewController.feedItems2 = self.LocationPricesString
                                            checkoutViewController.locationId = self.LocationIDString
                                            
                                            self.navigationController?.pushViewController(checkoutViewController, animated: true)
                                            
                                            self.seguePerformed2 = true;
                                        }
                                        self.seguePerformed = true;
                                    })
                                }else{
                                    
                                  /*  OperationQueue.main.addOperation {
                                        let alertController = UIAlertController(title: "Error", message: "Invalid Ticket Number.", preferredStyle: .alert)
                                        
                                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                        alertController.addAction(defaultAction)
                                        
                                        self.present(alertController, animated: true, completion: nil)
                                    }*/
                                }
                            }
                        } catch {
                            print(error)
                            print("Sorry, you need to register first!")
                        }
                    }
                    task.resume()
                
                }
                
                
            }
                
                //downloadData()
        }
        
     //Good so far   downloadData()
        
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        print(sender.isOn ? "on" : "off")
        
        if sender.isOn == true{
            toggleTorch(on: true)
        }
        else{
        toggleTorch(on: false)
        }
    }
    
    
    func downloadData(){
        
        /*  textFieldText = ticketCodeField.text!
         
         if feedItems3.contains(textFieldText) {
         let index = feedItems3.index(of: textFieldText)
         
         if !self.seguePerformed {
         
         
         let variable = (feedItems2[index] as AnyObject).description
         finalTotalInt = (Float(variable!)! + SERVICE_FEE)
         
         
         let checkoutViewController = CheckoutViewController(product: "Product Name",
         price: Int(finalTotalInt)*100,
         settings: self.settingsVC.settings)
         
         
         dismissKeyboard()
         
         let backItem = UIBarButtonItem()
         backItem.title = "Back"
         navigationItem.backBarButtonItem = backItem
         
         checkoutViewController.message = textFieldText
         checkoutViewController.feedItems = feedItems
         checkoutViewController.feedItems2 = feedItems2
         checkoutViewController.bCodeIndex = index
         
         
         
         self.navigationController?.pushViewController(checkoutViewController, animated: true)
         
         self.seguePerformed = true
         
         
         }
         
         } else {
         
         }*/
        
        var jsonElement: NSDictionary = NSDictionary()
        
        scanText = bCode
        
        let index = scanText.index(scanText.startIndex, offsetBy: 1)
        var locationID = scanText.substring(to: index)
        
        
        let index2 = scanText.index(scanText.startIndex, offsetBy: 1)
        var ticketNumber = scanText.substring(from: index2)
        
        
        
        let myUrl = URL(string: "http://spvalet.com/Locations.php");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"// Compose a query string
        let postString = "firstName=\(locationID)&lastName=\(ticketNumber)";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }// You can print out response object
            // print("response = \(response!)")
            //Let's convert response sent from a server side script to a NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray
                
                jsonElement = json?[0] as! NSDictionary
                
                if let id = jsonElement["LocationID"] as? String,
                    let restaurantName = jsonElement["LocationName"] as? String,
                    let qrCode = jsonElement["TicketNumber"] as? String,
                    let price = jsonElement["Price"] as? String
                    
                {
                    //  self.LocationNamesArray.append(restaurantName)
                    //  self.LocationPricesArray.append(price)
                    //  self.qrCodeArray.append(qrCode)
                    //  self.LocationIDArray.append(id)
                    
                    self.LocationNamesString = restaurantName
                    self.LocationPricesString = price
                    self.qrCodeString = qrCode
                    self.LocationIDString = id
                    
                    
                    
                    
                    //  self.pushToCheckOut()
                    
                    
                }
                
                print("Location Name:\(self.LocationNamesString)")
                print("Location Price: \(self.LocationPricesString)")
                print("Ticket Number: \(self.qrCodeString)")
                print("Location ID: \(self.LocationIDString)")
                print()
                
                //                self.performSegue(withIdentifier: "continueButton", sender: self)
                
                
                
             /*   if !self.seguePerformed {
                
                //DispatchQueue.main.async(execute: { () -> Void in
                    
                    //let variable = (feedItems2[index] as AnyObject).description
                    self.finalTotalInt = (Float(self.LocationPricesString)! + self.SERVICE_FEE)
                    
                    let checkoutViewController = CheckoutViewController(product: "SmartPark",
                                                                        price: Int(self.finalTotalInt)*100,
                                                                        settings: self.settingsVC.settings)
                    
                    //self.dismissKeyboard()
                    
                    print("Test inside the if statement")
                    
                    checkoutViewController.message = self.qrCodeString
                    checkoutViewController.feedItems = self.LocationNamesString
                    checkoutViewController.feedItems2 = self.LocationPricesString
                    //checkoutViewController.bCodeIndex = index
                    
                    
                    
                    self.navigationController?.pushViewController(checkoutViewController, animated: true)
                    
                    self.seguePerformed = true;
                    
                //})
                
                }*/
                
                
                
            } catch {
                print(error)
                print("Scanner Something's bad!")
            }
            
            
        }
        task.resume()
        
        
        
        
        
    }


    
    
    
}

