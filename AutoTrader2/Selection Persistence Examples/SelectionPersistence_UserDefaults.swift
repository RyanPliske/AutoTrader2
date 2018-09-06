import Foundation

/*
 Saves a Dictionary (order is not guaranteed)
 [
 "Selections" : [
    "oldestToNewest" : false,
    "aToZForMake" : false,
    "aToZForModel" : false,
    "oldestToNewest" : false
    ]
 ]
*/

class SelectionPersistence_UserDefaults: SelectionPersistenceProtocol {

    private let key = "Selections"
    
    func write(_ selections: [Selection]) {
        let dict = selections.reduce(into: [String:Any](), { $0[$1.option.key] = $1.isChecked })
        UserDefaults.standard.set(dict, forKey: key)
    }
    
    var selections: [Selection] {
        guard let dict = UserDefaults.standard.value(forKey: key) as? [String: Any] else {
            Log.error("Not Selections in Preferences")
            return []
        }
        return dict.compactMap {
            guard let isChecked = $0.value as? Bool, let option = Option.optionFor(key: $0.key) else {
                Log.error("Type Conversion Failed for key: \($0.key)")
                return nil
            }
            return Selection(option: option, isChecked: isChecked)
        }
    }
}
