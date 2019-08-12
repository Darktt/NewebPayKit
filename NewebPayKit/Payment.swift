//
//  Payment.swift
//
//  Created by Darktt on 2019/8/9.
//  Copyright © 2019 Darktt. All rights reserved.
//

import Foundation
import CryptoSwift

public class Payment
{
    // MARK: - Properties -
    
    public let parameters: Parameters
    
    public var isSandboxMode: Bool = true
    
    private var url: URL {
        
        if self.isSandboxMode {
            
            return kURL.sandbox
        }
        
        return kURL.real
    }
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    internal init(parameters: Parameters)
    {
        self.parameters = parameters
    }
    
    public static func hashKey(_ key: String, iv: String)
    {
        let dataKeeper = DataKeeper.shared
        dataKeeper.hashKey = key
        dataKeeper.hashIV = iv
    }
}

// MARK: - Interval Methods -

internal extension Payment
{
    func getRequest() -> Result
    {
        let result: Result
        
        do {
            let merchantID: String = self.parameters.merchantID
            let tradeInfo: String = try self.tradeInfo()
            let tradeSha: String = self.tradeSha(with: tradeInfo)
            let version: String = self.parameters.version
            
            var parameters: String = "MerchantID=\(merchantID)"
            parameters += "&TradeInfo=\(tradeInfo)"
            parameters += "&TradeSha=\(tradeSha)"
            parameters += "&Version=\(version)"
            
            let url: URL = self.url
            let httpBody: Data = parameters.data(using: .utf8)!
            
            self.logSendingData(parameters, for: url)
            
            var request = URLRequest(url: self.url)
            request.httpMethod = "POST"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = httpBody
            
            result = Result.success(request)
            
        } catch {
            
            result = Result.failure(error)
        }
        
        return result
    }
}

// MARK: - Private Methods -

private extension Payment
{
    func tradeInfo() throws -> String
    {
        let dataKeeper = DataKeeper.shared
        let hashKey: String = dataKeeper.hashKey
        let hashIV: String = dataKeeper.hashIV
        let formData: String = try self.parameters.formData()
        let sourceData: Array<UInt8> = formData.bytes
        
        self.logTradeInfo(formData)
        
        let aes = try AES(key: hashKey, iv: hashIV, padding: .pkcs7)
        let result: Array<UInt8> = try aes.encrypt(sourceData)
        let tradeInfo: String = result.hexString
        
        return tradeInfo
    }
    
    func tradeSha(with info: String) -> String
    {
        let dataKeeper = DataKeeper.shared
        let hashKey: String = dataKeeper.hashKey
        let hashIV: String = dataKeeper.hashIV
        let sourceString = "HashKey=\(hashKey)&\(info)&HashIV=\(hashIV)"
        let hashedBytes: Array<UInt8> = sourceString.bytes.sha256()
        let tradeSha: String = hashedBytes.hexString
        
        return tradeSha.uppercased()
    }
    
    func logTradeInfo(_ tradeInfo: String)
    {
        if _isDebugAssertConfiguration() {
            
            print("\n***********\nTradeInfo: \(tradeInfo)\n")
        }
    }
    
    func logSendingData(_ string: String, for url: URL)
    {
        if _isDebugAssertConfiguration() {
            
            print("\n***********\nURL: \(url.absoluteString)\n")
            print("\n***********\nSending data: \n\(string)\n\n***********\n")
        }
    }
}

// MARK: - Typealias -

internal extension Payment
{
    typealias Result = Swift.Result<URLRequest, Swift.Error>
}
