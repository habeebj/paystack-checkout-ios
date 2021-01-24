//
//  Metadata.swift
//  PaystackCheckout
//
//  Created by Habeeb Jimoh on 24/10/2020.
//  Copyright © 2020 Habeeb Jimoh. All rights reserved.
//

import Foundation

public struct CustomFilters: Encodable {
    let recurring: Bool
    let banks: [String]
    let card_brands: [String]
}

public struct Metadata: Encodable {
    let cancel_action: String
    let custom_filters: CustomFilters
    let custom_fields: [CustomField]
}

public struct CustomField: Encodable {
    let display_name: String
    let variable_name: String
    let value: String
    
    public init(displaName: String, variableName: String, value: String) {
        self.display_name = displaName
        self.variable_name = variableName
        self.value = value
    }
    
    public init(variableName: String, value: String) {
        self.display_name = variableName
        self.variable_name = variableName
        self.value = value
    }
}
