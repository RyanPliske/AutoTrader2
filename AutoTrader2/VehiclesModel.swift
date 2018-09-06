import Foundation

protocol VehiclesModelDelegate: class {
    func dataUpdated()
}

class VehiclesModel {
    weak var delegate: VehiclesModelDelegate?
    private(set) var selections: [Selection]
    
    private var vehicles = [Vehicle]()
    private var selectedIndex: Int
    private let selectionPersistence: SelectionPersistenceProtocol
    private var hasNewSelections: Bool
    
    init() {
        vehicles = VehiclesGenerator().vehicles
        selectedIndex = 0
        let selectionsToWrite = [
            Selection(option: Option.lowestToHighestInPrice, isChecked: false),
            Selection(option: Option.aToZForMake, isChecked: false),
            Selection(option: Option.aToZForModel, isChecked: false),
            Selection(option: Option.oldestToNewest, isChecked: false)
        ]
//        SelectionPersistence_FlatFile(.plist).write(selectionsToWrite)
//        SelectionPersistence_UserDefaults().write(selectionsToWrite)
        let persistence = SelectionPersistence_FlatFile(.json)
        persistence.write(selectionsToWrite)
        selectionPersistence = persistence
        selections = persistence.selections
        hasNewSelections = false
        Log.info(selections.description)
    }
    
    var selectedVehicle: Vehicle { return vehicles[selectedIndex]  }
    
    var numberOfRows: Int { return vehicles.count }
    
    func newSelection(at index: Int) {
        selections[index].isChecked = !selections[index].isChecked
        hasNewSelections = true
    }
    
    func vehicleSelected(at index: Int) {
        selectedIndex = index
    }
    
    func vehicle(at index: Int) -> Vehicle? {
        guard index <= vehicles.count - 1 else {
            return nil
        }
        return vehicles[index]
    }
    
    func selectionsCompleted() {
        guard hasNewSelections else { return }
        
        let selectedOptions = selections.compactMap { $0.isChecked ? $0.option : nil }
        
        vehicles.sort(by: {
            for option in selectedOptions {
                switch option {
                case .lowestToHighestInPrice:
                    if $1.price < $0.price {
                        return false
                    }
                case .aToZForMake:
                    if $1.make < $0.make {
                        return false
                    }
                case .aToZForModel:
                    if $1.model < $0.model {
                        return false
                    }
                case .oldestToNewest:
                    if $1.year < $0.year {
                        return false
                    }
                }
            }
            return true
        })
        
        delegate?.dataUpdated()
        selectionPersistence.write(selections)
        hasNewSelections = false
    }
}
