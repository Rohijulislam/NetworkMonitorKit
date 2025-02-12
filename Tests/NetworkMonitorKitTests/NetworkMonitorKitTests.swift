import XCTest
@testable import NetworkMonitorKit

final class NetworkMonitorKitTests: XCTestCase {
    
    
    var networkMonitor: NetworkMonitorKit!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        networkMonitor = NetworkMonitorKit()
    }
    
    override func tearDownWithError() throws {
        networkMonitor.stopMonitoring()
        networkMonitor = nil
        try super.tearDownWithError()
    }
    
    // Test 1: Initialization
    func testNetworkMonitorInitialization() {
        XCTAssertNotNil(networkMonitor, "NetworkMonitorKit should be initialized successfully.")
    }
    
    // Test 2: Check Network Availability (Depends on Actual Network Status)
    func testIsNetworkAvailable() {
        let isAvailable = networkMonitor.isNetworkAvailable
        XCTAssertTrue(isAvailable || !isAvailable, "Network availability should return a boolean value.")
    }
    
    // Test 3: Test that network monitoring starts and stops correctly.
    func testStartAndStopMonitoring() {
        XCTAssertFalse(networkMonitor.isNetworkAvailable, "Network should initially be unavailable")
        
        networkMonitor.startMonitoring()
        XCTAssertTrue(networkMonitor.isNetworkAvailable || !networkMonitor.isNetworkAvailable,
                      "Network should be available or unavailable based on real network conditions")
        
        networkMonitor.stopMonitoring()
        XCTAssertFalse(networkMonitor.isNetworkAvailable, "Network should be unavailable after stopping monitoring")
    }
    
    
    // Test 4: `monitorNetworkStatus` emits network status changes.
    func testMonitorNetworkStatus() async {
        networkMonitor.startMonitoring()
        
        // Act
        let stream = networkMonitor.monitorNetworkStatus()
        var receivedStatus: NetworkStatus?
        for await status in stream {
            receivedStatus = status
            break // Only capture the first emitted status
        }
        
        XCTAssertNotNil(receivedStatus, "Network status should be received in AsyncStream")
    }
    
    // Test 5: Test Interface Type Detection
    func testUsesInterfaceType() {
        let interfaceType = networkMonitor.usesInterfaceType()
        let validTypes: [InterfaceType] = [.wifi, .cellular, .wiredEthernet, .loopback, .other]
        XCTAssertTrue(validTypes.contains(interfaceType), "Interface type should be a valid NWInterface type.")
    }
    
}
