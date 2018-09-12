import Foundation

struct Selection: Codable {
    let option: Option
    var isChecked: Bool
}

enum Option: Int, Codable, CaseIterable {
    case lowestToHighestInPrice
    case aToZForMake
    case aToZForModel
    case oldestToNewest
    
    var displayName: String {
        switch self {
        case .lowestToHighestInPrice:
            return "Lowest to Highest Price"
        case .aToZForMake:
            return "A to Z For Make of Vehicle"
        case .aToZForModel:
            return "A to Z For Model of Vehicle"
        case .oldestToNewest:
            return "Oldest to Newest"
        }
    }
    var key: String {
        switch self {
        case .lowestToHighestInPrice:
            return "lowestToHighestInPrice"
        case .aToZForMake:
            return "aToZForMake"
        case .aToZForModel:
            return "aToZForModel"
        case .oldestToNewest:
            return "oldestToNewest"
        }
    }
    
    static func optionFor(key: String) -> Option? {
        return Option.allCases.first(where: { $0.key == key })
    }
}
