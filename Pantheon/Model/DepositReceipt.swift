import Foundation

struct DepositReceipt: Identifiable, Codable {
    enum State: Int , Codable, CaseIterable {
        case isNew
        case expiresSoon
        case normal
        case alreadyUsed
    }

    let id: String
    let amount: Double
    let date: Date
    let store: String
    var state: State = .normal

    mutating func toggleState(_ state: State) {
        self.state = state
    }
}
