//
//  PaymentViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 10/16/16.
//  Copyright © 2016 Jose Cordova. All rights reserved.
//

import UIKit
import Pods_SmartPark
import Stripe

class StripeCardVC: UIViewController, STPPaymentCardTextFieldDelegate {
    
    @IBOutlet weak var btnBuy: UIButton!
    
    
    
    let cardParams = STPCardParams()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let paymentField = STPPaymentCardTextField(frame: CGRect(x: 10, y: 100, width:self.view.frame.size.width - 20, height: 44))
        paymentField.delegate = self
        self.view.addSubview(paymentField)
        // Do any additional setup after loading the view.
        
        self.btnBuy.isEnabled = paymentField.isValid
        btnBuy.backgroundColor = UIColor.gray
    }
    
    // MARK: STPPaymentCardTextFieldDelegate
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        print("Card number: \(textField.cardParams.number) Exp Month: \(textField.cardParams.expMonth) Exp Year: \(textField.cardParams.expYear) CVC: \(textField.cardParams.cvc)")
        self.btnBuy.isEnabled = textField.isValid
        
        if btnBuy.isEnabled {
            btnBuy.backgroundColor = UIColor.blue
            cardParams.number = textField.cardParams.number
            cardParams.expMonth = textField.cardParams.expMonth
            cardParams.expYear = textField.cardParams.expYear
            cardParams.cvc = textField.cardParams.cvc
        }
    }
    
    @IBAction func actionGetStripeToken() {
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            if let error = error {
                // show the error to the user
                print(error)
                self.showAlertButtonTapped(strTitle: "Error", strMessage: error.localizedDescription)
            } else if let token = token {
                //Send token to backend for process
                print(token)
                self.showAlertButtonTapped(strTitle: "Success", strMessage: "Got Token Successfully")
            }
        }
    }
    
    
    //MARK:- AlerViewController
    func showAlertButtonTapped(strTitle:String, strMessage:String) {
        // create the alert
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func actionBack(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
