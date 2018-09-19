import UIKit

class CarsCell: UITableViewCell {
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
}

class VehicleListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let model = VehiclesModel()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        model.delegate = self
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
//        navigationItem.titleView = searchController.searchBar
//        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "search vehicles"

        definesPresentationContext = true
    }
    
    deinit { Log.info("vehicle list was deallocated") }
    
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
        formatter.maximumFractionDigits = 0
        return formatter
    }()
}

extension VehicleListViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {

    }

    func didPresentSearchController(_ searchController: UISearchController) {

    }

    func willDismissSearchController(_ searchController: UISearchController) {

    }

    func willPresentSearchController(_ searchController: UISearchController) {

    }
    
}

extension VehicleListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }
//    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//    }
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//    }
//    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
//    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        model.clearFilteredVehicles()
    }
}

extension VehicleListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty {
            model.clearFilteredVehicles()
        } else {
            model.filterVehiclesFor(searchText: searchText)
        }
    }
}

extension VehicleListViewController: VehiclesModelDelegate {
    var isFiltering: Bool {
        let searchBarIsEmpty = searchController.searchBar.text?.isEmpty ?? true
        return searchController.isActive && !searchBarIsEmpty
    }

    func dataUpdated() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension VehicleListViewController: SortOptionsViewControllerDelegate {
    // TODO: pass along range selections

    func moveSelection(at source: IndexPath, to destination: IndexPath) {
        model.moveSelection(at: source, to: destination)
    }
    
    func selectionsCompleted() {
        model.selectionsCompleted()
    }
    
    var selections: [SortSelection] {
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

