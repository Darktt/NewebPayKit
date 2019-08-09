//
//  PaymentRequestControllerDelegate.swift
//  NewebPayKit
//
//  Created by Eden Li on 2019/8/9.
//  Copyright © 2019 Fulldot. All rights reserved.
//

import Foundation

public protocol PaymentRequestControllerDelegate: class
{
    func paymentRequestController(didCompletePayment viewController: PaymentRequestController)
    func paymentRequestController(didCancelPayment viewController: PaymentRequestController)
    func paymentRequestController(_ viewController: PaymentRequestController, didFailedWithError error: Error)
}
