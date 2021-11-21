import Foundation
import Network
class Network {
    static let shared = Network()
    private let monitor = NWPathMonitor()
    func setupNetPathMonitor() {
        monitor.pathUpdateHandler = { _ in  }
        let queue = DispatchQueue(label: "netWorkMonitor")
        monitor.start(queue: queue)
    }
    func isOnline() -> Bool {
        return monitor.currentPath.status == .satisfied
    }
}
