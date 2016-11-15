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
    
    var initialTip = 0
    var totalInt = Float()
    var subtotalInt = Float()
    var feeInt = Float()
    var tipInt = Float()
    var finalTotalInt: Float = 10.00
    var finalTotalInt2 = Float()
    var SERVICE_FEE:Float = 2.00
    var feedItems: NSArray = NSArray()
    var feedItems2: NSArray = NSArray()
    var bCodeIndex = Int()
    var message = String()
    
    
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
    //var slider:UISlider?

    
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

    //required init?(coder aDecoder: NSCoder) {
      //  fatalError("init(coder:) has not been implemented")
    //}
    
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        slider.minimumValue = 0
        slider.maximumValue = 30
        slider.isContinuous = true
        slider.tintColor = UIColor.orange
        slider.value = 0
        slider.isUserInteractionEnabled = true
        //slider.addTarget(self, action: Selector(("sliderChanged:")),for: .valueChanged)
        slider.addTarget(self, action: #selector(CheckoutViewController.valueChanged(_:)), for: .valueChanged)

        
       // buyButton.tintColor = UIColor.orange
        
        intializeLabels()
        
        print(message)
        print(feedItems)
        print(feedItems2)
        print(bCodeIndex)
        
        
        
        
        finalTotalInt2 = finalTotalInt
        
        // This code is included here for the sake of readability, but in your application you should set up your configuration and theme earlier, preferably in your App Delegate.
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
        print("testing Init")
        
        // let variable2 = (feedItems2[bCodeIndex] as AnyObject).description
        //finalTotalInt2 = (Float(variable2!)! + SERVICE_FEE)
        
        
        
        paymentContext.paymentAmount = Int(finalTotalInt2)*100
        paymentContext.paymentCurrency = self.paymentCurrency
        
        self.paymentContext = paymentContext
        //super.init(nibName: nil, bundle: nil)
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
    
    func intializeLabels(){
        self.restaurantName.text = (feedItems[bCodeIndex] as AnyObject).description
        self.totalText.text = "$" + (feedItems2[bCodeIndex] as AnyObject).description
        self.tipLabel.text = "Tip: $\(initialTip)"
        
        
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 248.0/255, green: 146.0/255, blue: 35.0/255, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes =
          [NSForegroundColorAttributeName: UIColor.white]
        self.navigationItem.title = "#" + message        
        
        subtotalRow.detail = totalText.text!
        self.serviceFeeRow.detail = "$\(String(format: "%.2f", SERVICE_FEE))"
        self.tipRow.detail = "$\(String(format: "%.2f", initialTip))"

        
        let variable = (feedItems2[bCodeIndex] as AnyObject).description
        finalTotalInt = (Float(variable!)! + SERVICE_FEE)
        
        self.totalRow.detail = "$\(String(format: "%.2f", finalTotalInt))"
        self.paymentRow.onTap = { [weak self] _ in
            self?.paymentContext.pushPaymentMethodsViewController()
        }

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
        self.buyButton.center = CGPoint(x: width/2.0, y: self.totalRow.frame.maxY+30)
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
        print("Slider step value \(Int(roundedStepValue))")
        print("payback value: \(sender.value)")
        
        let currentValue = Int(sender.value)
        
        tipLabel.text = "Tip: $\(currentValue)"
        tipRow.detail = "$\(currentValue).00"
        let newTotal = finalTotalInt + Float(currentValue)
        totalRow.detail = "$\(String(format: "%.2f", newTotal))"
        
        finalTotalInt2 = finalTotalInt + Float(currentValue)
        paymentContext.paymentAmount = Int(finalTotalInt2)*100

        
    }
    
    
  
    
   
    

}
