//
//  ContentView.swift
//  PingCalculator
//
//  Created by Arman Akash on 10/9/24.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var pingTime: String = "Calculating..."
    @State private var ipAddress: String = "Unknown"
    @State private var timer: Timer? = nil

    var body: some View {
        VStack {
            HStack {
                Text("Ping:")
                Text(pingTime)
                
                Spacer()
                
                Text("IP Address:")
                Text(ipAddress)
            }
        }
        .padding()
        .onAppear(perform: startPinging)
        .onDisappear(perform: stopPinging)
    }
    
    // Start pinging at regular intervals
    func startPinging() {
        measurePing() // First call immediately
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            measurePing()
        }
    }
    
    // Stop pinging when the view disappears
    func stopPinging() {
        timer?.invalidate()
        timer = nil
    }
    
    // Function to calculate ping time and resolve IP
    func measurePing() {
        let host = "www.google.com" // Replace with your server's hostname
        let url = URL(string: "https://\(host)")!
        let startTime = Date()
        
        // Resolve IP address
        resolveIP(from: host) { ip in
            if let ip = ip {
                DispatchQueue.main.async {
                    self.ipAddress = ip
                }
            } else {
                DispatchQueue.main.async {
                    self.ipAddress = "Error"
                }
            }
        }
        
        // Measure ping time
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.pingTime = "Error"
                }
                return
            }
            
            let elapsedTime = Date().timeIntervalSince(startTime) * 1000 // Convert to ms
            DispatchQueue.main.async {
                self.pingTime = String(format: "%.0f ms", elapsedTime)
            }
        }
        task.resume()
    }
    
    // Function to resolve IP address from a hostname
    func resolveIP(from host: String, completion: @escaping (String?) -> Void) {
        DispatchQueue.global().async {
            let hostRef = CFHostCreateWithName(nil, host as CFString).takeRetainedValue()
            CFHostStartInfoResolution(hostRef, .addresses, nil)
            
            var success: DarwinBoolean = false
            if let addresses = CFHostGetAddressing(hostRef, &success)?.takeUnretainedValue() as NSArray?,
               success.boolValue {
                for case let theAddress as NSData in addresses {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if getnameinfo(theAddress.bytes.bindMemory(to: sockaddr.self, capacity: theAddress.length),
                                   socklen_t(theAddress.length),
                                   &hostname,
                                   socklen_t(hostname.count),
                                   nil,
                                   0,
                                   NI_NUMERICHOST) == 0 {
                        let ip = String(cString: hostname)
                        completion(ip)
                        return
                    }
                }
            }
            completion(nil)
        }
    }
}

#Preview {
    ContentView()
}
