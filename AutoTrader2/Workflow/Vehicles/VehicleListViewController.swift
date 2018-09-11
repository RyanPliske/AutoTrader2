import UIKit

class CarsCell: UITableViewCell {
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
}

class VehicleListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var model: VehiclesModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        model = VehiclesModel()
        model.delegate = self
    }
    
    deinit {
        Log.info("vehicle list was deallocated")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vehicleViewController = segue.destination as? VehicleDetailViewController  {
            vehicleViewController.vehicle = model.selectedVehicle
        } else if let optionsViewController = segue.destination as? SortOptionsViewController {
            optionsViewController.delegate = self
        }
        
        super.prepare(for: segue, sender: sender)
    }
    
    lazy var priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter
    }()
    
}

extension VehicleListViewController: VehiclesModelDelegate {
    func dataUpdated() {
        tableView.reloadData()
    }
}

extension VehicleListViewController: SortOptionsViewControllerDelegate {
    func moveSelection(at source: IndexPath, to destination: IndexPath) {
        model.moveSelection(at: source, to: destination)
    }
    
    func selectionsCompleted() {
        model.selectionsCompleted()
    }
    
    var selections: [Selection] {
        return model.selections
    }
    
    func newSelection(at index: Int) {
        model.newSelection(at: index)
    }
    
}

extension VehicleListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Log.debug("User Selected row at \(indexPath.row)")
        model.vehicleSelected(at: indexPath.row)
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension VehicleListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let vehicleCell = tableView.dequeueReusableCell(withIdentifier: "carsCell", for: indexPath) as? CarsCell, let vehicle = model.vehicle(at: indexPath.row) else {
            return UITableViewCell()
        }
        vehicleCell.makeLabel.text = "Make: " + vehicle.make
        vehicleCell.modelLabel.text = "Model: " + vehicle.model
        vehicleCell.yearLabel.text = "Year: \(vehicle.year)"
        let priceString = priceFormatter.string(from: vehicle.price as NSNumber) ?? String(vehicle.price)
        vehicleCell.priceLabel.text = "Price: " + priceString
        return vehicleCell
    }
}

