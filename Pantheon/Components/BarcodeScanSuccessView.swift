import SwiftUI
import DesignSystem

/// BarcodeScanSuccessView, summarizes the values of scanning
struct BarcodeScanSuccessView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.designSystemFonts) private var dsFonts
    @Environment(\.designSystemColors) private var dsColors
    @Environment(\.designSystemIllustrations) private var dsIllustrations
    @Environment(\.designSystemSpacing) private var dsSpacing

    @EnvironmentObject fileprivate var receiptRepository: ReceiptRepository

    let receipt: DepositReceipt

    var body: some View {
        VStack(spacing: dsSpacing.spaceMD) {
            Image(ds: dsIllustrations.barcode)
                .resizable()
                .frame(width: 128, height: 128)
                .padding(.top, dsSpacing.spaceXL)

            Text("Pantelapp registrert")
                .font(.ds(dsFonts.header1Heading))
                .foregroundStyle(Color(ds: dsColors.textDefault))

            VStack(spacing: dsSpacing.spaceXS) {
                Text("Du har scannet en pantelapp på verdi:")
                    .font(.ds(dsFonts.bodySmall))
                    .foregroundStyle(Color(ds: dsColors.textSubtle))

                Text("\(amount: receipt.amount)")
                    .font(.ds(dsFonts.bodyMedium))
                    .fontWeight(.bold)
                    .foregroundStyle(Color(ds: dsColors.textStrong))

                Text("hos")
                    .font(.ds(dsFonts.bodySmall))
                    .foregroundStyle(Color(ds: dsColors.textSubtle))

                Text(receipt.store.uppercased())
                    .font(.ds(dsFonts.bodyMedium))
                    .fontWeight(.bold)
                    .foregroundStyle(Color(ds: dsColors.textStrong))
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, dsSpacing.spaceLG)

            Button {
                dismiss()
            } label: {
                Text("OK".uppercased())
            }
            .buttonStyle(.actionButtonPrimary)
            .actionButtonIsExpandingWidth(true)
            .padding(.top, dsSpacing.spaceLG)
            .padding(.bottom, dsSpacing.spaceXL)
        }
        .padding(.horizontal, dsSpacing.spaceLG)
    }
}
