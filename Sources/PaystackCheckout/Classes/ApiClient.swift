import WebKit

public class APIClient {
    public static var shared = APIClient()
    let url = "https://api.paystack.co/checkout/request_inline"
    
    public func requestInline(params: TransactionParams, metadata: Metadata?, completion: @escaping (PaymentResponse?, Error?) -> Void) {
        var metadataString: String = ""
        
        if let metadata = metadata {
            let encodingError = NSError(domain: "Unable to encode metadata", code: 1, userInfo: nil)
            guard let data = try? JSONEncoder().encode(metadata) else {
                completion(nil, encodingError)
                return
            }
            guard let _dataString = String(data: data, encoding: .utf8) else {
                completion(nil, encodingError)
                return
            }
            metadataString = _dataString
        }
        
        let _params: [String : Any?] = [
            "amount" : params.amount,
            "email" : params.email,
            "key" : params.publicKey,
            "firstname" : params.firstName,
            "lastname" : params.lastName,
            "phone" : params.phone,
            "plan" : params.plan,
            "invoice_limit" : params.invoiceLimit,
            "subaccount" : params.subAccount,
            "transaction_charge" : params.transactionCharge,
            "bearer" : params.bearer,
            "currency" : params.currency?.rawValue,
            "metadata": metadataString
        ]
        
        let cleanParams = _params.compactMapValues{$0}
        
        var components = URLComponents(string: url)!
        components.queryItems = cleanParams.map { (arg) -> URLQueryItem in
            let (key, value) = arg
            if let value = value as? Int {
                return URLQueryItem(name: key, value: "\(value)")
            }
            return URLQueryItem(name: key, value: value as? String)
        }
        
        if let channels = params.channels?.map({$0.rawValue}) {
            for channel in channels {
                components.queryItems?.append(URLQueryItem(name: "channels[]", value: channel))
            }
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil,error)
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(nil, error)
                return
            }
            
            guard (200...300).contains(response.statusCode) else {
                completion(nil, error)
                return
            }
            
            guard let paymentResponse = try? JSONDecoder().decode(PaymentResponse.self, from: data) else {
                let error = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                completion(nil, error)
                return
            }
            completion(paymentResponse, nil)
        }.resume()
    }
}
