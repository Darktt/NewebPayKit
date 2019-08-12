//
//  StringExtension.swift
//
//  Created by Darktt on 2019/8/9.
//  Copyright © 2019 Darktt. All rights reserved.
//

import Foundation

internal extension String
{
    // MARK: - Properties -
    
    var localized: String {
        
        let bundle = Bundle(for: Payment.self)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
