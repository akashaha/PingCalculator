//
//  ServerListView.swift
//  PingCalculator
//
//  Created by Arman Akash on 10/9/24.
//

/*

import SwiftUI
import Network

// Model for VPN Server
struct VPNServer: Identifiable {
    var id = UUID()
    var name: String
    var ipAddress: String // This will hold domain names like "th.ike.gg"
}

// Ping Manager to calculate ping
class PingManager: ObservableObject {
    @Published var pingTime: Double = 0.0
    private var pingTimer: Timer?
    
    // Start pinging the resolved IP address
    func startPinging(host: String) {
        pingTimer?.invalidate() // Stop any previous timer
        pingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.ping(host: host)
        }
    }
    
    // Stop pinging
    func stopPinging() {
        pingTimer?.invalidate()
        pingTimer = nil
    }
    
    // Ping logic
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

// Main view for the VPN app
struct ServerListView: View {
    @State private var selectedServer: VPNServer?
    @StateObject private var pingManager = PingManager()
    @State private var resolvedIP: String = "N/A"
    
    // List of servers with domain names
    let servers = [
        VPNServer(name: "US East", ipAddress: "th.ike.gg"),
        VPNServer(name: "Europe West", ipAddress: "eu.ike.gg"),
        VPNServer(name: "Asia Pacific", ipAddress: "ap.ike.gg")
    ]
    
    var body: some View {
        VStack {
            // HStack for displaying Ping and IP Address
            HStack {
                Text("Ping:")
                Text(selectedServer != nil ? "\(String(format: "%.2f", pingManager.pingTime)) ms" : "N/A")
                
                Spacer()
                
                Text("IP Address:")
                Text(resolvedIP)
            }
            .font(.headline)
            .padding()
            
            // Server List
            List(servers) { server in
                Button(action: {
                    selectedServer = server
                    resolveDomainToIP(domain: server.ipAddress) { ip in
                        if let ip = ip {
                            self.resolvedIP = ip
                            pingManager.startPinging(host: ip)
                        } else {
                            self.resolvedIP = "Resolution Failed"
                        }
                    }
                }) {
                    Text(server.name)
                }
            }
            
            Spacer()
        }
        .navigationTitle("VPN Servers")
        .onDisappear {
            pingManager.stopPinging()
        }
    }
    
    // DNS resolution function to convert server domain to IP address
    func resolveDomainToIP(domain: String, completion: @escaping (String?) -> Void) {
        let params = NWParameters.udp
        let connection = NWConnection(host: NWEndpoint.Host(domain), port: 80, using: params)
        
        connection.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                if let ip = connection.currentPath?.remoteEndpoint.debugDescription {
                    // Extract the IP address from the endpoint description
                    let ipAddress = self.extractIPAddress(from: ip)
                    completion(ipAddress)
                } else {
                    completion(nil)
                }
                connection.cancel()
            case .failed(_), .cancelled:
                completion(nil)
            default:
                break
            }
        }
        
        connection.start(queue: .global())
    }
    
    // Helper function to extract just the IP address from the debug description
    func extractIPAddress(from endpointDescription: String) -> String? {
        let components = endpointDescription.split(separator: ":")
        guard let ipPart = components.first else { return nil }
        let ipAddress = ipPart.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        return ipAddress
    }
}

#Preview {
    ServerListView()
}

*/
