//
//  ConnectionChecker.swift
//  Scoutium
//
//  Created by Ahmet Onur Akman on 12.12.2020.
//

import Foundation
import Network

// A class used to check the internet connection
public class ConnectionChecker {
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    var conn = false // Bool experession of the existence of the active connection
    var connInfoUpdated = false // To understand if the closure is completed
    
    func isConnected() -> Bool {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.changeStatus(path.status == .satisfied)
            print((self?.conn ?? false) ? DebugMessages.connected.rawValue : DebugMessages.notConnected.rawValue)
            self?.connInfoUpdated = true
        }
        while(!connInfoUpdated){}
        return self.conn
    }
    
    func changeStatus(_ status: Bool){
        self.conn = status
    }
}
