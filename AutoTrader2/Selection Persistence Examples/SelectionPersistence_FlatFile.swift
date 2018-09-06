import Foundation

enum PersistenceType: String {
    case json
    case plist
}

/*
 Saves an Array (order is guaranteed)
 [{"isChecked":false,"option":1},{"isChecked":false,"option":2},{"isChecked":false,"option":0},{"isChecked":false,"option":3}]
 */

class SelectionPersistence_FlatFile: SelectionPersistenceProtocol {
    
    private let fileName: String
    private let fileURL: URL
    private let persistenceType: PersistenceType
    
    
    init(_ type: PersistenceType) {
        fileName = "Selections"
        fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(fileName, isDirectory: false)
            .appendingPathExtension(type.rawValue)
        persistenceType = type
        
        Log.debug("Persistence File Path: " + fileURL.path)
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        }
    }
    
    func write(_ selections: [Selection]) {
        do {
            let data = try encode(selections)
            try data.write(to: fileURL, options: Data.WritingOptions.atomicWrite)
        } catch let error as NSError {
            Log.error(error.debugDescription)
        }
    }
    
    var selections: [Selection] {
        do {
            let data = try Data(contentsOf: fileURL)
            return try decode([Selection].self, from: data)
        } catch let error as NSError {
            Log.error(error.debugDescription)
        }
        return []
    }
    
    private func encode<T>(_ value: T) throws -> Data where T : Encodable {
        switch persistenceType {
        case .json:
            return try JSONEncoder().encode(value)
        case .plist:
            return try PropertyListEncoder().encode(value)
        }
    }
    
    private func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        switch persistenceType {
        case .json:
            return try JSONDecoder().decode(type, from: data)
        case .plist:
            return try PropertyListDecoder().decode(type, from: data)
        }
    }
}
