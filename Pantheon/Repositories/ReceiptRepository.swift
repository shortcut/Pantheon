import SwiftUI
import Observation


class ReceiptRepository: ObservableObject {
    @Published var receipts: [DepositReceipt] = []
    @Published var filteredReceipts: [DepositReceipt] = []

    init() {
        receipts = generateRandomReceipts()
        filteredReceipts = receipts
    }
}

//MARK: - Public methods
extension ReceiptRepository {
    func addRandomReceipt() {
        let receipt = generateMockReceipt()
        receipts[0].toggleState(.normal)
        receipts.insert(receipt, at: 0)
    }

    func filter(by state: DepositReceipt.State) {
        switch state {
        case .normal:
            filteredReceipts = receipts
        case .isNew:
            filteredReceipts = receipts.filter { $0.state == .isNew }
        case .expiresSoon:
            filteredReceipts = receipts.filter { $0.state == .expiresSoon }
        case .alreadyUsed:
            filteredReceipts = receipts.filter { $0.state == .alreadyUsed }
        }
    }
}

//MARK: - Private methods
private extension ReceiptRepository {
    func generateRandomReceipts() -> [DepositReceipt] {
        let storeNames = [
            "REMA Torggata", "REMA Storo", "REMA Grunerløkka",
            "REMA Sinsen", "REMA Majorstuen", "REMA Løren",
            "REMA Grønland", "REMA Bislett", "REMA Skøyen",
            "REMA Nydalen"
        ]

        var mockReceipts: [DepositReceipt] = []

        for _ in 1...10 {
            let randomStore = storeNames.randomElement()!
            let randomAmount = Double.random(in: 10...100)
            let randomDate = Date.generateRandomDateInRange()
            let receipt = DepositReceipt(
                id: UUID().uuidString,
                amount: randomAmount,
                date: randomDate,
                store: randomStore,
                state: DepositReceipt.State.allCases.randomElement() ?? .normal
            )
            mockReceipts.append(receipt)
        }

        return mockReceipts
    }

    func generateMockReceipt() -> DepositReceipt {
        guard var randomReceipt = generateRandomReceipts().randomElement() else {
            fatalError("Could not generate mock receipt")
        }

        randomReceipt.toggleState(.isNew)
        return randomReceipt
    }
}
