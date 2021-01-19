//
//  SwiftUIWrapper.swift
//  
//
//  Created by Habeeb Jimoh on 19/01/2021.
//

import SwiftUI

@available(iOS 13.0.0, *)
public struct PaystackCheckout: UIViewControllerRepresentable {
    let params: TransactionParams
    var customFields: [CustomField]
    let delegate: CheckoutProtocol
    
    public init(params: TransactionParams, customFields: [CustomField] = [], delegate: CheckoutProtocol) {
        self.params = params
        self.customFields = customFields
        self.delegate = delegate
    }
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        let vc = CheckoutViewController(params: self.params, customFields: self.customFields, delegate: self.delegate)
        vc.isModalInPresentation = true
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
