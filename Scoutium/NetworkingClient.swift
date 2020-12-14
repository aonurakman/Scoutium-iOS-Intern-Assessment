//
//  NetworkingClient.swift
//  Scoutium
//
//  Created by Ahmet Onur Akman on 13.12.2020.
//

import Foundation
import Alamofire

// A class to gather data from API url
class NetworkingClient{
    
    var fetchedData: Any? = nil // Data gathered from API
    var requestCompleted = false // Bool type expression of the completion of the operation
    
    func execute(_ url: URL){
        AF.request(url, encoding: JSONEncoding.default)
            .responseJSON{ (response) in
                if let error = response.error{
                    print(DebugMessages.apiReqFailure.rawValue, " \(error)")
                }
                else {
                    print(DebugMessages.apiReqSuccess.rawValue)
                    self.fetchedData = response.value
                }
                // IMPORTANT: This next async command is completely unnecessary-
                // -and the operation inside is good to run immediately.
                // only purpose of delaying this operation is to enable the viewer-
                // -to have a better look at the created animation.
                // animation stop relies on the completion of the api request
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.requestCompleted = true
                }
            }
    }
}
