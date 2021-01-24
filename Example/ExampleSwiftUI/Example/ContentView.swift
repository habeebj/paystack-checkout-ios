//
//  ContentView.swift
//  Example
//
//  Created by Habeeb Jimoh on 19/01/2021.
//

import SwiftUI
import PaystackCheckout

struct ContentView: View {
    @State var isPresenting = false
    @State var status = ""
    
    // change pk_live_xxxx to your public key
    let transactionParams = TransactionParams(amount: 30000, email: "user@example.com", key: "pk_live_xxxx")
    
    let customFields = [
        CustomField(variableName: "Invoice ID", value: "209"),
        CustomField(
            displaName: "Cart Items",
            variableName: "cart_items",
            value: "3 bananas, 12 mangoes"
        ),
        CustomField(variableName: "Platform", value: "iOS")
    ]

    let customFilter = CustomFilters(recurring: true, banks: ["057","100"], cardBrands: ["verve"])
    
    var body: some View {
        VStack {
            Text(status)
                .padding(.bottom)
            Button("Pay") {
                self.isPresenting.toggle()
            }
            .fullScreenCover(isPresented: $isPresenting, content: {
                let metadata = Metadata(customFields: customFields, customFilters: customFilter)
                
                PaystackCheckout(params: transactionParams, metadata: metadata) { (response) in
                    status = response.reference
                } onError: { (error) in
                    status = error?.localizedDescription ?? "an error occured"
                } onDismiss: {
                    status = "You dimissed the payment modal"
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
