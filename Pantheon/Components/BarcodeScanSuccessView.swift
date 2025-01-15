import SwiftUI

struct BarcodeScanSuccessView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.designSystemFonts) private var dsFonts
    @Environment(\.designSystemColors) private var dsColors
    @Environment(\.designSystemIllustrations) private var dsIllustrations

    let receipt: DepositReceipt

    var body: some View {
        VStack(spacing: 16) {
            Image(ds: dsIllustrations.barcode)
                .resizable()
                .frame(width: 128, height: 128)
            Text("Pantelapp registrert")
                .font(.ds(dsFonts.header1Heading))
                .foregroundStyle(dsColors.textDefault)

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
            }
            .buttonStyle(.actionButtonPrimary)
            .actionButtonIsExpandingWidth(true)
            .padding()
        }
    }
}
