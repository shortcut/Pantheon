import Foundation
import DesignSystem

struct DepositReceipt: Identifiable, Codable, Equatable {
    enum State: Int , Codable, CaseIterable, Identifiable {
        case normal
        case isNew
        case expiresSoon
        case alreadyUsed
        
        var title: String {
            switch self {
            case .normal: return "Alle"
            case .isNew: return "Ny"
            case .expiresSoon: return "Utgår"
            case .alreadyUsed: return "Brukte"
            }
        }

        var tagTitle: String {
            self == .normal ? "" : title
        }

        func tagBackgroundColor(with dsColors: DesignSystemColorProtocol) -> DSColor {
            switch self {
            case .expiresSoon: return dsColors.surfaceNotificationDefault
            case .isNew: return dsColors.surfaceSuccessSubtle
            case .normal: return dsColors.surfacePrimary
            case .alreadyUsed: return dsColors.surfaceActionDefault
            }
        }

        var id: Int {
            rawValue
        }
    }

    let id: String
    let amount: Double
    let date: Date
    let store: String
    var state: State = .normal

    mutating func toggleState(_ newState: State) {
        state = newState
    }

    static func == (lhs: DepositReceipt, rhs: DepositReceipt) -> Bool {
        lhs.id == rhs.id
    }
}
