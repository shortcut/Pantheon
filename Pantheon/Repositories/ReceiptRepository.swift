import SwiftUI
import Observation


@Observable
class ReceiptRepository {
    var receipts: [DepositReceipt] = []

    init() {
        receipts = generateRandomReceipts()
    }
}

//MARK: - Public methods
extension ReceiptRepository {
    func addRandomReceipt() {
        let receipt = generateMockReceipt()
        receipts[0].toggleState(.normal)
        receipts.insert(receipt, at: 0)
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
