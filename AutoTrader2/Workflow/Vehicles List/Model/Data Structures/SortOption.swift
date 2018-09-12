import Foundation

enum SortOption: String, Codable, CaseIterable {
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
    
    static func optionFor(key: String) -> SortOption? {
        return SortOption.allCases.first(where: { key == $0.rawValue })
    }
}
