import Network
import Combine

public typealias InterfaceType = NWInterface.InterfaceType
public typealias NetworkStatus = NWPath.Status

final public class NetworkMonitorKit {
    
    // MARK: - Private Properties
    
    /// The underlying `NWPathMonitor` instance used to monitor network changes.
    private let monitor: NWPathMonitor
    
    /// A flag indicating whether the monitor is currently active.
    private var isMonitoring = false
    
    /// An `AsyncStream` that emits network status changes as they occur.
    private var networkStatusStream: AsyncStream<NWPath.Status>?
    
    /// The continuation used to push new network status updates into the `AsyncStream`.
    private var networkStatusContinuation: AsyncStream<NWPath.Status>.Continuation?
    
    // MARK: - Initialization
    
    public init(monitor: NWPathMonitor = NWPathMonitor()) {
        self.monitor = monitor
    }
    
    // MARK: - Deinitialization
    
    deinit {
        stopMonitoring()
        
    }
}

extension NetworkMonitorKit: NetworkMonitoringProtocol {
    
    /// Checks whether the network is currently available.
    ///
    /// - Returns: `true` if the network is available; otherwise, `false`.
    public var isNetworkAvailable: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    /// Provides detailed information about the current network connection.
    /// - Returns: A `NetworkConnectionDetails` instance containing information about the current network connection.
    public var connectionDetails: NetworkConnectionDetails {
        let path = monitor.currentPath
        return NetworkConnectionDetails(
            isExpensive: path.isExpensive,
            interfaceType: usesInterfaceType(),
            supportsDNS: path.supportsDNS,
            supportsIPv4: path.supportsIPv4,
            supportsIPv6: path.supportsIPv6
        )
    }
    
    /// Starts monitoring network status changes.
    public func startMonitoring() {
        guard !isMonitoring else { return }
        
        setupNetworkStatusStream()
        setupPathUpdateHandler()
        startMonitorOnBackgroundQueue()
        isMonitoring.toggle()
    }
    
    /// Stop monitoring network status changes.
    public func stopMonitoring() {
        guard isMonitoring else {
            Logger.log("NetworkMonitor is not currently monitoring.")
            return
        }
        
        monitor.cancel()
        isMonitoring.toggle()
        networkStatusContinuation?.finish()
    }
    
    /// Asynchronously monitors network status changes.
    ///
    /// This method returns an `AsyncStream` that emits network status changes as they occur. You can use
    /// this stream in an asynchronous context to respond to network status updates.
    ///
    /// - Returns: An `AsyncStream` that emits `NWPath.Status` values representing the current network status.
    public func monitorNetworkStatus() -> AsyncStream<NWPath.Status> {
        guard let stream = networkStatusStream else {
            return AsyncStream { continuation in
                continuation.finish()
            }
        }
        return stream
    }
    
}

extension NetworkMonitorKit {
    
    // MARK: - Public Methods
    
    /// Checks whether the device is connected via Wi-Fi.
    ///
    /// - Returns: `true` if the device is connected via Wi-Fi; otherwise, `false`.
    public func isConnectedViaWiFi() -> Bool {
        let path = monitor.currentPath
        return path.status == .satisfied && path.usesInterfaceType(.wifi)
    }
    
    /// Checks whether the device is connected via a cellular network.
    ///
    /// - Returns: `true` if the device is connected via a cellular network; otherwise, `false`.
    public func isConnectedViaCellular() -> Bool {
        let path = monitor.currentPath
        return path.status == .satisfied && path.usesInterfaceType(.cellular)
    }
    
    /// Determines the current network interface type.
    /// - Returns: The detected `InterfaceType`, or `.other` if unknown.
    public func usesInterfaceType() -> InterfaceType {
        let path = monitor.currentPath
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .wiredEthernet
        } else if path.usesInterfaceType(.loopback) {
            return .loopback
        } else {
            return .other
        }
    }
    
    // MARK: - Private Methods
    
    /// Configures the `AsyncStream` for network status updates.
    private func setupNetworkStatusStream() {
        networkStatusStream = AsyncStream { continuation in
            self.networkStatusContinuation = continuation
        }
    }
    
    /// Sets up the path update handler for network status changes.
    private func setupPathUpdateHandler() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.networkStatusContinuation?.yield(path.status)
            self.logNetworkStatus(path.status)
        }
    }
    
    /// /// Starts the network monitor on a background queue.
    private func startMonitorOnBackgroundQueue() {
        let queue = DispatchQueue(label: "com.networkmonitorkit.monitor",
                                  qos: .utility)
        monitor.start(queue: queue)
    }
    
    // Logs network status updates for debugging purposes.
    /// - Parameter status: The current `NWPath.Status`.
    private func logNetworkStatus(_ status: NWPath.Status) {
        Logger.log(status == .satisfied ? "Network is available." : "Network is unavailable.")
    }
}

// MARK: - Logger

private enum Logger {
    /// Logs messages when in debug mode.
    /// - Parameter message: The message to log.
    static func log(_ message: String) {
#if DEBUG
        print("[NetworkMonitorKit] \(message)")
#endif
    }
}
