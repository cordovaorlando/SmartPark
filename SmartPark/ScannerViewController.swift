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
    var flashOff = false
    
    let settingsVC = SettingsViewController()
    
    
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
                
                
                
                if feedItems3.contains(bCode) {
                    let index = feedItems3.index(of: bCode)
                
                if !self.seguePerformed {
                
                    
                    let checkoutViewController = CheckoutViewController(product: "Product Name",
                                                                        price: 100,
                                                                        settings: self.settingsVC.settings)
                    
                    checkoutViewController.message = bCode
                    checkoutViewController.feedItems = feedItems
                    checkoutViewController.feedItems2 = feedItems2
                    checkoutViewController.bCodeIndex = index
                    
                    let backItem = UIBarButtonItem()
                    backItem.title = "Back"
                    navigationItem.backBarButtonItem = backItem

                    self.navigationController?.pushViewController(checkoutViewController, animated: true)
                    
                    self.seguePerformed = true
            
                }
                    
                } else {
                    messageLabel.text = "Not a valid QRCode - sorry"
                }
            }
        }
        
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

    
    
    
}

