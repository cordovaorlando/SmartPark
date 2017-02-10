//
//  CheckoutViewController.swift
//  SmartPark
//
//  Created by Jose Cordova on 10/10/16.
//  Copyright © 2016 Jose Cordova. All rights reserved.
//

import UIKit
import Stripe

class CheckoutViewController: UIViewController, STPPaymentContextDelegate {
    
    
    let settingsViewC = SettingsViewController()
    
    var initialTip = 2
    var totalInt = Float()
    var subtotalInt = Float()
    var feeInt = Float()
    var tipInt = Float()
    var finalTotalInt: Float = 10.00
    var finalTotalInt2 = Float()
    var SERVICE_FEE:Float = 2.00
    //var feedItems: NSArray = NSArray()
    //var feedItems2: NSArray = NSArray()
    var feedItems = String()
    var feedItems2 = String()
    
    var bCodeIndex = Int()
    var message = String()
    
    var emailHeader = String()
    var emailBody = String()
    var restName = String()
    
    //hold date data for the emails sent
    var currentDate = NSDate()
    let dateFormatter = DateFormatter()
    var convertedDate = String()
    var finalEmailTotal = Float()
    var tipEmail = Float()
    var subtotalEmail = String()
    
    var num: Int = 500
    
    
    
    let companyName = "SmartPark"               // Apple Pay Variables
    let paymentCurrency = "usd"                 // Apple Pay Variables
    var paymentContext: STPPaymentContext
    let theme: STPTheme
    let paymentRow: CheckoutRowView
    let subtotalRow: CheckoutRowView
    let serviceFeeRow: CheckoutRowView
    let tipRow: CheckoutRowView
    let totalRow: CheckoutRowView
    let buyButton: BuyButton
    let rowHeight: CGFloat = 44
    let restaurantName = UILabel()
    let totalText = UILabel()
    let tipLabel = UILabel()
    var slider: UISlider = UISlider()
    
    let stripePublishableKey = "pk_test_Nxy4IoZXCoOVppUkWdFH7eOv"
    let backendBaseURL: String? = "https://lsus-smartpark.herokuapp.com/"
    let appleMerchantID: String? = "merchant.smartParkIdentifier"
    
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var product = ""
    var paymentInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                if self.paymentInProgress {
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.alpha = 1
                    self.buyButton.alpha = 0
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                    self.buyButton.alpha = 1
                }
                }, completion: nil)
        }
    }

    
    
    
    init(product: String, price: Int, settings: Settings) {
        self.product = product
        
        self.theme = settings.theme
        self.paymentRow = CheckoutRowView(title: "Payment", detail: "Select Payment",
                                          theme: settings.theme)
        
        self.subtotalRow = CheckoutRowView(title: "Subtotal", detail: "", tappable: false,
                                        theme: settings.theme)
        self.serviceFeeRow = CheckoutRowView(title: "Service Fee", detail: "", tappable: false,
                                        theme: settings.theme)
        
        self.tipRow = CheckoutRowView(title: "Tip", detail: "", tappable: false,
                                        theme: settings.theme)
        
        self.totalRow = CheckoutRowView(title: "Total", detail: "", tappable: false,
                                        theme: settings.theme)
        
        self.buyButton = BuyButton(enabled: true, theme: settings.theme)
        MyAPIClient.sharedClient.baseURLString = self.backendBaseURL
        
        let config = STPPaymentConfiguration.shared()
        paymentContext = STPPaymentContext(apiAdapter: MyAPIClient.sharedClient,
                                           configuration: config,
                                           theme: settings.theme)

        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        intializeLabels()
        
        tipRow.detail = "$\(initialTip).00"
        tipEmail = Float(initialTip)
    }
    
    
    func intializeLabels(){
        self.restaurantName.text = feedItems
        self.totalText.text = "$" + (feedItems2)
        self.tipLabel.text = "Tip: $\(initialTip)"
        
        
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 248.0/255, green: 146.0/255, blue: 35.0/255, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes =
          [NSForegroundColorAttributeName: UIColor.white]
        self.navigationItem.title = "#" + message        
        
        subtotalRow.detail = totalText.text!
        
        self.serviceFeeRow.detail = "$\(String(format: "%.2f", SERVICE_FEE))"
        self.tipRow.detail = "$\(String(format: "%.2f", initialTip))"
        
        let variable = (feedItems2)
        finalTotalInt = (Float(variable)! + SERVICE_FEE + Float(initialTip))
        
        self.totalRow.detail = "$\(String(format: "%.2f", finalTotalInt))"
        finalEmailTotal = finalTotalInt
        self.paymentRow.onTap = { [weak self] _ in
            self?.paymentContext.pushPaymentMethodsViewController()
        }
        
        
        dateFormatter.dateStyle = DateFormatter.Style.long
        convertedDate = dateFormatter.string(from: currentDate as Date)
        convertedDate = dateFormatter.string(from: currentDate as Date)
        
        restName = restaurantName.text!
        subtotalEmail = totalText.text!
        
        
        
        slider.minimumValue = 0
        slider.maximumValue = 30
        slider.isContinuous = true
        slider.tintColor = UIColor.orange
        slider.value = 2
        slider.isUserInteractionEnabled = true
        slider.addTarget(self, action: #selector(CheckoutViewController.valueChanged(_:)), for: .valueChanged)
        
        
        finalTotalInt2 = finalTotalInt
        
        let config = STPPaymentConfiguration.shared()
        config.publishableKey = self.stripePublishableKey
        config.appleMerchantIdentifier = self.appleMerchantID
        config.companyName = self.companyName
        config.requiredBillingAddressFields = settingsViewC.settings.requiredBillingAddressFields
        config.additionalPaymentMethods = settingsViewC.settings.additionalPaymentMethods
        config.smsAutofillDisabled = !settingsViewC.settings.smsAutofillEnabled
        
        var paymentContext = STPPaymentContext(apiAdapter: MyAPIClient.sharedClient,
                                               configuration: config,
                                               theme: settingsViewC.settings.theme)
        let userInformation = STPUserInformation()
        paymentContext.prefilledInformation = userInformation
        
        paymentContext.paymentAmount = Int(finalTotalInt2)*100
        paymentContext.paymentCurrency = self.paymentCurrency
        
        self.paymentContext = paymentContext
        self.paymentContext.delegate = self
        paymentContext.hostViewController = self
        
        
        self.view.backgroundColor = self.theme.primaryBackgroundColor
        var red: CGFloat = 0
        self.theme.primaryBackgroundColor.getRed(&red, green: nil, blue: nil, alpha: nil)
        self.activityIndicator.activityIndicatorViewStyle = red < 0.5 ? .white : .gray
        
        
        self.restaurantName.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.totalText.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.view.addSubview(self.subtotalRow)
        self.view.addSubview(self.serviceFeeRow)
        self.view.addSubview(self.tipRow)
        self.view.addSubview(self.totalRow)
        self.view.addSubview(self.paymentRow)
        self.view.addSubview(self.restaurantName)
        self.view.addSubview(self.totalText)
        self.view.addSubview(self.tipLabel)
        self.view.addSubview(self.slider)
        self.view.addSubview(self.buyButton)
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.alpha = 0
        self.buyButton.addTarget(self, action: #selector(didTapBuy), for: .touchUpInside)
        

    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = self.view.bounds.width
        
        self.restaurantName.sizeToFit()
        self.restaurantName.center = CGPoint(x: width/2.0, y: 85)
        
        self.totalText.sizeToFit()
        self.totalText.center = CGPoint(x: width/2.0, y: 105)
        
        
        self.paymentRow.frame = CGRect(x: 0, y: self.totalText.frame.maxY + rowHeight,
                                       width: width, height: rowHeight)
        
        self.tipLabel.sizeToFit()
        self.tipLabel.frame = CGRect(x: width/2.5, y: self.paymentRow.frame.maxY + rowHeight/2, width: 100, height: 20)
        
        self.slider.sizeToFit()
        self.slider.frame = CGRect(x: 30, y: self.tipLabel.frame.maxY + rowHeight/4, width: 250, height: 20)

        
        self.subtotalRow.frame = CGRect(x: 0, y: self.slider.frame.maxY + rowHeight,
                                        width: width, height: rowHeight)
        
        
        self.serviceFeeRow.frame = CGRect(x: 0, y: self.subtotalRow.frame.maxY,
                                   width: width, height: rowHeight)
        
        self.tipRow.frame = CGRect(x: 0, y: self.serviceFeeRow.frame.maxY,
                                   width: width, height: rowHeight)
    
    
        self.totalRow.frame = CGRect(x: 0, y: self.tipRow.frame.maxY,
                                         width: width, height: rowHeight)
        
        self.buyButton.frame = CGRect(x: 0, y: 0, width: 88, height: 44)
        self.buyButton.center = CGPoint(x: width/2.0, y: self.totalRow.frame.maxY+45)
        self.activityIndicator.center = self.buyButton.center
    }

    func didTapBuy() {
        self.paymentInProgress = true
        self.paymentContext.requestPayment()
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        MyAPIClient.sharedClient.completeCharge(paymentResult, amount: self.paymentContext.paymentAmount,
                                                completion: completion)

    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        self.paymentInProgress = false
    
                let title: String
                let message: String
                switch status {
                case .error:
                    title = "Error"
                    message = error?.localizedDescription ?? ""
                case .success:
                    title = "Thank You"
                    message = "Your car is on its way!"
                    
                    sendCustomerEmail()
                    
                    unowned let unownedSelf = self
                    
                    let deadlineTime = DispatchTime.now() + .seconds(2)
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                        unownedSelf.sendToRoot()
                    })
                    
                    
                case .userCancellation:
                    return
                }
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    // MARK: STPPaymentContextDelegate

    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        self.paymentRow.loading = paymentContext.loading
        if let paymentMethod = paymentContext.selectedPaymentMethod {
            self.paymentRow.detail = paymentMethod.label
        }
        else {
            self.paymentRow.detail = "Select Payment"
        }
    }

    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Need to assign to _ because optional binding loses @discardableResult value
            // https://bugs.swift.org/browse/SR-1681
            _ = self.navigationController?.popViewController(animated: true)
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.paymentContext.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    func valueChanged(_ sender: UISlider)
    {
        
        
        let roundedStepValue = round(sender.value / 1) * 1
        sender.value = roundedStepValue
    
        let currentValue = Int(sender.value)
        
        tipLabel.text = "Tip: $\(currentValue)"
        tipRow.detail = "$\(currentValue).00"
        let newTotal = (finalTotalInt -  Float(initialTip)) + Float(currentValue)
        totalRow.detail = "$\(String(format: "%.2f", newTotal))"
        
        finalTotalInt2 = finalTotalInt + Float(currentValue)
        paymentContext.paymentAmount = Int(finalTotalInt2)*100
        
        finalEmailTotal = finalTotalInt + Float(currentValue)
        
        tipEmail = Float(currentValue)
        

        
    }
    
    
    func sendToRoot(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func sendToTimer(){
        
        let destView = UIViewController()
        self.navigationController?.pushViewController(destView, animated: true)
    }
    
    
    func sendCustomerEmail(){
        
        var rowData = String()
        
            rowData = "<tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; border-top-width: 1px; border-top-color: #eee; border-top-style: solid; margin: 0; padding: 5px 0;\" valign=\"top\">Valet Parking Service</td><td class=\"alignright\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: right; border-top-width: 1px; border-top-color: #eee; border-top-style: solid; margin: 0; padding: 5px 0;\" align=\"right\" valign=\"top\">" + subtotalEmail + "</td></tr>"
        
        //email header
        emailHeader = "from=SmartPark <sales@spvalet.com>&to=John Doe <cordovaorlando@hotmail.com>&subject=We've received your order! Order #12345&text= Thanks for your order!"
        
        //email body
        emailBody = "&html=<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\" style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box;font-size: 14px; margin: 0;\"><head><meta name=\"viewport\" content=\"width=device-width\" /><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /><title>Billing e.g. invoices and receipts</title><style type=\"text/css\">img {max-width: 100%;}body {-webkit-font-smoothing: antialiased; -webkit-text-size-adjust: none; width: 100% !important; height: 100%; line-height: 1.6em;}body {background-color: #f6f6f6;}@media only screen and (max-width: 640px) {body {padding: 0 !important;}h1 {font-weight: 800 !important; margin: 20px 0 5px !important;}h2 {font-weight: 800 !important; margin: 20px 0 5px !important;}h3 {font-weight: 800 !important; margin: 20px 0 5px !important;}h4 {font-weight: 800 !important; margin: 20px 0 5px !important;}h1 {font-size: 22px !important;}h2 {font-size: 18px !important;}h3 {font-size: 16px !important;}.container {padding: 0 !important; width: 100% !important;}.content {padding: 0 !important;}.content-wrap {padding: 10px !important;}.invoice {width: 100% !important;}}</style></head><body itemscope itemtype=\"http://schema.org/EmailMessage\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing:border-box; font-size: 14px; -webkit-font-smoothing: antialiased; -webkit-text-size-adjust: none; width: 100% !important; height: 100%;line-height: 1.6em; background-color: #f6f6f6; margin: 0;\" bgcolor=\"#f6f6f6\"><table class=\"body-wrap\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; background-color: #f6f6f6; margin: 0;\" bgcolor=\"#f6f6f6\"><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0;\" valign=\"top\"></td><td class=\"container\" width=\"600\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; display: block !important; max-width: 600px !important; clear: both !important; margin: 0 auto;\" valign=\"top\"><div class=\"content\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; max-width: 600px; display: block; margin: 0 auto; padding: 20px;\"><table class=\"main\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; border-radius: 3px; background-color: #fff; margin: 0; border: 1px solid #e9e9e9;\" bgcolor=\"#fff\"><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><td class=\"content-wrap aligncenter\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: center; margin: 0; padding: 20px;\" align=\"center\" valign=\"top\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><td class=\"content-block\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;\" valign=\"top\"><h1 class=\"aligncenter\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,'Lucida Grande',sans-serif; box-sizing: border-box; font-size: 32px; color: #000; line-height: 1.2em; font-weight: 500; text-align: center; margin: 40px 0 0;\" align=\"center\">$" + finalEmailTotal.description + "0 Paid</h1></td></tr><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><td class=\"content-block\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;\" valign=\"top\"><h2 class=\"aligncenter\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,'Lucida Grande',sans-serif; box-sizing: border-box; font-size: 24px; color: #000; line-height: 1.2em; font-weight: 400; text-align: center; margin: 40px 0 0;\" align=\"center\">Thanks for using SmartPark Inc.</h2></td></tr><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><td class=\"content-block aligncenter\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: center; margin: 0; padding: 0 0 20px;\" align=\"center\" valign=\"top\"><table class=\"invoice\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; text-align: left; width: 80%; margin: 40px auto;\"><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 5px 0;\" valign=\"top\">" + restName + "<br style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />Invoice #12345<br style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" />" + convertedDate + "</td></tr><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 5px 0;\" valign=\"top\"><table class=\"invoice-items\" cellpadding=\"0\" cellspacing=\"0\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; margin: 0;\">" + rowData +
            
            
            "<tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; border-top-width: 1px; border-top-color: #eee; border-top-style: solid; margin: 0; padding: 5px 0;\" align=\"right\" valign=\"top\">Subtotal</td><td class=\"alignright\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: right; border-top-width: 1px; border-top-color: #eee; border-top-style: solid; margin: 0; padding: 5px 0;\" align=\"right\" valign=\"top\">" + subtotalEmail + "</td></tr>" +
            
            "<tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; border-top-width: 1px; border-top-color: #eee; border-top-style: solid; margin: 0; padding: 5px 0;\" align=\"right\" valign=\"top\">Tip</td><td class=\"alignright\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: right; border-top-width: 1px; border-top-color: #eee; border-top-style: solid; margin: 0; padding: 5px 0;\" align=\"right\" valign=\"top\">$" + tipEmail.description + "0</td></tr>" +
            
            
            "<tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; border-top-width: 1px; border-top-color: #eee; border-top-style: solid; margin: 0; padding: 5px 0;\" align=\"right\" valign=\"top\">Fee</td><td class=\"alignright\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: right; border-top-width: 1px; border-top-color: #eee; border-top-style: solid; margin: 0; padding: 5px 0;\" align=\"right\" valign=\"top\">$ 2.00 </td></tr>" +
            
            
            
            
            "<tr class=\"total\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><td class=\"alignright\" width=\"80%\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: right; border-top-width: 2px; border-top-color: #333; border-top-style: solid; border-bottom-color: #333; border-bottom-width: 2px; border-bottom-style: solid; font-weight: 700; margin: 0; padding: 5px 0;\" align=\"right\" valign=\"top\">Total</td><td class=\"alignright\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: right; border-top-width: 2px; border-top-color: #333; border-top-style: solid; border-bottom-color: #333; border-bottom-width: 2px; border-bottom-style: solid; font-weight: 700; margin: 0; padding: 5px 0;\" align=\"right\" valign=\"top\">$" + finalEmailTotal.description + "0</td></tr>" +
            
            
        "</table></td></tr></table></td></tr><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><td class=\"content-block aligncenter\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: center; margin: 0; padding: 0 0 20px;\" align=\"center\" valign=\"top\"><a href=\"http://www.spvalet.com\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; color: #348eda; text-decoration: underline; margin: 0;\">View in browser</a></td></tr><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><td class=\"content-block aligncenter\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: center; margin: 0; padding: 0 0 20px;\" align=\"center\" valign=\"top\">SmartPark Inc. 1 University Pl, Shreveport, LA 71115</td></tr></table></td></tr></table><div class=\"footer\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; clear: both; color: #999; margin: 0; padding: 20px;\"><table width=\"100%\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"><td class=\"aligncenter content-block\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 12px; vertical-align: top; color: #999; text-align: center; margin: 0; padding: 0 0 20px;\" align=\"center\" valign=\"top\">Questions? Email <a href=\"mailto:\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 12px; color: #999; text-decoration: underline; margin: 0;\">support@spvalet.com</a></td></tr></table></div></div></td><td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0;\" valign=\"top\"></td></tr></table></body></html>"
        
        
        
        let myUrl = NSURL(string: "https://api.mailgun.net/v3/sandboxfbe7b5adbc2947908d2e347a2eeae168.mailgun.org/messages");
        let requestEmail = NSMutableURLRequest(url:myUrl! as URL);

        requestEmail.httpMethod = "POST"
        
        // Basic Authentication
        let username = "api"
        let password = "key-e919390b167eb7b4920fe8a251cc5492"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        requestEmail.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        requestEmail.httpBody = (self.emailHeader + self.emailBody).data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: requestEmail as URLRequest, completionHandler: { (data, response, error) -> Void in
        })
        
        task.resume()        
    }

}
