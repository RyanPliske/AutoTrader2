import Foundation
import UIKit

class VehicleDetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var vehicle: Vehicle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let vehicle = vehicle else {
            return
        }
        self.textView.text = "\(vehicle.id.uuidString) \n \(vehicle.make) \n \(vehicle.model) \n \(vehicle.type)"
    }
    
}
