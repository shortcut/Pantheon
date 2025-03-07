import SwiftUI
import DesignSystem

/// SheetType enum for use when navigating sheets
enum SheetType: Identifiable {
    case payment(DepositReceipt)
    case transferToAccount
    case transferToShopping
    case transferToAssociation
    case confirmTransferToAssociation
    case scanSuccess(DepositReceipt)


    var id: String {
        switch self {
        case .payment:
            return "payment"
        case .transferToAccount:
            return "transferToAccount"
        case .transferToShopping:
            return "transferToTrip"
        case .transferToAssociation:
            return "transferToAssociation"
        case .confirmTransferToAssociation:
            return "confirmTransferToAssociation"
        case .scanSuccess:
            return "scanSuccess"
        }
    }
}

/// FullScreenCoverType enum to make sure the scanner use full screen. Might be used for other things later
enum FullScreenCoverType: Identifiable {
    case scanner

    var id: String {
        switch self {
        case .scanner:
            return "scanner"
        }
    }
}

/// HomeView, the landing page, also holds the navigation of sheets
struct HomeView: View {
    @EnvironmentObject fileprivate var receiptRepository: ReceiptRepository

    @Environment(\.designSystemFonts) fileprivate var dsFonts
    @Environment(\.designSystemColors) fileprivate var dsColors
    @Environment(\.designSystemIcons) fileprivate var dsIcons
    @Environment(\.designSystemSizing) fileprivate var dsSizing
    @Environment(\.designSystemSpacing) fileprivate var dsSpacing
    @Environment(\.designSystemIllustrations) fileprivate var dsIllustrations

    @StateObject private var homeViewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(receiptRepository.filteredReceipts) { receipt in
                    Button {
                        homeViewModel.selectedReceipt = receipt
                    } label: {
                        ReceiptCell(receipt: receipt)
                    }
                    .buttonStyle(.listItemButton)
                }
            }
            .listStyle(.insetGrouped)
            .defaultListBackground()
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Pantelapper")
            .toolbar(content: {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    SegmentedControl(selection: $homeViewModel.filteredState, options: DepositReceipt.State.allCases.map{$0.title})
                    Spacer()
                }
            })
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        homeViewModel.activeFullScreenCover = .scanner
                        homeViewModel.shouldStartScanning = true
                    } label: {
                        Image(ds: dsIcons.utilityScannerBarCode)
                            .resizable()
                            .frame(width: dsSizing.size2XL, height: dsSizing.size2XL)
                    }
                    .accessibilityLabel("QR kode skanner.")
                    .accessibilityHint("Dobbeltrykk for å åpne skanneren.")
                }
            })
        }
        .defaultStyles()
        .sheet(item: $homeViewModel.activeSheet, onDismiss: {
            homeViewModel.selectedReceipt = nil
        }) { sheet in
            selectedReceiptSheetContent(sheet)
        }
        .fullScreenCover(item: $homeViewModel.activeFullScreenCover) { cover in
            switch cover {
            case .scanner:
                ScannerView(
                    scannedCode: $homeViewModel.scannedCode,
                    shouldStartScanning: $homeViewModel.shouldStartScanning
                )
            }
        }
        .onChange(of: homeViewModel.scannedCode) { _ in
            handleScan()
        }
        .onChange(of: homeViewModel.selectedReceipt) { receipt in
            handleSelection(of: receipt)
        }
        .onChange(of: homeViewModel.filteredState) { newValue in
            let newState = DepositReceipt.State(rawValue: newValue) ?? .normal
            updateFilter(with: newState)
        }
    }
}

//MARK: - Private methods
private extension HomeView {
    // Handle scan, adding receipt (mock random receipt for now), and recets the scanner.
    func handleScan() {
        guard homeViewModel.scannedCode != nil else {
            return
        }

        receiptRepository.addReceipt()

        guard let newReceipt = receiptRepository.receipts.first else {
            return
        }

        homeViewModel.activeSheet = .scanSuccess(newReceipt)
        homeViewModel.scannedCode = nil
        homeViewModel.activeFullScreenCover = nil
    }

    func handleSelection(of receipt: DepositReceipt?) {
        guard let receipt else {
            return
        }

        withAnimation {
            homeViewModel.activeSheet = .payment(receipt)
        }
    }

    func updateFilter(with state: DepositReceipt.State) {
        withAnimation {
            receiptRepository.filter(by: state)
        }
    }
}

// MARK: - Components
private extension HomeView {
    // Handle which sheet is displayed
    @ViewBuilder
    func selectedReceiptSheetContent(_ sheet: SheetType) -> some View {
        switch sheet {
        case .payment(let receipt):
            if #available(iOS 16.0, *) {
                PaymentView(receipt: receipt,
                            depositAmount: $homeViewModel.depositAmount,
                            activeSheet: $homeViewModel.activeSheet)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            } else {
                PaymentView(receipt: receipt,
                            depositAmount: $homeViewModel.depositAmount,
                            activeSheet: $homeViewModel.activeSheet)
            }
        case .transferToAccount:
            TransferToAccountView(depositAmount: $homeViewModel.depositAmount)
        case .transferToShopping:
            TransferToShoppingView(depositAmount: $homeViewModel.depositAmount)
        case .transferToAssociation:
            TransferToAssociationView(activeSheet: $homeViewModel.activeSheet, associationName: $homeViewModel.assosioationName)
        case .confirmTransferToAssociation:
            ConfirmTransferToAssociationView(activeSheet: $homeViewModel.activeSheet, depositAmount: $homeViewModel.depositAmount, assosioationName: $homeViewModel.assosioationName)
        case .scanSuccess(let receipt):
            if #available(iOS 16.0, *) {
                BarcodeScanSuccessView(receipt: receipt)
                    .presentationDetents([.medium])
            } else {
                BarcodeScanSuccessView(receipt: receipt)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ReceiptRepository())
}
