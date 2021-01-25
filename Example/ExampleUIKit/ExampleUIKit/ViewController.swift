//
//  ViewController.swift
//  ExampleUIKit
//
//  Created by Habeeb Jimoh on 22/01/2021.
//

import UIKit
import PaystackCheckout

class ViewController: UIViewController, CheckoutProtocol {
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pay", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onPaymentButtonTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(statusLabel)
        view.addSubview(payButton)
        
        // auto layout
        NSLayoutConstraint.activate([
            payButton.widthAnchor.constraint(equalToConstant: 200),
            payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -24),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func onPaymentButtonTap() {
        statusLabel.text = ""
        
        let transactionParams = TransactionParams(amount: 3000, email: "user@example.com", key: "public_key")
        
        let customFields = [
            CustomField(variableName: "Invoice ID", value: "209"),
            CustomField(displaName: "Cart Items", variableName: "cart_items", value: "3 bananas, 12 mangoes"),
            CustomField(variableName: "Platform", value: "iOS")
        ]
        
        let customFilter = CustomFilters(recurring: true, banks: ["057","100"], cardBrands: ["verve"])
        
        // Metadata is optional
        let metadata = Metadata(customFields: customFields, customFilters: customFilter)
        
        let vc = CheckoutViewController(params: transactionParams, metadata: metadata, delegate: self)
        if #available(iOS 13.0, *) {
            vc.isModalInPresentation = true
        }
        present(vc, animated: true)
    }
    
    func onError(error: Error?) {
        DispatchQueue.main.async {
            self.statusLabel.text = "There was an error: \(error?.localizedDescription ?? "")"
        }
    }
    
    func onSuccess(response: TransactionResponse) {
        DispatchQueue.main.async {
            self.statusLabel.text = "Payment successfull: \(response.reference)"
        }
    }
    
    func onDimissal() {
        DispatchQueue.main.async {
            self.statusLabel.text = "You dimissed the payment modal"
        }
    }
    
}

