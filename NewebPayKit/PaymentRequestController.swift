//
//  PaymentRequestController.swift
//  NewebPayKit
//
//  Created by Eden Li on 2019/8/9.
//  Copyright © 2019 Fulldot. All rights reserved.
//

import UIKit
import WebKit

public class PaymentRequestController: UIViewController
{
    // MARK: - Properties -
    
    public let payment: Payment
    
    public var isSandboxMode: Bool {
        
        set {
            
            self.payment.isSandboxMode = newValue
        }
        
        get {
            
            return self.payment.isSandboxMode
        }
    }
    
    public weak var delegate: PaymentRequestControllerDelegate?
    
    private weak var webView: WKWebView!
    
    private lazy var uiDelegate: UIDelegate = {
        
        let delegate = UIDelegate(self)
        
        return delegate
    }()
    
    private lazy var navigationDelegate: NavigationDelegate = {
        
        let delegate = NavigationDelegate(self)
        
        return delegate
    }()
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public init(parameters: Payment.Parameters)
    {
        let payment = Payment(parameters: parameters)
        
        self.payment = payment
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Live Cycle
    
    public override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    public override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
    }
    
    public override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
    }
    
    public override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard self.navigationController != nil else {
            
            fatalError("PaymentRequestController must contain in UINavigationController.")
        }
        
        let configuration = WKWebViewConfiguration()
        let prefernces: WKPreferences = configuration.preferences
        prefernces.javaScriptEnabled = true
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = self.uiDelegate
        webView.navigationDelegate = self.navigationDelegate
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.webView = webView
        self.view.addSubview(webView)
        
        let topConstraint: NSLayoutConstraint = webView.topAnchor =*= self.view.topAnchor
        let leftConstraint: NSLayoutConstraint = webView.leftAnchor =*= self.view.leftAnchor
        let bottomConstraint: NSLayoutConstraint = webView.bottomAnchor =*= self.view.bottomAnchor
        let rightConstraint: NSLayoutConstraint = webView.rightAnchor =*= self.view.rightAnchor
        
        self.view.addConstraints([topConstraint, leftConstraint, bottomConstraint, rightConstraint])
        
        self.loadRequest()
        self.setupNavigationButton()
    }
    
    deinit
    {
        
    }
}

// MARK: - Actions -

private extension PaymentRequestController
{
    @objc
    func dismissAciton(_ sender: UIBarButtonItem)
    {
        self.delegate?.paymentRequestController(didCancelPayment: self)
    }
}

// MARK: - Private Mehtods -

private extension PaymentRequestController
{
    func loadRequest()
    {
        do {
            
            let result: Payment.Result = self.payment.getRequest()
            let request: URLRequest = try result.get()
            
            self.webView.load(request)
        } catch {
            
            self.delegate?.paymentRequestController(self, didFailedWithError: error)
        }
    }
    
    func setupNavigationButton()
    {
        let buttonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAciton(_:)))
        
        self.navigationItem.leftBarButtonItem = buttonItem
    }
}

// MARK: - File Private Methods -

fileprivate extension PaymentRequestController
{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        let parameter: Payment.Parameters = self.payment.parameters
        let confrimUrl: String? = parameter.confirmUrl
        let cancelUrl: String? = parameter.cancelUrl
        let currentUrl: URL? = navigationAction.request.url
        var policy: WKNavigationActionPolicy = .allow
        
        print("*******************")
        print("URL: \(currentUrl?.absoluteString ?? "Null")")
        print("Confrim URL: \(confrimUrl ?? "Null")")
        print("Cancel URL: \(cancelUrl ?? "Null")")
        print("*******************")
        
        if currentUrl?.absoluteString.contains(confrimUrl!) == true {
            
            self.delegate?.paymentRequestController(didCompletePayment: self)
            policy = .cancel
        }
        
        if currentUrl?.absoluteString.contains(cancelUrl!) == true {
            
            self.delegate?.paymentRequestController(didCancelPayment: self)
            policy = .cancel
        }
        
        decisionHandler(policy)
    }
}

// MARK: - PaymentRequestController.UIDelegate -

fileprivate extension PaymentRequestController
{
    class UIDelegate: NSObject, WKUIDelegate
    {
        // MARK: - Properties -
        
        fileprivate weak var viewController: PaymentRequestController!
        
        // MARK: - Methods -
        // MARK: Initial Method
        
        fileprivate convenience init(_ viewController: PaymentRequestController)
        {
            self.init()
            self.viewController = viewController
        }
        
        // MARK: - Delegate Methods -
        
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void)
        {
            let actionTitle: String = "OK".localized
            let alertActionHandler: (UIAlertAction) -> Void = {
                
                _ in
                
                completionHandler()
            }
            let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: alertActionHandler)
            
            let title: String? = frame.request.url?.host
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(alertAction)
            
            self.viewController.present(alertController, animated: true)
        }
        
        func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void)
        {
            let alertActionHandler: (UIAlertAction) -> Void = {
                
                action in
                
                let result: Bool = (action.style == .default)
                
                completionHandler(result)
            }
            let acceptTitle: String = "OK".localized
            let acceptAction = UIAlertAction(title: acceptTitle, style: .default, handler: alertActionHandler)
            let cancelTitle: String = "Cancel".localized
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: alertActionHandler)
            
            let title: String? = frame.request.url?.host
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(acceptAction)
            alertController.addAction(cancelAction)
            
            self.viewController.present(alertController, animated: true)
        }
    }
}

// MARK: - PaymentRequestController.NavigationDelegate -

fileprivate extension PaymentRequestController
{
    class NavigationDelegate: NSObject, WKNavigationDelegate
    {
        // MARK: - Properties -
        
        fileprivate weak var viewController: PaymentRequestController!
        
        // MARK: - Methods -
        // MARK: Initial Method
        
        fileprivate convenience init(_ viewController: PaymentRequestController)
        {
            self.init()
            self.viewController = viewController
        }
        
        // MARK: - Delegate Methods -
        
        fileprivate func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
        {
            self.viewController.webView(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
        }
        
        fileprivate func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
        {
            self.viewController.navigationItem.title = webView.title
        }
    }
}
