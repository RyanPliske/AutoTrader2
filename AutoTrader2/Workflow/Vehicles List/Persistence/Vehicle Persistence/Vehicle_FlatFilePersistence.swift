import Foundation

class Vehicle_FlatFilePersistence: FlatFilePersistence {
    
    init(_ type: PersistenceType) {
        super.init(type, _fileName: "Vehicles")
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            let packagedVehiclesUrl = Bundle.main.url(forResource: "Vehicles", withExtension: "json")!
            try! FileManager.default.copyItem(at: packagedVehiclesUrl, to: fileURL)
        }
    }
    
    func write(_ vehicles: [Vehicle]) {
        do {
            let data = try encode(vehicles)
            try data.write(to: fileURL, options: Data.WritingOptions.atomicWrite)
        } catch let error as NSError {
            Log.error(error.debugDescription)
        }
    }
    
    var vehicles: [Vehicle] {
        do {
            let data = try Data(contentsOf: fileURL)
            return try decode([Vehicle].self, from: data)
        } catch let error as NSError {
            Log.error(error.debugDescription)
        }
        return []
    }
}
