
import SwiftUI
import DesignSystem

struct TransferToAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.designSystemFonts) private var dsFonts
    @Environment(\.designSystemColors) private var dsColors
    @Environment(\.designSystemIcons) private var dsIcons
    @Environment(\.designSystemSizing) private var dsSizing
    @Environment(\.designSystemSpacing) private var dsSpacing

    @EnvironmentObject var repository: ReceiptRepository

    var body: some View {
        let receipt = repository.receipts[0]

        NavigationView{
            VStack(spacing: dsSpacing.spaceMD) {
                VStack(alignment: .leading, spacing: dsSpacing.spaceXS) {
                    Text("Til overføring")
                        .font(.ds(dsFonts.bodySmall))
                        .foregroundStyle(Color(ds: dsColors.textSubtle))

                    Text("\(amount: receipt.amount)")
                        .font(.ds(dsFonts.header1DisplayLarge))
                        .foregroundStyle(Color(ds: dsColors.textStrong))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(dsSpacing.spaceLG)
                .background {
                    RoundedRectangle(cornerRadius: dsSizing.sizeMD, style: .continuous)
                        .fill(Color(ds: dsColors.surfaceDefaultMain))
                        .background(
                            RoundedRectangle(cornerRadius: dsSizing.sizeMD, style: .continuous)
                                .stroke(Color(ds: dsColors.borderDividerDefault))
                        )
                        .shadow(color: Color(ds: dsColors.borderDividerDefault).opacity(0.4), radius: 10)
                }
                .padding(.top, dsSpacing.spaceXL)
                .accessibilityElement(children: .combine)

                HStack(spacing: dsSpacing.spaceMD) {
                    Image(.sbanken)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: dsSizing.sizeXL, height: dsSizing.sizeXL)

                    VStack(alignment: .leading, spacing: dsSpacing.space2XS) {
                        Text("Sbanken ASA")
                            .font(.ds(dsFonts.bodySmall))
                            .foregroundStyle(Color(ds: dsColors.textActionDefault))

                        Text("Kort som ender med 1234")
                            .font(.ds(dsFonts.caption))
                            .foregroundStyle(Color(ds: dsColors.textSubtle))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button {
                        // Action to change account
                    } label: {
                        Text("Endre")
                            .font(.ds(dsFonts.buttonSmall))
                            .foregroundStyle(Color(ds: dsColors.textActionDefault))
                    }
                }
                .padding(dsSpacing.spaceLG)
                .background {
                    RoundedRectangle(cornerRadius: dsSizing.sizeMD, style: .continuous)
                        .fill(Color(ds: dsColors.surfaceDefaultMain))
                        .background(
                            RoundedRectangle(cornerRadius: dsSizing.sizeMD, style: .continuous)
                                .stroke(Color(ds: dsColors.borderDividerDefault))
                        )
                        .shadow(color: Color(ds: dsColors.borderDividerDefault).opacity(0.4), radius: 10)
                }
                .accessibilityElement(children: .combine) // Need to fix the button click when action on button is added

                Spacer()
            }
            .padding(.horizontal, dsSpacing.spaceLG)
            .safeAreaInset(edge: .bottom) {
                Button {
                    dismiss()
                } label: {
                    Text("Bekreft")
                }
                .buttonStyle(.actionButtonPrimary)
                .actionButtonIsExpandingWidth(true)
                .padding(dsSpacing.spaceLG)
            }
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text(receipt.store)
                        .font(.ds(dsFonts.header2Heading))
                        .foregroundStyle(Color(ds: dsColors.textActionDefault))
                        .padding(.top, dsSpacing.spaceLG)
                }
            })
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Avbryt") {
                        dismiss()
                    }
                    .foregroundStyle(Color(ds: dsColors.textActionDefault))
                    .padding(.top, dsSpacing.spaceLG)
                }
            })
        }
    }
}


#Preview {
    TransferToAccountView()
        .environmentObject(ReceiptRepository())
}
