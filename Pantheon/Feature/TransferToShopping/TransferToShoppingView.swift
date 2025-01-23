import SwiftUI

struct TransferToShoppingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.designSystemFonts) private var dsFonts
    @Environment(\.designSystemColors) private var dsColors
    @Environment(\.designSystemIcons) private var dsIcons
    @Environment(\.designSystemSizing) private var dsSizing
    @Environment(\.designSystemSpacing) private var dsSpacing

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

            Spacer()
        }
        .background(dsColors.surfaceSubtle1)
        .safeAreaInset(edge: .bottom) {
            Button {
                dismiss()
            } label: {
                Text("Ferdig")
            }
            .buttonStyle(.actionButtonPrimary)
            .actionButtonIsExpandingWidth(true)
            .padding(dsSpacing.spaceLG)
        }
        .overlay(alignment: .topTrailing) {
            closeButton()
        }
    }

    private func closeButton() -> some View {
        Button {
            dismiss()
        } label: {
            Image(ds: dsIcons.actionsClose)
                .resizable()
                .foregroundStyle(dsColors.textDefault)
                .frame(width: dsSizing.size2XL, height: dsSizing.size2XL)
        }
        .padding()
    }
}

#Preview {
    TransferToShoppingView()
}
