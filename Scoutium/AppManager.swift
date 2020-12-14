//
//  AppManager.swift
//  Scoutium
//
//  Created by Ahmet Onur Akman on 13.12.2020.
//

import Foundation
import UIKit

// A class to contain commonly usable functions amonngst other classes
// Did not need to use frequently for this particular project
class AppManager {
    
    // A function to calculate alpha for icons each step
    func animationIconAlphaCalculator(range: CGFloat, top: CGFloat, counter: Int) -> CGFloat{
        return (top-CGFloat(counter))/range
    }
}

enum RemoteConfigKeys: String{
    case openingLabel = "textFromCloud"
}

enum DebugMessages: String{
    case firebaseFetchError = "[ERROR WHILE FIREBASE FETCHING]", firebaseFetchSuccess = "[FIREBASE FETCHING SUCCESSFUL]"
    case apiReqFailure = "[API REQUEST FAILED]", apiReqSuccess = "[API REQUEST SUCCESSFUL]"
    case apiReqInvalidUrl = "[INVALID URL FOR API REQUEST]"
    case parsingError = "[ERROR WHILE JSON PARSING]", parsingSuccess = "[JSON PARSING SUCCESSFUL]", parsingFailure = "[JSON PARSING FAILED]"
    case connected = "[CONNECTED TO THE INTERNET]", notConnected = "[NO ACTIVE INTERNET CONNECTION]"
}

enum AlertMessages: String{
    case noConnection = "An active internet connection is required. Connect to the internet and try again later."
    case noData = "Data request failed. Try again later."
}
