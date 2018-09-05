import Foundation

class Log {
    static var line: String { return String((0...50).map { _ in return "-" }) }
    static func debug(_ message: String) { print("🤖 DEBUG" + line + "\n" + message) }
    static func info(_ message: String) { print("🎾 INFO" + line + "\n" + message) }
    static func error(_ message: String) { print("🔴 ERROR" + line + "\n" + message) }
}

enum FileType: String {
    case json
    case plist
}

class SelectionPersistence {
    
    private let fileType: FileType
    private let fileURL: URL
    
    init(_ type: FileType) {
        fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("Selections", isDirectory: false)
            .appendingPathExtension(type.rawValue)
        fileType = type
        
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
        switch fileType {
        case .json:
            return try JSONEncoder().encode(value)
        case .plist:
            return try PropertyListEncoder().encode(value)
        }
    }
    
    private func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        switch fileType {
        case .json:
            return try JSONDecoder().decode(type, from: data)
        case .plist:
            return try PropertyListDecoder().decode(type, from: data)
        }
    }
}

class VehiclesModel {
    private var unsortedVehicles = [Vehicle]()
    private var selectedIndex: Int
    private let selectionPersistence: SelectionPersistence
    private(set) var selections: [Selection]
    
    init() {
        unsortedVehicles = VehiclesGenerator().vehicles
        selectedIndex = 0
        selectionPersistence = SelectionPersistence(.json)
        selections = selectionPersistence.selections
        print(selections)
    }
    
    var selectedVehicle: Vehicle { return sortedVehicles[selectedIndex]  }
    
    lazy var sortedVehicles: [Vehicle] = {
        var vehicles = unsortedVehicles
        let selectedOptions = selections.compactMap { $0.isChecked ? $0.option : nil }
        
        if selectedOptions.contains(Option.lowestToHighestInPrice) {
            vehicles.sort(by: { $0.price < $1.price })
        }
        if selectedOptions.contains( Option.aToZForMake ) {
            vehicles.sort(by: { $0.make < $1.make })
        }
        if selectedOptions.contains( Option.aToZForModel ) {
            vehicles.sort(by: { $0.model < $1.model })
        }
        if selectedOptions.contains( Option.oldestToNewest ) {
            vehicles.sort(by: { $0.year > $1.year })
        }
        
        return vehicles
    }()
    
    var numberOfRows: Int { return unsortedVehicles.count }
    
    func newSelection(at index: Int) {
        selections[index].isChecked = !selections[index].isChecked
    }
    
    func vehicleSelected(at index: Int) {
        selectedIndex = index
    }
}
