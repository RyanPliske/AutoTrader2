import Foundation

/*
 Saves an Array (order is guaranteed)
 [{"isChecked":false,"option":"lowestToHighestInPrice"},{"isChecked":false,"option":"aToZForMake"},{"isChecked":false,"option":"aToZForModel"},{"isChecked":false,"option":"oldestToNewest"}]
 */

class Selection_FlatFilePersistence: FlatFilePersistence {
    
    init(_ type: PersistenceType) {
        super.init(type, _fileName: "Selections")
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            let packagedSelectionsUrl = Bundle.main.url(forResource: "Selections", withExtension: "json")!
            try! FileManager.default.copyItem(at: packagedSelectionsUrl, to: fileURL)
        }
    }
    
    func write(_ selections: [SortSelection]) {
        do {
            let data = try encode(selections)
            try data.write(to: fileURL, options: Data.WritingOptions.atomicWrite)
        } catch let error as NSError {
            Log.error(error.debugDescription)
        }
    }
    
    var selections: [SortSelection] {
        do {
            let data = try Data(contentsOf: fileURL)
            return try decode([SortSelection].self, from: data)
        } catch let error as NSError {
            Log.error(error.debugDescription)
        }
        return []
    }
}
