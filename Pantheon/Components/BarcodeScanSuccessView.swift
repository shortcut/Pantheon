import SwiftUI

struct BarcodeScanSuccessView: View {
    @Environment(\.dismiss) var dismiss

    let receipt: DepositReceipt

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.green)
            Text("Pantelapp registrert")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primaryText)

            VStack {
                Group {
                    Text("Du har scannet en pantelapp på verdi:")
                    Text(" \(receipt.amount.formatted(.currency(code: "NOK")))")
                        .fontWeight(.bold)
                    Text("hos")
                    Text(" \(receipt.store.uppercased())")
                        .fontWeight(.bold)
                }
                .foregroundStyle(.secondaryText)
            }

            Button {
                dismiss()
            } label: {
                Text("OK".uppercased())
                    .font(.headline).bold()
                    .foregroundStyle(.surfaceText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(.primaryBackground)
                    .cornerRadius(8)
                    .padding()

            }
            .padding(.top)
        }
    }
}

#Preview {
    BarcodeScanSuccessView(receipt: generateOneMockReceipt())
}
