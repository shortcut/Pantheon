import SwiftUI

@main
struct PantheonApp: App {
    @State private var receiptRepository = ReceiptRepository()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(.light)
                .environment(receiptRepository)
        }

    }
}
