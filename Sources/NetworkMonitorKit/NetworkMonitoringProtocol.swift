//
// NetworkMonitoringProtocol.swift
//
//
//  Created by Md. Rohejul Islam on 2/13/25.
//

import Network

// A protocol defining the interface for monitoring network connectivity.
public protocol NetworkMonitoringProtocol {
    
    /// A Boolean value indicating whether the network is currently available.
    var isNetworkAvailable: Bool { get }
    
    /// Detailed information about the current network connection.
    var connectionDetails: NetworkConnectionDetails { get }
    
    /// Starts monitoring network changes.
    func startMonitoring()
    
    /// Stops monitoring network changes.
    func stopMonitoring()
    
    /// Asynchronously monitors network status changes.
    /// - Returns: An `AsyncStream` that emits `NWPath.Status` updates.
    func monitorNetworkStatus() -> AsyncStream<NWPath.Status>
}
