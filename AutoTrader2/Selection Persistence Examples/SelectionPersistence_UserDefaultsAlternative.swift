import Foundation

class SelectionPersistence_UserDefaultsAlternative: SelectionPersistenceProtocol {
    
    private let key = "Selections"
    
    func write(_ selections: [Selection]) {
        guard let data = try? JSONEncoder().encode(selections) else {
            Log.error("Failed to encode selections")
            return
        }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    var selections: [Selection] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            Log.error("Couldn't Find Selections for key: \(key)")
            return []
        }
        do {
            return try JSONDecoder().decode([Selection].self, from: data)
        } catch let error as NSError {
            Log.error(error.debugDescription)
            return []
        }
    }
}
