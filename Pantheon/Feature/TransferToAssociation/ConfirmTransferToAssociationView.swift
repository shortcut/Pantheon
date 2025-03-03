//
//  ConfirmTranferToAssociationView.swift
//  Pantheon
//
//  Created by Kjetil Haug Terjesen on 20/02/2025.
//

import SwiftUI

/// ConfirmTransferToAssociationView is the confirm view when tranfer the money to association/organisations
struct ConfirmTransferToAssociationView: View {
    @Environment(\.designSystemFonts) private var dsFonts
    @Environment(\.designSystemColors) private var dsColors
    @Environment(\.designSystemIcons) private var dsIcons
    @Environment(\.designSystemSizing) private var dsSizing
    @Environment(\.designSystemSpacing) private var dsSpacing

    @EnvironmentObject var repository: ReceiptRepository

    @Binding var activeSheet: SheetType?
    @Binding var depositAmount: Double
    @Binding var assosioationName: String

    var body: some View {
        let receipt = repository.receipts[0]

        NavigationView{
            VStack(spacing: dsSpacing.spaceMD) {
                VStack(alignment: .leading, spacing: dsSpacing.spaceXS) {
                    Text("Til overføring")
                        .font(.ds(dsFonts.bodySmall))
                        .foregroundStyle(Color(ds: dsColors.textSubtle))

                    Text("\(amount: depositAmount)")
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

                HStack(spacing: dsSpacing.spaceMD) {
                    Image(assosioationName.description.lowercased())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: dsSizing.sizeXL, height: dsSizing.sizeXL)

                    VStack(alignment: .leading, spacing: dsSpacing.space2XS) {
                        HStack {
                            Text(assosioationName)
                                .font(.ds(dsFonts.buttonLarge))
                                .foregroundStyle(Color(ds: dsColors.textActionDefault))

                            Spacer()
                        }
                    }

                    Button {
                        // Action to change association
                        DispatchQueue.main.async {
                            activeSheet = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                activeSheet = .transferToAssociation
                            }
                        }
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

                Spacer()
            }
            .padding(.horizontal, dsSpacing.spaceLG)
            .safeAreaInset(edge: .bottom) {
                Button {
                    activeSheet = nil
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
                        DispatchQueue.main.async {
                            activeSheet = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                activeSheet = .transferToAssociation
                            }
                        }
                    }
                    .foregroundStyle(Color(ds: dsColors.textActionDefault))
                    .padding(.top, dsSpacing.spaceLG)
                }
            })
        }
    }
}

#Preview {
    ConfirmTransferToAssociationView(activeSheet: .constant(.confirmTransferToAssociation), depositAmount: .constant(37.50), assosioationName: .constant("Plan"))
        .environmentObject(ReceiptRepository())
}
