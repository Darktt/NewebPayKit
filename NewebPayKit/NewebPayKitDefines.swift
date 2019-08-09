//
//  NewebPayKitDefines.swift
//  NewebPayKit
//
//  Created by Eden Li on 2019/8/9.
//  Copyright © 2019 Fulldot. All rights reserved.
//

import Foundation

internal struct kURL
{
    static let sandbox: URL = URL(string: "https://ccore.newebpay.com/MPG/mpg_gateway")!
    
    static let real: URL = URL(string: "https://core.newebpay.com/MPG/mpg_gateway")!
}
