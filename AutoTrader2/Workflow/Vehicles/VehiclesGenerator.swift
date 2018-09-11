import Foundation

protocol Countable { }

extension Countable where Self: RawRepresentable, Self.RawValue == Int {
    
    static func count() -> Int {
        var count = 0
        while let _ = Self(rawValue: count) { count += 1 }
        return count
    }
    
    static func cases() -> [Countable] {
        var cases = [Countable]()
        var count = 0
        while let `case` = Self(rawValue: count) {
            cases.append(`case`)
            count += 1
        }
        return cases
    }
    
    static func selectRandom() -> Countable {
        return Self(rawValue: self.randomValue())!
    }
    
    private static func randomValue() -> Int {
        let min = 0
        let max = self.count()
        return Int(arc4random_uniform(UInt32(max - min)) + UInt32(min))
    }
    
}

protocol FilterOption { }

enum VehicleType: Int, Countable, FilterOption {
    case fourDoor
    case twoDoor
    case smallSuv
    case bigSuv
    case truck
    case motorcycle
    
    var stringValue: String {
        switch self {
        case .fourDoor: return "fourDoor"
        case .twoDoor: return "twoDoor"
        case .smallSuv: return "smallSuv"
        case .bigSuv: return "bigSuv"
        case .truck: return "truck"
        case .motorcycle: return "motorcycle"
        }
    }
}

enum Make: Int, Countable, FilterOption {
    case honda
    case volkswagen
    case acura
    case audi
    case bmw
    case bugatti
    case buick
    case cadillac
    case chevrolet
    case chrysler
    case dodge
    case fiat
    case ford
    case gm
    case hyundai
    case infiniti
    case jaguar
    case jeep
    
    var stringValue: String {
        switch self {
        case .honda: return "honda"
        case .volkswagen: return "volkswagen"
        case .acura: return "acura"
        case .audi: return "audi"
        case .bmw: return "bmw"
        case .bugatti: return "bugatti"
        case .buick: return "buick"
        case .cadillac: return "cadillac"
        case .chevrolet: return "chevrolet"
        case .chrysler: return "chrysler"
        case .dodge: return "dodge"
        case .fiat: return "fiat"
        case .ford: return "ford"
        case .gm: return "gm"
        case .hyundai: return "hyundai"
        case .infiniti: return "infiniti"
        case .jaguar: return "jaguar"
        case .jeep: return "jeep"
        }
    }
}

enum Year: Int, Countable {
    case twoThousandTen
    case twoThousandEleven
    case twoThousandTwelve
    case twoThousandThirteen
    case twoThousandFourteen
    case twoThousandFifteen
    case twoThousandSixteen
    case twoThousandSeventeen
    case twoThousandEightteen
    
    var integerValue: Int {
        switch self {
        case .twoThousandTen: return 2010
        case .twoThousandEleven: return 2011
        case .twoThousandTwelve: return 2012
        case .twoThousandThirteen: return 2013
        case .twoThousandFourteen: return 2014
        case .twoThousandFifteen: return 2015
        case .twoThousandSixteen: return 2016
        case .twoThousandSeventeen: return 2017
        case .twoThousandEightteen: return 2018
        }
    }
}

struct Vehicle: Codable {
    let make: String
    let model: String
    let year: Int
    let id: UUID
    let price: Double
    let type: String
}

struct VehiclesGenerator {
    var vehicles: [Vehicle] {
        return (0...1000).map { _ in Vehicle(make: (Make.selectRandom() as! Make).stringValue, model: "Civic", year: (Year.selectRandom() as! Year).integerValue, id: UUID(), price: Double(arc4random_uniform(UInt32(60_000 - 1_000)) + UInt32(1_000)), type: (VehicleType.selectRandom() as! VehicleType).stringValue)  }
    }
}
