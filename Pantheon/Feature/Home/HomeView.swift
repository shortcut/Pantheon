import SwiftUI

enum SheetType: Hashable {
    case transfer
    case success
}

struct HomeView: View {
    @State private var receipts = mockReceipts
    @State private var selectedReceipt: DepositReceipt?
    @State private var showScanner: Bool = false
    @State private var scannedCode: String?
    @State private var shouldStartScanning: Bool = true
    @State private var showSuccess = false
    @State private var sheetType: SheetType = .transfer
    private let mockReceipt = generateOneMockReceipt()

    var body: some View {
        VStack(spacing: 32) {
            headerView
            List {
                Section("Tidligere pantelapper") {
                    ForEach(receipts) { receipt in
                        cell(for: receipt)
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
                receipts.insert(mockReceipt, at: 0)
                shouldStartScanning = true
                scannedCode = nil
            }
        }, content: {
            BarcodeScanSuccessView(receipt: mockReceipt)
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
    func cell(for item: DepositReceipt) -> some View {
        HStack {
            Image("receipt")
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.secondaryText)

                )

            VStack(alignment: .leading) {
                Text(item.store)
                    .font(.headline)
                    .foregroundStyle(.primaryText)

                Text(item.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Text(item.amount.formatted(.currency(code: "NOK")))
                .font(.subheadline)
                .fontWeight(.semibold)
                .fontDesign(.monospaced)
                .foregroundStyle(.primaryText)
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