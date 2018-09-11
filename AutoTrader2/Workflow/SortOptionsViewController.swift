import Foundation
import UIKit

protocol SortOptionsViewControllerDelegate: class {
    var selections: [Selection] { get }
    func newSelection(at: Int)
    func selectionsCompleted()
}

class SortOptionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: SortOptionsViewControllerDelegate?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Log.info("Sort Options Being Dismissed!")
        delegate?.selectionsCompleted()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.selections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let optionCell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as? SortOptionTableViewCell, let delegate = delegate else {
            return UITableViewCell()
        }
        let selection = delegate.selections[indexPath.row]
        optionCell.descriptionLabel.text = selection.option.displayName
        optionCell.accessoryType = selection.isChecked ? .checkmark : .none
        return optionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.newSelection(at: indexPath.row)
        tableView.reloadData()
    }
    
}

class SortOptionTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
}
