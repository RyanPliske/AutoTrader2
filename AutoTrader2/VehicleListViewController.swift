import UIKit

class CarsCell: UITableViewCell {
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
}

class VehicleListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var model: VehiclesModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        model = VehiclesModel()
    }
    
    deinit {
        print("vehicle list was deallocated")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vehicleViewController = segue.destination as? VehicleDetailViewController  {
            vehicleViewController.vehicle = model.selectedVehicle
        } else if let optionsViewController = segue.destination as? SortOptionsViewController {
            optionsViewController.delegate = self
        }
        
        super.prepare(for: segue, sender: sender)
    }
    
}

extension VehicleListViewController: SortOptionsViewControllerDelegate {
    var selections: [Selection] {
        return model.selections
    }
    
    func newSelection(at index: Int) {
        model.newSelection(at: index)
    }
    
}

extension VehicleListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("🤠 User Selected row at \(indexPath.row)")
        model.vehicleSelected(at: indexPath.row)
        performSegue(withIdentifier: "showDetails", sender: self)
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
        guard let vehicleCell = tableView.dequeueReusableCell(withIdentifier: "carsCell", for: indexPath) as? CarsCell else {
            return UITableViewCell()
        }
        let vehicle = model.sortedVehicles[indexPath.row]
        vehicleCell.makeLabel.text = "Make: " + vehicle.make
        vehicleCell.modelLabel.text = "Model: " + vehicle.model
        vehicleCell.yearLabel.text = "Year \(vehicle.year)"
        
        return vehicleCell
    }
}

