import SwiftUI
import DesignSystem

@main
struct PantheonApp: App {
    @StateObject private var receiptRepository = ReceiptRepository()
    
    private let designSystem = DesignSystem.default

    init () {
        configureNavigationAppearance()
    }
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(receiptRepository)
        }

    }
}

extension PantheonApp {
    private func configureNavigationAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(ds: designSystem.colors.textDefault),
            .font: UIFont.ds(designSystem.fonts.header3Subheading),
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(ds: designSystem.colors.textDefault),
            .font: UIFont.ds(designSystem.fonts.header1DisplayLarge),
        ]

        let barButtonAppearance = UIBarButtonItemAppearance()
        barButtonAppearance.normal.titleTextAttributes = [
            .font: UIFont.ds(designSystem.fonts.bodyMedium),
        ]

        appearance.buttonAppearance = barButtonAppearance
        appearance.backButtonAppearance = barButtonAppearance
        appearance.doneButtonAppearance = barButtonAppearance

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}
