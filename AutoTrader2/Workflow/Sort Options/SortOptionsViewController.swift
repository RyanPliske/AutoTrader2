import Foundation
import UIKit

// TODO: define data to populate range options
// TODO: add range selections to persistence

protocol SortOptionsViewControllerDelegate: class {
    var selections: [SortSelection] { get }
    func newSelection(at: Int)
    func selectionsCompleted()
    func moveSelection(at source: IndexPath, to destination: IndexPath)
}

class SortOptionsViewController: UIViewController {
    
    weak var delegate: SortOptionsViewControllerDelegate?
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var isInEditMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editButtonPressed))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Log.info("Sort Options Being Dismissed!")
        delegate?.selectionsCompleted()
    }
    
    @objc func doneButtonPressed() {
        Log.info("Done button pressed")
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func editButtonPressed() {
        Log.info("Edit button pressed")
        isInEditMode = !isInEditMode
        tableView.isEditing = isInEditMode
        navigationItem.rightBarButtonItem?.style = isInEditMode ? .plain : .done
    }
}

extension SortOptionsViewController: UITableViewDataSource {

    enum SortSections: Int, CaseIterable {
        case sortOptions = 0, rangeOptions

        var titleForHeaderInSection: String {
            switch(self) {
            case .sortOptions: return "Sort Options"
            case .rangeOptions: return "Range Options"
            }
        }

        var heightForRowInSection: CGFloat {
            switch(self) {
            case .sortOptions: return CGFloat(44)
            case .rangeOptions: return CGFloat(80)
            }
        }

        var canMoveRowInSection: Bool {
            switch(self) {
            case .sortOptions: return true
            case .rangeOptions: return false
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return SortSections.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sortSection = SortSections(rawValue: section) else { return 0 }

        switch(sortSection){
        case .sortOptions: return delegate?.selections.count ?? 0
        case .rangeOptions: return 1
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SortSections(rawValue: indexPath.section)?.heightForRowInSection ?? CGFloat(0)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SortSections(rawValue: section)?.titleForHeaderInSection ?? ""
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let delegate = delegate, let sortSection = SortSections(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        switch(sortSection){
        case .sortOptions:
            guard let sortCell = tableView.dequeueReusableCell(withIdentifier: "sortCell", for: indexPath) as? SortOptionTableViewCell else { return UITableViewCell() }
            let selection = delegate.selections[indexPath.row]
            sortCell.descriptionLabel.text = selection.option.displayName
            sortCell.accessoryType = selection.isChecked ? .checkmark : .none
            return sortCell
        case .rangeOptions:
            guard let rangeCell = tableView.dequeueReusableCell(withIdentifier: "rangeCell", for: indexPath) as? RangeOptionTableViewCell else { return UITableViewCell() }
            // TODO: - add isChecked feature to turn on/off range selection
            // TODO: - dynamically set these values from range options data
            rangeCell.rangeSlider.minimumValue = 0
            rangeCell.rangeSlider.maximumValue = 100
            rangeCell.descriptionLabel.text = "Price"
            rangeCell.detailLabel.text = "max"
            rangeCell.valueLabel.text = String(rangeCell.rangeSlider.value.rounded(.up))
            return rangeCell

        }

    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return SortSections(rawValue: indexPath.section)?.canMoveRowInSection ?? false
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        guard let sourceSection = SortSections(rawValue: sourceIndexPath.section),
            let destinationSection = SortSections(rawValue: proposedDestinationIndexPath.section),
            sourceSection == destinationSection
            else { return sourceIndexPath }

        return proposedDestinationIndexPath
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate?.moveSelection(at: sourceIndexPath, to: destinationIndexPath)
    }
}

extension SortOptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sortSection = SortSections(rawValue: indexPath.section) else { return }

        switch(sortSection){
        case .sortOptions:
            delegate?.newSelection(at: indexPath.row)
            tableView.reloadData()
        case .rangeOptions: return
            // TODO: - notify delegate of new range
        }
    }
}

class SortOptionTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
}

class RangeOptionTableViewCell: UITableViewCell {
    @IBOutlet weak var rangeSlider: UISlider!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    // TODO: update value label with rangeSlider value
}
