import SwiftUI
import DesignSystem

/// TransferToShoppingView, the barcode view to use when scanning you barcode at the checkout
struct TransferToShoppingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.designSystemFonts) private var dsFonts
    @Environment(\.designSystemColors) private var dsColors
    @Environment(\.designSystemIcons) private var dsIcons
    @Environment(\.designSystemSizing) private var dsSizing
    @Environment(\.designSystemSpacing) private var dsSpacing

    @Binding var depositAmount: Double

    var body: some View {
        VStack {
            Spacer()

            VStack {
                Text("Skann strekkoden ved kassen.")
                    .font(.ds(dsFonts.header2Heading))
                    .foregroundStyle(Color(ds: dsColors.textDefault))

                Image(.barcode)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fill)
                    .foregroundStyle(Color(ds: dsColors.textStrong))
                    .frame(height: dsSizing.size4XL)
            }
            .padding(dsSpacing.spaceMD)
            .background(
                RoundedRectangle(cornerRadius: dsSizing.sizeXS)
                    .fill(Color(ds: dsColors.surfacePrimary))
            )
            .padding(dsSpacing.spaceLG)
            .accessibilityElement(children: .combine)
            .accessibilitySortPriority(1)

            Spacer()
        }
        .background(dsColors.surfaceSubtle1)
        .overlay(alignment: .topTrailing) {
            closeButton()
                .accessibilitySortPriority(0)
        }
    }

    private func closeButton() -> some View {
        Button {
            dismiss()
        } label: {
            Image(ds: dsIcons.actionsClose)
                .resizable()
                .foregroundStyle(dsColors.textActionDefault)
                .frame(width: dsSizing.size2XL, height: dsSizing.size2XL)
        }
        .padding()
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel("Lukk")
    }
}

#Preview {
    TransferToShoppingView(depositAmount: .constant(37.50))
        .environmentObject(ReceiptRepository())
}
