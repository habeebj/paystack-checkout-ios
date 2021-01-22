//
//  SwiftUIWrapper.swift
//
//
//  Created by Habeeb Jimoh on 19/01/2021.
//

import SwiftUI

@available(iOS 13.0.0, *)
public struct PaystackCheckout: UIViewControllerRepresentable {
    
    private let params: TransactionParams
    private var customFields: [CustomField] = []
    private var onResponse: ((TransactionResponse?, Error?, Bool) -> Void)? = nil
    private var onError: ((Error?) -> Void)? = nil
    private var onSuccess: ((TransactionResponse) -> Void)? = nil
    private var onDismiss: (() -> Void)? = nil
    
    
    public init(params: TransactionParams, customFields: [CustomField]? = nil, onResponse: @escaping ((TransactionResponse?, Error?, Bool) -> Void)) {
        self.params = params
        if let customFields = customFields {
            self.customFields = customFields
        }
        self.onResponse = onResponse
    }
    
    public init(params: TransactionParams, customFields: [CustomField]? = nil, onSuccess: @escaping (TransactionResponse) -> Void, onError: @escaping (Error?) -> Void, onDismiss: @escaping () -> Void) {
        self.params = params
        if let customFields = customFields {
            self.customFields = customFields
        }
        self.onSuccess = onSuccess
        self.onError = onError
        self.onDismiss = onDismiss
    }
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        let vc = CheckoutViewController(params: self.params, customFields: self.customFields)
        vc.delegate = CheckoutDelegate(self)
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    public class CheckoutDelegate: NSObject, CheckoutProtocol {
        var parent: PaystackCheckout
        init(_ parent: PaystackCheckout) {
            self.parent = parent
        }
        
        public func onError(error: Error?) {
            if let onResponse = parent.onResponse {
                onResponse(nil, error, false)
            }
            if let onError = parent.onError {
                onError(error)
            }
        }
        
        public func onSuccess(response: TransactionResponse) {
            if let onResponse = parent.onResponse {
                onResponse(response, nil, false)
            }
            if let onSuccess = parent.onSuccess {
                onSuccess(response)
            }
        }
        
        public func onDimissal() {
            if let onResponse = parent.onResponse {
                onResponse(nil, nil, true)
            }
            if let onDismiss = parent.onDismiss {
                onDismiss()
            }
        }
    }
}
