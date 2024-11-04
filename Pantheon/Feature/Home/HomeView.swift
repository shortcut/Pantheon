import SwiftUI

enum SheetType: Hashable {
    case transfer
    case success
}

struct HomeView: View {
    @Environment(ReceiptRepository.self) private var receiptRepository

    @State private var selectedReceipt: DepositReceipt?
    @State private var showScanner: Bool = false
    @State private var scannedCode: String?
    @State private var shouldStartScanning: Bool = true
    @State private var showSuccess = false
    @State private var sheetType: SheetType = .transfer
    var body: some View {
        VStack(spacing: 32) {
            headerView
            List {
                Section("Tidligere pantelapper") {
                    ForEach(receiptRepository.receipts) { receipt in
                        ReceiptCell(receipt: receipt)
                            .onTapGesture {
                                selectedReceipt = receipt
                            }
                            .listRowSeparator(.hidden)
                    }
                }
            }
            .listStyle(.plain)
            Spacer()
        }
        .sheet(item: $selectedReceipt) { receipt in
            paymentSheet(for: receipt)
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showSuccess, onDismiss: {
            withAnimation(.bouncy) {
                shouldStartScanning = true
                scannedCode = nil
            }
        }, content: {
            BarcodeScanSuccessView(receipt: receiptRepository.receipts[0])
                .presentationDetents([.medium])
        })
        .fullScreenCover(isPresented: $showScanner) {
            showSuccess = true
        } content: {
            ScannerView(
                scannedCode: $scannedCode,
                shouldStartScanning: $shouldStartScanning
            )
        }
        .onChange(of: scannedCode) {
            if scannedCode != nil {
                receiptRepository.addRandomReceipt()
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
                        showScanner = true
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

            Spacer()
        }
        .padding(.top, 32)
        .padding()
    }
}

#Preview {
    HomeView()
}
