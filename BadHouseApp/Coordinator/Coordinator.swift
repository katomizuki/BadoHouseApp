protocol Coordinator {
    func start()
    func coordinator(to coordinator: Coordinator)
}
extension Coordinator {
    func coordinator(to coordinator: Coordinator) {
        coordinator.start()
    }
}
