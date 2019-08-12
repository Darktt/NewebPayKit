//
//  PaymentError.swift
//
//  Created by Darktt on 2019/8/9.
//  Copyright © 2019 Darktt. All rights reserved.
//

import Foundation

public extension Payment
{
    enum Error: Swift.Error
    {
        case missingParameter(name: String)
        
    }
}

extension Payment.Error: CustomStringConvertible
{
    public var description: String {
        
        let description: String
        
        switch self {
        case let .missingParameter(name: name):
            description = "Missing parameter '\(name)'."
            
        }
        
        return description
    }
}
