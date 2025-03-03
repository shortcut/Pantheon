import Foundation

extension Date {
    static func generateRandomDateInRange() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"

        let startDateString = "2024/08/01"
        let endDateString = "2024/10/05"

        guard let startDate = dateFormatter.date(from: startDateString),
              let endDate = dateFormatter.date(from: endDateString) else {
            return Date()
        }

        let randomTimeInterval = TimeInterval.random(in: 0...(endDate.timeIntervalSince(startDate)))

        return startDate.addingTimeInterval(randomTimeInterval)
    }
}

/// For accessibility
extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d. MMMM"
        return formatter.string(from: self)
    }

    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
