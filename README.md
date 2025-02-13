# 📡 NetworkMonitorKit
*A simple Swift package to monitor network connectivity using `NWPathMonitor`.*  

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![Platforms](https://img.shields.io/badge/platforms-iOS%20|%20macOS%20|%20visionOS%20|%20watchOS-blue)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 📌 Features
✅ Detects real-time network connectivity changes.  
✅ Supports Wi-Fi, Cellular, Ethernet, and Loopback interfaces.  
✅ Provides details like IPv4/IPv6 support and DNS availability.  
✅ Uses `AsyncStream` for easy async monitoring.  

---

## Installation

### Using Swift Package Manager (SPM)
1. Open **Xcode**, go to **File** → **Add Packages**.  
2. Enter the repository URL: https://github.com/Rohijulislam/NetworkMonitorKit.git
3. Select **Add Package** and import it into your project:  
```swift
import NetworkMonitorKit
```
## 🛠️ Usage

### 1️⃣ Start Monitoring Network Status
```swift
let networkMonitor = NetworkMonitorKit()
networkMonitor.startMonitoring()
```

### 2️⃣ Check if Network is Available
```swift
if networkMonitor.isNetworkAvailable {
    print("✅ Network is available")
} else {
    print("❌ No network connection")
}
```

### 3️⃣ Get Connection Details
```swift
let details = networkMonitor.connectionDetails
print("Interface Type: \(details.interfaceType)")
print("Supports IPv4: \(details.supportsIPv4)")
print("Supports IPv6: \(details.supportsIPv6)")
```

### 4️⃣ Monitor Network Status Asynchronously
```swift
Task {
    for await status in networkMonitor.monitorNetworkStatus() {
        print("🔄 Network status changed: \(status)")
    }
}
```

## License
This package is released under the MIT License.
