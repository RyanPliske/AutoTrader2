import Foundation

protocol VehiclesModelDelegate: class {
    func dataUpdated()
}

struct Vehicle: Codable {
    let make: String
    let model: String
    let year: Int
    let id: UUID
    let price: Double
}

class VehiclesModel {
    weak var delegate: VehiclesModelDelegate?
    private(set) var selections: [Selection]
    
    private var vehicles = [Vehicle]()
    private let selectionPersistence: SelectionPersistenceProtocol
    private var selectedVehicleIndex = 0
    private var hasNewSelections = false
    private let concurrentQueue = DispatchQueue.init(label: "VehiclesModel", qos: .userInitiated, attributes: [.concurrent])
    
    init() {
        let selectionsToWrite = [
            Selection(option: Option.lowestToHighestInPrice, isChecked: false),
            Selection(option: Option.aToZForMake, isChecked: false),
            Selection(option: Option.aToZForModel, isChecked: false),
            Selection(option: Option.oldestToNewest, isChecked: false)
        ]
        let persistence = SelectionPersistence_FlatFile(.json)
        selectionPersistence = persistence
        let selectionsFromPersistence = persistence.selections
        if selectionsFromPersistence.isEmpty {
            persistence.write(selectionsToWrite)
            selections = selectionsToWrite
        }
        selections = selectionsFromPersistence
        vehicles = []
        SpinnerView.sharedInstance.show()
        concurrentQueue.async { [unowned self] in
            self.vehicles = Generator.generateVehicles()
            self.delegate?.dataUpdated()
            SpinnerView.sharedInstance.hide()
        }
    }
    
    var selectedVehicle: Vehicle { return vehicles[selectedVehicleIndex]  }
    
    var numberOfRows: Int { return vehicles.count }
    
    func newSelection(at index: Int) {
        selections[index].isChecked = !selections[index].isChecked
        hasNewSelections = true
    }
    
    func vehicleSelected(at index: Int) {
        selectedVehicleIndex = index
    }
    
    func vehicle(at index: Int) -> Vehicle? {
        guard index <= vehicles.count - 1 else {
            return nil
        }
        return vehicles[index]
    }
    
    func moveSelection(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let selectionToMove =  selections[sourceIndexPath.row]
        selections.remove(at: sourceIndexPath.row)
        selections.insert(selectionToMove, at: destinationIndexPath.row)
        hasNewSelections = true
    }
    
    func selectionsCompleted() {
        guard hasNewSelections else { return }
        SpinnerView.sharedInstance.show()
        concurrentQueue.async { [unowned self] in
            let selectedOptions = self.selections.compactMap { $0.isChecked ? $0.option : nil }
            
            self.vehicles.sort(by: {
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
            
            self.delegate?.dataUpdated()
            SpinnerView.sharedInstance.hide()
            self.selectionPersistence.write(self.selections)
            self.hasNewSelections = false
        }
    }
}
