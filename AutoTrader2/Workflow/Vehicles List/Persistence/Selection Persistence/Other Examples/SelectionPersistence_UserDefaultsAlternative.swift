import Foundation

/*
 Saves an Array (order is guaranteed)
 */

//
// This is NOT used within the app.. just here to display alternative ways to writing to disk
//
class SelectionPersistence_UserDefaultsAlternative {
    
    private let key = "Selections"
    
    func write(_ selections: [SortSelection]) {
        guard let data = try? JSONEncoder().encode(selections) else {
            Log.error("Failed to encode selections")
            return
        }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    var selections: [SortSelection] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            Log.error("Couldn't Find Selections for key: \(key)")
            return []
        }
        do {
            return try JSONDecoder().decode([SortSelection].self, from: data)
        } catch let error as NSError {
            Log.error(error.debugDescription)
            return []
        }
    }
}
