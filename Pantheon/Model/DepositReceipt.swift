import Foundation

struct DepositReceipt: Identifiable, Codable {
    let id: String
    let amount: Double
    let date: Date
    let store: String
}


// Should delete
func generateMockDepositReceipts() -> [DepositReceipt] {
    let storeNames = [
        "REMA Torggata", "REMA Storo", "REMA Grunerløkka",
        "REMA Sinsen", "REMA Majorstuen", "REMA Løren",
        "REMA Grønland", "REMA Bislett", "REMA Skøyen",
        "REMA Nydalen"
    ]

    var mockReceipts: [DepositReceipt] = []

    for i in 1...10 {
        let randomStore = storeNames.randomElement()!
        let randomAmount = Double.random(in: 10...100)
        let randomDate = generateRandomDateInRange()
        let receipt = DepositReceipt(
            id: UUID().uuidString,
            amount: randomAmount,
            date: randomDate,
            store: randomStore
        )
        mockReceipts.append(receipt)
    }

    return mockReceipts
}

func generateRandomDateInRange() -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"

    let startDateString = "2024/08/01"
    let endDateString = "2024/10/31"

    guard let startDate = dateFormatter.date(from: startDateString),
          let endDate = dateFormatter.date(from: endDateString) else {
        return Date()
    }

    let timeInterval = Date().timeIntervalSince(startDate)
    let randomTimeInterval = TimeInterval.random(in: 0...(endDate.timeIntervalSince(startDate)))

    return startDate.addingTimeInterval(randomTimeInterval)
}

func generateOneMockReceipt() -> DepositReceipt {
    generateMockDepositReceipts()[0]
}

 var mockReceipts = generateMockDepositReceipts()
