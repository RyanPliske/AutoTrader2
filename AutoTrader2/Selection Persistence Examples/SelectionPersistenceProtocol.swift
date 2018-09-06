protocol SelectionPersistenceProtocol {
    func write(_ selections: [Selection])
    var selections: [Selection] { get }
}
