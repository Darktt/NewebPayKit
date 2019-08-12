//
//  PaymentParameters.swift
//
//  Created by Darktt on 2019/8/9.
//  Copyright © 2019 Darktt. All rights reserved.
//

import Foundation

public typealias Parameters = Payment.Parameters

public extension Payment
{
    struct Parameters
    {
        // MARK: - Properties -
        
        public let merchantID: String
        
        private let respondType: String = "JSON"
        
        private var timeStamp: String {
            
            let date = Date()
            let timeInterval: TimeInterval = date.timeIntervalSince1970
            let timeStamp: String = "\(timeInterval / 100.0)"
            
            return timeStamp
        }
        
        internal let version: String = "1.5"
        
        private let languageType: String = "zh-tw"
        
        public var orderNumber: String?
        
        public var amount: Int?
        
        public var productName: String?
        
        public var tradeLimit: Int = 900
        
        public var confirmUrl: String?
        
        public var notifyUrl: String?
        
        public var cancelUrl: String?
        
        public var email: String?
        
        // 是否要登入藍新金流會員。1: 要、0: 不要
        private let loginType: Int = 0
        
        // 設定是否啟用信用卡一次付清支付方式。1：啟用、0：不啟用
        private let credit: Int = 1
        
        public var userID: String?
        
        private let tokenTermDemand: Int = 3
        
        // MARK: - Methods -
        // MARK: Initial Method
        
        public init(merchantID: String)
        {
            self.merchantID = merchantID
        }
    }
}

// MARK: - Interval Methods -

internal extension Payment.Parameters
{
    func formData() throws -> String
    {
        guard let orderNumber = self.orderNumber else {
            
            throw Payment.Error.missingParameter(name: "OrderNumber")
        }
        
        guard let amount = self.amount else {
            
            throw Payment.Error.missingParameter(name: "Amount")
        }
        
        guard let productName = self.productName else {
            
            throw Payment.Error.missingParameter(name: "ProductName")
        }
        
        guard let confirmUrl = self.confirmUrl else {
            
            throw Payment.Error.missingParameter(name: "ComleteURL")
        }
        
        guard let notifyUrl = self.notifyUrl else {
            
            throw Payment.Error.missingParameter(name: "NotifyURL")
        }
        
        guard let cancelUrl = self.cancelUrl else {
            
            throw Payment.Error.missingParameter(name: "CancelURL")
        }
        
        guard let email = self.email else {
            
            throw Payment.Error.missingParameter(name: "Email")
        }
        
        guard let userID = self.userID else {
            
            throw Payment.Error.missingParameter(name: "UserID")
        }
        
        var formData: String = "MerchantID=\(self.merchantID)"
        formData += "&RespondType=\(self.respondType)"
        formData += "&TimeStamp=\(self.timeStamp)"
        formData += "&Version=\(self.version)"
        formData += "&LangType=\(self.languageType)"
        formData += "&MerchantOrderNo=\(orderNumber)"
        formData += "&Amt=\(amount)"
        formData += "&ItemDesc=\(productName)"
        formData += "&TradeLimit=\(self.tradeLimit)"
        formData += "&ReturnURL=\(confirmUrl)"
        formData += "&NotifyURL=\(notifyUrl)"
        formData += "&ClientBackURL=\(cancelUrl)"
        formData += "&Email=\(email)"
        formData += "&LoginType=\(self.loginType)"
        formData += "&CREDIT=\(self.credit)"
        formData += "&TokenTerm=\(userID)"
        formData += "&TokenTermDemand=\(self.tokenTermDemand)"
        
        return formData
    }
}
