//
//  PingManager.swift
//  PingCalculator
//
//  Created by Arman Akash on 10/9/24.
//

import SwiftUI
import Network

class PingManager: ObservableObject {
    @Published var pingTime: Double = 0.0
    
    private var pingTimer: Timer?
    
    func startPinging(host: String) {
        pingTimer?.invalidate() // Stop any previous timer
        pingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.ping(host: host)
        }
    }
    
    func stopPinging() {
        pingTimer?.invalidate()
        pingTimer = nil
    }
    
    private func ping(host: String) {
        let params = NWParameters.udp
        let connection = NWConnection(host: NWEndpoint.Host(host), port: 33434, using: params)
        
        let startTime = Date()
        connection.start(queue: .main)
        connection.send(content: nil, completion: .contentProcessed { _ in
            let endTime = Date()
            self.pingTime = endTime.timeIntervalSince(startTime) * 1000 // Convert to milliseconds
            connection.cancel()
        })
    }
}


import Foundation

struct VPNServer: Identifiable {
    var id = UUID()
    var name: String
    var ipAddress: String
}
