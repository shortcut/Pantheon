import SwiftUI
import DesignSystem

enum SheetType: Identifiable {
    case payment(DepositReceipt)
    case transferToAccount
    case transfertoTrip
    case scanSuccess(DepositReceipt)


    var id: String {
        switch self {
        case .payment:
            return "payment"
        case .transferToAccount:
            return "transferToAccount"
        case .transfertoTrip:
            return "transfertoTrip"
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
    @EnvironmentObject var receiptRepository: ReceiptRepository
    
    @Environment(\.designSystemFonts) fileprivate var dsFonts
    @Environment(\.designSystemColors) fileprivate var dsColors
    @Environment(\.designSystemIcons) fileprivate var dsIcons
    @Environment(\.designSystemSizing) fileprivate var dsSizing
    @Environment(\.designSystemSpacing) fileprivate var dsSpacing

    @State private var selectedReceipt: DepositReceipt?
    @State private var scannedCode: String?
    @State private var shouldStartScanning: Bool = true
    @State private var filteredState: Int = 0

    @State private var activeSheet: SheetType?
    @State private var activeFullScreenCover: FullScreenCoverType?

    var body: some View {
        NavigationView {
            List {
                ForEach(receiptRepository.filteredReceipts) { receipt in
                    Button{
                        selectedReceipt = receipt
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
                ToolbarItem(placement: .status) {
                    SegmentedControl(selection: $filteredState, options: DepositReceipt.State.allCases.map{$0.title})
                }
            })
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        activeFullScreenCover = .scanner
                    } label: {
                        Image(ds: dsIcons.utilityScannerBarCode)
                            .resizable()
                            .frame(width: dsSizing.size2XL, height: dsSizing.size2XL)
                    }
                }
            })
        }
        .defaultStyles()
        .sheet(item: $activeSheet, onDismiss: {
            selectedReceipt = nil
        }) { sheet in
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
                TransferToAccountView()
            case .transfertoTrip:
                TransferToShoppingView()
            case .scanSuccess(let receipt):
                if #available(iOS 16.0, *) {
                    BarcodeScanSuccessView(receipt: receipt)
                        .presentationDetents([.medium])
                } else {
                    BarcodeScanSuccessView(receipt: receipt)
                }
            }
        }
        .fullScreenCover(item: $activeFullScreenCover) { cover in
            switch cover {
            case .scanner:
                ScannerView(
                    scannedCode: $scannedCode,
                    shouldStartScanning: $shouldStartScanning
                )
            }
        }
        .onChange(of: scannedCode) { newValue in
            guard newValue != nil else {
                return
            }
            
            receiptRepository.addRandomReceipt()
            
            guard let newReceipt = receiptRepository.receipts.first else {
                return
            }
            
            activeSheet = .scanSuccess(newReceipt)
            scannedCode = nil
            activeFullScreenCover = nil
        }
        .onChange(of: selectedReceipt) { newValue in
            if let receipt = newValue {
                withAnimation {
                    activeSheet = .payment(receipt)
                }
            }
        }
        .onChange(of: filteredState) { newValue in
            let newState = DepositReceipt.State(rawValue: newValue) ?? .normal
            withAnimation {
                receiptRepository.filter(by: newState)
            }
        }
    }
}

// MARK: - Components
private extension HomeView {

    @ViewBuilder
    func paymentSheet(for receipt: DepositReceipt) -> some View {
        VStack(spacing: dsSpacing.spaceXL) {
            Text("Hva vil du gjøre med pengene?")
                .font(.ds(dsFonts.header1Heading))
                .foregroundStyle(dsColors.textDefault)

            VStack(alignment: .leading) {
                Button {
                    activeSheet = .transferToAccount
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
                    activeSheet = .transfertoTrip
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
            }

            Spacer()
        }
        .padding(.top, dsSpacing.spaceXL)
        .padding()
        .background(dsColors.surfaceSubtle1)
    }
}
