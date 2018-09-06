import Foundation

class VehiclesModel {
    private var unsortedVehicles = [Vehicle]()
    private var selectedIndex: Int
    private let selectionPersistence: SelectionPersistenceProtocol
    private(set) var selections: [Selection]
    
    init() {
        unsortedVehicles = VehiclesGenerator().vehicles
        selectedIndex = 0
        let selectionsToWrite = [
            Selection(option: Option.aToZForMake, isChecked: false),
            Selection(option: Option.aToZForModel, isChecked: false),
            Selection(option: Option.lowestToHighestInPrice, isChecked: false),
            Selection(option: Option.oldestToNewest, isChecked: false)
        ]
        SelectionPersistence_FlatFile(.plist).write(selectionsToWrite)
        SelectionPersistence_FlatFile(.json).write(selectionsToWrite)
        SelectionPersistence_UserDefaults().write(selectionsToWrite)
        selectionPersistence = SelectionPersistence_UserDefaults()
        selections = selectionPersistence.selections
        Log.info(selections.description)
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
