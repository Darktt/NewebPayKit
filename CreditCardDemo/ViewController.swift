//
//  ViewController.swift
//  CreditCardDemo
//
//  Created by Darktt on 2019/6/26.
//  Copyright © 2019 Darktt. All rights reserved.
//

import UIKit
import SafariServices
import SwiftExtensions
import NewebPayKit

private struct kCreditCard
{
    static let hashKey: String = "TgmJORyBRNLycGlyGZmxipvKuIFEycy9"//"hTzWDo0CKl2qh7SiEp069qIIsyHuU9YQ"
    static let hashIV: String = "CcTcazCAbzSbCMUP"//"CJxoPz0nNaNg36JP"
    static let storeId: String = "MS36702040"//"MS16565552"
}

class ViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Payment.hashKey(kCreditCard.hashKey, iv: kCreditCard.hashIV)
    }
}

private extension ViewController
{
    @IBAction @objc
    func payment()
    {
        //https://webhook.site/c1fab56b-f7e8-4041-b5be-41bf049d441e
        var parameters = Parameters(merchantID: kCreditCard.storeId)
        parameters.productName = "車資"
        parameters.amount = 200
        parameters.confirmUrl = "https://success"
        parameters.notifyUrl = "https://webhook.site/c1fab56b-f7e8-4041-b5be-41bf049d441e"
        parameters.cancelUrl = "https://cancel"
        parameters.orderNumber = String.random(length: 20)
        parameters.email = "asdfg@mail.com"
        parameters.userID = "1234567890"
        
        self.launchWebView(parameters)
    }
    
    func launchWebView(_ parameter: Payment.Parameters)
    {
        let webViewController = PaymentRequestController(parameters: parameter)
        webViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: webViewController)
        
        self.present(navigationController, animated: true)
    }
}

extension ViewController: PaymentRequestControllerDelegate
{
    func paymentRequestController(didCompletePayment viewController: PaymentRequestController)
    {
        print("Payment successful.")
    }
    
    func paymentRequestController(didCancelPayment viewController: PaymentRequestController)
    {
        viewController.dismiss(animated: true)
    }
    
    func paymentRequestController(_ viewController: PaymentRequestController, didFailedWithError error: Error)
    {
        print("Error: \(error)")
    }
}
