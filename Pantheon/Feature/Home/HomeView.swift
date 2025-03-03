import SwiftUI
import DesignSystem

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

enum FullScreenCoverType: Identifiable {
    case scanner

    var id: String {
        switch self {
        case .scanner:
            return "scanner"
        }
    }
}

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
    @ViewBuilder
    func selectedReceiptSheetContent(_ sheet: SheetType) -> some View {
        switch sheet {
        case .payment(let receipt):
            if #available(iOS 16.0, *) {
                paymentSheet(for: receipt)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            } else {
                paymentSheet(for: receipt)
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

    @ViewBuilder
    func paymentSheet(for receipt: DepositReceipt) -> some View {
        VStack(spacing: dsSpacing.spaceXL) {
            Text("Hva vil du gjøre med pengene?")
                .font(.ds(dsFonts.header1Heading))
                .foregroundStyle(dsColors.textDefault)
                .accessibilityAddTraits(.isHeader)

            ScrollView {
                VStack(alignment: .leading) {
                    Button {
                        print("amount: \(receipt.amount)")
                        print("depositAmount: \(homeViewModel.depositAmount)")
                        homeViewModel.depositAmount = receipt.amount
                        print("depositAmount2: \(homeViewModel.depositAmount)")
                        // This is needed to prevent a bouncing loop on iOS 15
                        DispatchQueue.main.async {
                            homeViewModel.activeSheet = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                homeViewModel.activeSheet = .transferToAccount
                            }
                        }
                    } label: {
                        HStack(spacing: dsSpacing.spaceMD) {
                            Image("visa")
                            VStack(alignment: .leading, spacing: dsSpacing.spaceXS) {
                                Text("Overfør til konto")
                                    .font(.ds(dsFonts.header2Heading))
                                    .foregroundStyle(dsColors.textDefault)
                                Text("Overfør \(amount: receipt.amount) til din konto")
                                    .font(.ds(dsFonts.caption))
                                    .foregroundStyle(dsColors.textSubtle)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: dsSizing.sizeSM)
                                .foregroundStyle(dsColors.surfacePrimary)
                        )
                        .padding()
                    }

                    Button {
                        print("amount: \(receipt.amount)")
                        print("depositAmount: \(homeViewModel.depositAmount)")
                        homeViewModel.depositAmount = receipt.amount
                        print("depositAmount2: \(homeViewModel.depositAmount)")
                        // This is needed to prevent a bouncing loop on iOS 15
                        DispatchQueue.main.async {
                            homeViewModel.activeSheet = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                homeViewModel.activeSheet = .transferToShopping
                            }
                        }
                    } label: {
                        HStack(spacing: dsSpacing.spaceMD) {
                            Image("kasse")
                            VStack(alignment: .leading, spacing: dsSpacing.spaceXS) {
                                Text("Overfør til kasse")
                                    .font(.ds(dsFonts.header2Heading))
                                    .foregroundStyle(dsColors.textDefault)
                                Text("Overfør \(amount: receipt.amount) til din neste handel")
                                    .font(.ds(dsFonts.caption))
                                    .foregroundStyle(dsColors.textSubtle)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: dsSizing.sizeSM)
                                .foregroundStyle(dsColors.surfacePrimary)
                        )
                        .padding()
                    }

                    Button {
                        print("amount: \(receipt.amount)")
                        print("depositAmount: \(homeViewModel.depositAmount)")
                        homeViewModel.depositAmount = receipt.amount
                        print("depositAmount2: \(homeViewModel.depositAmount)")
                        // This is needed to prevent a bouncing loop on iOS 15
                        DispatchQueue.main.async {
                            homeViewModel.activeSheet = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                homeViewModel.activeSheet = .transferToAssociation
                            }
                        }
                    } label: {
                        HStack(spacing: dsSpacing.spaceMD) {
                            Image(ds: dsIllustrations.hjerteHender)
                                .resizable()
                                .frame(width: 48, height: 48)

                            VStack(alignment: .leading, spacing: dsSpacing.spaceXS) {
                                Text("Overfør til lag/forening")
                                    .font(.ds(dsFonts.header2Heading))
                                    .foregroundStyle(dsColors.textDefault)
                                Text("Overfør \(amount: receipt.amount) til laget/foreningen")
                                    .font(.ds(dsFonts.caption))
                                    .foregroundStyle(dsColors.textSubtle)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: dsSizing.sizeSM)
                                .foregroundStyle(dsColors.surfacePrimary)
                        )
                        .padding()
                    }
                }

                Spacer()
            }
        }
        .padding(.top, dsSpacing.spaceXL)
        .padding()
        .background(dsColors.surfaceSubtle1)
    }
}

#Preview {
    HomeView()
        .environmentObject(ReceiptRepository())
}
