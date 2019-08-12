//
//  DataKeeper.swift
//
//  Created by Darktt on 2019/8/9.
//  Copyright © 2019 Darktt. All rights reserved.
//

import Foundation

internal class DataKeeper
{
    internal static let shared: DataKeeper = DataKeeper()
    
    internal var hashKey: String = ""
    
    internal var hashIV: String = ""
}

internal extension Bundle
{
    var identifier: String {
        
        let identifier = self.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
        
        return identifier
    }
}
