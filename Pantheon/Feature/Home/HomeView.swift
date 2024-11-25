import SwiftUI

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
    @Environment(ReceiptRepository.self) private var receiptRepository

    @State private var selectedReceipt: DepositReceipt?
    @State private var scannedCode: String?
    @State private var shouldStartScanning: Bool = true
    @State private var filteredState: DepositReceipt.State = .normal

    @State private var activeSheet: SheetType?
    @State private var activeFullScreenCover: FullScreenCoverType?

    var body: some View {
        VStack(spacing: 32) {
            headerView
            List {
                Section {
                    ForEach(receiptRepository.filteredReceipts) { receipt in
                        ReceiptCell(receipt: receipt)
                            .onTapGesture {
                                selectedReceipt = receipt
                            }
                            .listRowSeparator(.hidden)
                    }
                } header: {
                    Picker(selection: $filteredState) {
                        ForEach(DepositReceipt.State.allCases) { state in
                            Text(state.rawValue)
                                .foregroundStyle(filteredState == state ? .surfaceText : .textBlue)
                                .backgroundStyle(filteredState == state ? .primaryBackground :  .surfaceText)
                                .tag(state)
                        }
                    } label: {
                        Text("Filtrer etter status")
                    }
                    .pickerStyle(.segmented)

                }

            }
            .listStyle(.plain)
            Spacer()
        }
        .sheet(item: $activeSheet, onDismiss: {
            selectedReceipt = nil
        }) { sheet in
            switch sheet {
            case .payment(let receipt):
                paymentSheet(for: receipt)
                    .presentationDetents([.medium])
            case .transferToAccount:
                TransferToAccountView()
            case .transfertoTrip:
                TransferToShoppingView()
            case .scanSuccess(let receipt):
                BarcodeScanSuccessView(receipt: receipt)
                    .presentationDetents([.medium])
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
        .onChange(of: scannedCode) { _ in
            if let code = scannedCode {
                receiptRepository.addRandomReceipt()
                if let newReceipt = receiptRepository.receipts.first {
                    activeSheet = .scanSuccess(newReceipt)
                }
                scannedCode = nil
                activeFullScreenCover = nil
            }
        }
        .onChange(of: selectedReceipt) { receipt in
            if let receipt = receipt {
                withAnimation {
                    activeSheet = .payment(receipt)
                }
            }
        }
        .onChange(of: filteredState) { newState in
            withAnimation {
                receiptRepository.filter(by: newState)
            }
        }
    }
}

// MARK: - Components
private extension HomeView {
    @ViewBuilder
    var headerView: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text("Pantelapper")
                        .font(.title)
                        .foregroundStyle(.surfaceText)
                    Spacer()

                    Button {
                        activeFullScreenCover = .scanner
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32)
                    }
                    .foregroundStyle(.surfaceText)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(.primaryBackground)
        }
    }

    @ViewBuilder
    func paymentSheet(for receipt: DepositReceipt) -> some View {
        VStack(spacing: 32) {
            Text("Hva vil du gjøre med pengene?")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primaryText)

            VStack(alignment: .leading) {
                Button {
                    activeSheet = .transferToAccount
                } label: {
                    HStack(spacing: 16) {
                        Image("visa")
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Overfør til konto")
                                .font(.headline)
                                .foregroundStyle(.primaryText)
                            Text("Overfør \(receipt.amount.formatted(.currency(code: "NOK"))) til din konto")
                                .font(.caption)
                                .foregroundStyle(.secondaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.white)
                            .shadow(color: .shoppingListCellShadow,
                                    radius: 8, x: 2, y: 2)
                    )
                    .padding()
                }

                Button {
                    activeSheet = .transfertoTrip
                } label: {
                    HStack(spacing: 16) {
                        Image("kasse")
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Overfør til kasse")
                                .font(.headline)
                                .foregroundStyle(.primaryText)
                            Text("Overfør \(receipt.amount.formatted(.currency(code: "NOK"))) til din neste handel")
                                .font(.caption)
                                .foregroundStyle(.secondaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.white)
                            .shadow(color: .shoppingListCellShadow,
                                    radius: 8, x: 2, y: 2)
                    )
                    .padding()
                }
            }

            Spacer()
        }
        .padding(.top, 32)
        .padding()
    }
}
