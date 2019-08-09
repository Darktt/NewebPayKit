//
//  AnchorOperator.swift
//
//  Created by Darktt on 18/1/18.
//  Copyright © 2018 Darktt. All rights reserved.
//

import Foundation

#if os(OSX)
    
    import AppKit
    
#else
    
    import UIKit
    
#endif

//MARK: - Operator defination -

precedencegroup ConstraintPrecedence { lowerThan: AdditionPrecedence }

/// Make inactive equal constraint
infix operator =~=: ConstraintPrecedence
/// Make inactive lessThanOrEqual constraint
infix operator <~=: ConstraintPrecedence
/// Make inactive greaterThanOrEqual constraint
infix operator >~=: ConstraintPrecedence

/// Make active equal constraint
infix operator =*=: ConstraintPrecedence
/// Make active lessThanOrEqual constraint
infix operator <*=: ConstraintPrecedence
/// Make active greaterThanOrEqual constraint
infix operator >*=: ConstraintPrecedence

// MARK: - Protocol -

@available(OSX 10.11, iOS 9.0, *)
internal protocol ConstraintActivable
{
    associatedtype AnchorType: AnyObject
    
    func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, constant c: CGFloat) -> NSLayoutConstraint
    
    func constraint(greaterThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>, constant c: CGFloat) -> NSLayoutConstraint
    
    func constraint(lessThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>, constant c: CGFloat) -> NSLayoutConstraint
}

@available(OSX 10.11, iOS 9.0, *)
internal extension ConstraintActivable
{
    static func + (lhs: Self, rhs: CGFloat) -> (anchor: Self, constant: CGFloat)
    {
        return (lhs, rhs)
    }
    
    static func - (lhs: Self, rhs: CGFloat) -> (anchor: Self, constant: CGFloat)
    {
        return (lhs, -rhs)
    }
    
    // Inactive operator
    // MARK: - "=~=" -
    
    @available(OSX 10.11, iOS 9.0, *)
    static func =~= (left: Self, right: Self) -> NSLayoutConstraint
    {
        return left.constraint(equalTo: right, active: false)
    }
    
    @available(OSX 10.11, iOS 9.0, *)
    static func =~= (left: Self, right: (anchor: Self, constant: CGFloat)) -> NSLayoutConstraint
    {
        return left.constraint(equalTo: right, active: false)
    }
    
    // MARK: - ">~=" -
    
    @available(OSX 10.11, iOS 9.0, *)
    static func >~= (left: Self, right: Self) -> NSLayoutConstraint
    {
        return left.constraint(greaterThanOrEqualTo: right, active: false)
    }
    
    @available(OSX 10.11, iOS 9.0, *)
    static func >~= (left: Self, right: (anchor: Self, constant: CGFloat)) -> NSLayoutConstraint
    {
        return left.constraint(greaterThanOrEqualTo: right, active: false)
    }
    
    // MARK: - "<~=" -
    
    @available(OSX 10.11, iOS 9.0, *)
    static func <~= (left: Self, right: Self) -> NSLayoutConstraint
    {
        return left.constraint(lessThanOrEqualTo: right, active: false)
    }
    
    @available(OSX 10.11, iOS 9.0, *)
    static func <~= (left: Self, right: (anchor: Self, constant: CGFloat)) -> NSLayoutConstraint
    {
        return left.constraint(lessThanOrEqualTo: right, active: false)
    }
    
    // Active operator
    // MARK: - "=*=" -
    
    @available(OSX 10.11, iOS 9.0, *)
    static func =*= (left: Self, right: Self) -> NSLayoutConstraint
    {
        return left.constraint(equalTo: right)
    }
    
    @available(OSX 10.11, iOS 9.0, *)
    static func =*= (left: Self, right: (anchor: Self, constant: CGFloat)) -> NSLayoutConstraint
    {
        return left.constraint(equalTo: right)
    }
    
    // MARK: - ">*=" -
    
    @available(OSX 10.11, iOS 9.0, *)
    static func >*= (left: Self, right: Self) -> NSLayoutConstraint
    {
        return left.constraint(greaterThanOrEqualTo: right)
    }
    
    @available(OSX 10.11, iOS 9.0, *)
    static func >*= (left: Self, right: (anchor: Self, constant: CGFloat)) -> NSLayoutConstraint
    {
        return left.constraint(greaterThanOrEqualTo: right)
    }
    
    // MARK: - "<*=" -
    
    @available(OSX 10.11, iOS 9.0, *)
    static func <*= (left: Self, right: Self) -> NSLayoutConstraint
    {
        return left.constraint(lessThanOrEqualTo: right)
    }
    
    @available(OSX 10.11, iOS 9.0, *)
    static func <*= (left: Self, right: (anchor: Self, constant: CGFloat)) -> NSLayoutConstraint
    {
        return left.constraint(lessThanOrEqualTo: right)
    }
}

// MARK: - Private Methods -

@available(OSX 10.11, iOS 9.0, *)
fileprivate extension ConstraintActivable
{
    func constraint(equalTo anchor: Self, constant c: CGFloat = 0.0, active: Bool = true) -> NSLayoutConstraint
    {
        let constraint = self.constraint(equalTo: anchor as! NSLayoutAnchor<AnchorType>, constant: c)
        constraint.isActive = active
        
        return constraint
    }
    
    func constraint(equalTo tuple: (anchor: Self, constant: CGFloat), active: Bool = true) -> NSLayoutConstraint
    {
        return self.constraint(equalTo: tuple.anchor, constant: tuple.constant, active: active)
    }
    
    func constraint(greaterThanOrEqualTo anchor: Self, constant c: CGFloat = 0.0, active: Bool = true) -> NSLayoutConstraint
    {
        let constraint = self.constraint(greaterThanOrEqualTo: anchor as! NSLayoutAnchor<AnchorType>, constant: c)
        constraint.isActive = active
        
        return constraint
    }
    
    func constraint(greaterThanOrEqualTo tuple: (anchor: Self, constant: CGFloat), active: Bool = true) -> NSLayoutConstraint
    {
        return self.constraint(greaterThanOrEqualTo: tuple.anchor, constant: tuple.constant, active: active)
    }
    
    func constraint(lessThanOrEqualTo anchor: Self, constant c: CGFloat = 0.0, active: Bool = true) -> NSLayoutConstraint
    {
        let constraint = self.constraint(lessThanOrEqualTo: anchor as! NSLayoutAnchor<AnchorType>, constant: c)
        constraint.isActive = active
        
        return constraint
    }
    
    func constraint(lessThanOrEqualTo tuple: (anchor: Self, constant: CGFloat), active: Bool = true) -> NSLayoutConstraint
    {
        return self.constraint(lessThanOrEqualTo: tuple.anchor, constant: tuple.constant, active: active)
    }
}

// MARK: - Confirm Protocol -

@available(OSX 10.11, iOS 9.0, *)
extension NSLayoutXAxisAnchor: ConstraintActivable {}

@available(OSX 10.11, iOS 9.0, *)
extension NSLayoutYAxisAnchor: ConstraintActivable {}

@available(OSX 10.11, iOS 9.0, *)
extension NSLayoutDimension: ConstraintActivable {}

// MARK:  - Structure -

@available(OSX 10.11, iOS 9.0, *)
internal struct LayoutDimensionInfo
{
    fileprivate let anchor: NSLayoutDimension
    fileprivate let multiplier: CGFloat
    fileprivate let constant: CGFloat
    
    fileprivate init(anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat = 0)
    {
        self.anchor = anchor
        self.multiplier = multiplier
        self.constant = constant
    }
}

@available(OSX 10.11, iOS 9.0, *)
internal func + (left: LayoutDimensionInfo, right: CGFloat) -> LayoutDimensionInfo
{
    return LayoutDimensionInfo(anchor: left.anchor, multiplier: left.multiplier, constant: left.constant + right)
}

@available(OSX 10.11, iOS 9.0, *)
internal func - (left: LayoutDimensionInfo, right: CGFloat) -> LayoutDimensionInfo
{
    return LayoutDimensionInfo(anchor: left.anchor, multiplier: left.multiplier, constant: left.constant - right)
}

// MARK: - Extension NSLayoutDimension -

@available(OSX 10.11, iOS 9.0, *)
internal extension NSLayoutDimension
{
    // MARK: - "*" -
    
    static func * (left: NSLayoutDimension, right: CGFloat) -> LayoutDimensionInfo
    {
        return LayoutDimensionInfo(anchor: left, multiplier: right)
    }
    
    static func * (left: CGFloat, right: NSLayoutDimension) -> LayoutDimensionInfo
    {
        return LayoutDimensionInfo(anchor: right, multiplier: left)
    }
    
    // MARK: - "/" -
    
    static func / (left: NSLayoutDimension, right: CGFloat) -> LayoutDimensionInfo
    {
        return LayoutDimensionInfo(anchor: left, multiplier: 1.0 / right)
    }
    
    static func / (left: CGFloat, right: NSLayoutDimension) -> LayoutDimensionInfo
    {
        return LayoutDimensionInfo(anchor: right, multiplier: 1.0 / left)
    }
    
    // Inactive operator
    // MARK: - "=~=" -
    
    static func =~= (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint
    {
        return left.constraint(equalToConstant: right)
    }
    
    static func =~= (left: NSLayoutDimension, right: LayoutDimensionInfo) -> NSLayoutConstraint
    {
        return left.constraint(equalTo: right.anchor, multiplier: right.multiplier, constant: right.constant)
    }
    
    // MARK: - ">~=" -
    
    static func >~= (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint
    {
        return left.constraint(greaterThanOrEqualToConstant: right)
    }
    
    static func >~= (left: NSLayoutDimension, right: LayoutDimensionInfo) -> NSLayoutConstraint
    {
        return left.constraint(greaterThanOrEqualTo: right.anchor, multiplier: right.multiplier, constant: right.constant)
    }
    
    // MARK: - "<~=" -
    
    static func <~= (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint
    {
        return left.constraint(lessThanOrEqualToConstant: right)
    }
    
    static func <~= (left: NSLayoutDimension, right: LayoutDimensionInfo) -> NSLayoutConstraint
    {
        return left.constraint(lessThanOrEqualTo: right.anchor, multiplier: right.multiplier, constant: right.constant)
    }
    
    // Active operator
    // MARK: - "=*=" -
    
    @discardableResult
    static func =*= (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint
    {
        let constraint = left.constraint(equalToConstant: right)
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    static func =*= (left: NSLayoutDimension, right: LayoutDimensionInfo) -> NSLayoutConstraint
    {
        let constraint = left.constraint(equalTo: right.anchor, multiplier: right.multiplier, constant: right.constant)
        constraint.isActive = true
        
        return constraint
    }
    
    // MARK: - ">*=" -
    
    @discardableResult
    static func >*= (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint
    {
        let constraint =  left.constraint(greaterThanOrEqualToConstant: right)
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    static func >*= (left: NSLayoutDimension, right: LayoutDimensionInfo) -> NSLayoutConstraint
    {
        let constraint =  left.constraint(greaterThanOrEqualTo: right.anchor, multiplier: right.multiplier, constant: right.constant)
        constraint.isActive = true
        
        return constraint
    }
    
    // MARK: - "<*=" -
    
    @discardableResult
    static func <*= (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint
    {
        let constraint =  left.constraint(lessThanOrEqualToConstant: right)
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    static func <*= (left: NSLayoutDimension, right: LayoutDimensionInfo) -> NSLayoutConstraint
    {
        let constraint =  left.constraint(lessThanOrEqualTo: right.anchor, multiplier: right.multiplier, constant: right.constant)
        constraint.isActive = true
        
        return constraint
    }
}
