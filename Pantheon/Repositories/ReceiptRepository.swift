import SwiftUI
import Observation


class ReceiptRepository: ObservableObject {
    @Published var receipts: [DepositReceipt] = []
    @Published var filteredReceipts: [DepositReceipt] = []

    init() {
        receipts.append(generateStartReceipt(state: .isNew))
        receipts.append(generateStartReceipt(state: .normal))
        receipts.append(generateStartReceipt(state: .expiresSoon))
        receipts.append(generateStartReceipt(state: .alreadyUsed))
        filteredReceipts = receipts
    }
}

//MARK: - Public methods
extension ReceiptRepository {
    func addReceipt() {
        let receipt = generateMockReceipt()
        if !receipts.isEmpty {
            receipts[0].toggleState(.normal)
        }
        receipts.insert(receipt, at: 0)
        filteredReceipts = receipts
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
    // This is to show all state's when the app starts. Will be removed later
    func generateStartReceipt(state: DepositReceipt.State) -> DepositReceipt {
            let storeNames = [
                "REMA 1000 Torggata", "REMA 1000 Storo", "REMA 1000 Grunerløkka",
                "REMA 1000 Sinsen", "REMA 1000 Majorstuen", "REMA 1000 Løren",
                "REMA 1000 Grønland", "REMA 1000 Bislett", "REMA 1000 Skøyen",
                "REMA 1000 Nydalen"
            ]

            let randomStore = storeNames.randomElement()!
            let randomAmount = Double.random(in: 10...100)
            let randomDate = Date.generateRandomDateInRange()
            let receipt = DepositReceipt(
                id: UUID().uuidString,
                amount: randomAmount,
                date: randomDate,
                store: randomStore,
                state: state
            )

            return receipt
        }

        func generateMockReceipt() -> DepositReceipt {
            let storeNames = [
                "REMA 1000 Torggata", "REMA 1000 Storo", "REMA 1000 Grunerløkka",
                "REMA 1000 Sinsen", "REMA 1000 Majorstuen", "REMA 1000 Løren",
                "REMA 1000 Grønland", "REMA 1000 Bislett", "REMA 1000 Skøyen",
                "REMA 1000 Nydalen"
            ]

            let randomStore = storeNames.randomElement()!
            let randomAmount = Double.random(in: 10...100)
            let randomDate = Date.generateRandomDateInRange()
            var receipt = DepositReceipt(
                id: UUID().uuidString,
                amount: randomAmount,
                date: randomDate,
                store: randomStore,
                state: DepositReceipt.State.allCases.randomElement() ?? .normal
            )

            receipt.toggleState(.isNew)
            return receipt
        }

    // Save in case of later use
//    func generateRandomReceipts() -> [DepositReceipt] {
//        let storeNames = [
//            "REMA 1000 Torggata", "REMA 1000 Storo", "REMA 1000 Grunerløkka",
//            "REMA 1000 Sinsen", "REMA 1000 Majorstuen", "REMA 1000 Løren",
//            "REMA 1000 Grønland", "REMA 1000 Bislett", "REMA 1000 Skøyen",
//            "REMA 1000 Nydalen"
//        ]
//
//        var mockReceipts: [DepositReceipt] = []
//
//        for _ in 1...10 {
//            let randomStore = storeNames.randomElement()!
//            let randomAmount = Double.random(in: 10...100)
//            let randomDate = Date.generateRandomDateInRange()
//            let receipt = DepositReceipt(
//                id: UUID().uuidString,
//                amount: randomAmount,
//                date: randomDate,
//                store: randomStore,
//                state: DepositReceipt.State.allCases.randomElement() ?? .normal
//            )
//            mockReceipts.append(receipt)
//        }
//
//        return mockReceipts
//    }
//
//    func generateMockReceipt() -> DepositReceipt {
//        guard var randomReceipt = generateRandomReceipts().randomElement() else {
//            fatalError("Could not generate mock receipt")
//        }
//
//        randomReceipt.toggleState(.isNew)
//        return randomReceipt
//    }
}
