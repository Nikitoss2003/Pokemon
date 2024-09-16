import Network

class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private var isConnected: Bool = false

    init() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isConnected = true
                print("Internet connection is available.")
            } else {
                self.isConnected = false
                print("No internet connection.")
            }
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }

    func isInternetAvailable() -> Bool {
        return isConnected
    }
}

