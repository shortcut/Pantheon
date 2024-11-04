import Foundation

struct DepositReceipt: Identifiable, Codable, Equatable {
    enum State: String , Codable, CaseIterable, Identifiable {
        case normal = "Alle"
        case isNew = "Ny"
        case expiresSoon = "Utgår snart"
        case alreadyUsed = "Brukte"

        var id: String { self.rawValue }
    }

    let id: String
    let amount: Double
    let date: Date
    let store: String
    var state: State = .normal

    mutating func toggleState(_ state: State) {
        self.state = state
    }

    static func ==(lhs: DepositReceipt, rhs: DepositReceipt) -> Bool {
        lhs.id == rhs.id
    }
}
