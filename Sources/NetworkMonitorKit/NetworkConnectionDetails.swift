//
//  NetworkConnectionDetails.swift
//
//
//  Created by Md. Rohejul Islam on 2/13/25.
//

import Foundation

/// A structure that provides detailed information about the current network connection.
public struct NetworkConnectionDetails {
    
    /// Indicates whether the network connection is considered expensive (e.g., cellular data).
    public let isExpensive: Bool
    
    /// The type of network interface currently in use (e.g., Wi-Fi, cellular, wired).
    public let interfaceType: InterfaceType
    
    /// Indicates whether the network supports DNS resolution.
    public let supportsDNS: Bool
    
    /// Indicates whether the network supports IPv4 connectivity.
    public let supportsIPv4: Bool
    
    /// Indicates whether the network supports IPv6 connectivity.
    public let supportsIPv6: Bool
    
    /// Initializes a new instance of `NetworkConnectionDetails`.
    /// - Parameters:
    ///   - isExpensive: A Boolean value indicating if the connection is costly.
    ///   - interfaceType: The type of network interface in use.
    ///   - supportsDNS: A Boolean value indicating DNS support.
    ///   - supportsIPv4: A Boolean value indicating IPv4 support.
    ///   - supportsIPv6: A Boolean value indicating IPv6 support.
    public init(
        isExpensive: Bool,
        interfaceType: InterfaceType,
        supportsDNS: Bool,
        supportsIPv4: Bool,
        supportsIPv6: Bool
    ) {
        self.isExpensive = isExpensive
        self.interfaceType = interfaceType
        self.supportsDNS = supportsDNS
        self.supportsIPv4 = supportsIPv4
        self.supportsIPv6 = supportsIPv6
    }
}

