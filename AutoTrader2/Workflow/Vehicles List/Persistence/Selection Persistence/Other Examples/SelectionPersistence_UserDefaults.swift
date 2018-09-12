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

//
// This is NOT used within the app.. just here to display alternative ways to writing to disk
//
class SelectionPersistence_UserDefaults {

    private let key = "Selections"
    
    func write(_ selections: [SortSelection]) {
        let dict = selections.reduce(into: [String:Any](), { $0[$1.option.rawValue] = $1.isChecked })
        UserDefaults.standard.set(dict, forKey: key)
    }
    
    var selections: [SortSelection] {
        guard let dict = UserDefaults.standard.value(forKey: key) as? [String: Any] else {
            Log.error("Not Selections in Preferences")
            return []
        }
        return dict.compactMap {
            guard let isChecked = $0.value as? Bool, let option = SortOption.optionFor(key: $0.key) else {
                Log.error("Type Conversion Failed for key: \($0.key)")
                return nil
            }
            return SortSelection(option: option, isChecked: isChecked)
        }
    }
}
