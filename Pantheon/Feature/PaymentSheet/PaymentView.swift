//
//  PaymentView.swift
//  Pantheon
//
//  Created by Kjetil Haug Terjesen on 04/03/2025.
//

import SwiftUI

struct PaymentView: View {
    @Environment(\.designSystemFonts) fileprivate var dsFonts
    @Environment(\.designSystemColors) fileprivate var dsColors
    @Environment(\.designSystemSizing) fileprivate var dsSizing
    @Environment(\.designSystemSpacing) fileprivate var dsSpacing
    @Environment(\.designSystemIllustrations) fileprivate var dsIllustrations

    let receipt: DepositReceipt

    @Binding var depositAmount: Double
    @Binding var activeSheet: SheetType?

    var body: some View {
        VStack(spacing: dsSpacing.spaceXL) {
            Text("Hva vil du gjøre med pengene?")
                .font(.ds(dsFonts.header1Heading))
                .foregroundStyle(dsColors.textDefault)
                .accessibilityAddTraits(.isHeader)

            ScrollView {
                VStack(alignment: .leading) {
                    Button {
                        depositAmount = receipt.amount

                        // This is needed to prevent a bouncing loop on iOS 15
                        DispatchQueue.main.async {
                            activeSheet = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                activeSheet = .transferToAccount
                            }
                        }
                    } label: {
                        HStack(spacing: dsSpacing.spaceMD) {
                            Image("visa")
                            VStack(alignment: .leading, spacing: dsSpacing.spaceXS) {
                                Text("Overfør til konto")
                                    .font(.ds(dsFonts.header2Heading))
                                    .foregroundStyle(dsColors.textDefault)
                                Text("Overfør \(amount: receipt.amount) til din konto")
                                    .font(.ds(dsFonts.caption))
                                    .foregroundStyle(dsColors.textSubtle)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: dsSizing.sizeSM)
                                .foregroundStyle(dsColors.surfacePrimary)
                        )
                        .padding()
                    }

                    Button {
                        depositAmount = receipt.amount

                        // This is needed to prevent a bouncing loop on iOS 15
                        DispatchQueue.main.async {
                            activeSheet = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                activeSheet = .transferToShopping
                            }
                        }
                    } label: {
                        HStack(spacing: dsSpacing.spaceMD) {
                            Image("kasse")
                            VStack(alignment: .leading, spacing: dsSpacing.spaceXS) {
                                Text("Overfør til kasse")
                                    .font(.ds(dsFonts.header2Heading))
                                    .foregroundStyle(dsColors.textDefault)
                                Text("Overfør \(amount: receipt.amount) til din neste handel")
                                    .font(.ds(dsFonts.caption))
                                    .foregroundStyle(dsColors.textSubtle)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: dsSizing.sizeSM)
                                .foregroundStyle(dsColors.surfacePrimary)
                        )
                        .padding()
                    }

                    Button {
                        depositAmount = receipt.amount

                        // This is needed to prevent a bouncing loop on iOS 15
                        DispatchQueue.main.async {
                            activeSheet = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                activeSheet = .transferToAssociation
                            }
                        }
                    } label: {
                        HStack(spacing: dsSpacing.spaceMD) {
                            Image(ds: dsIllustrations.hjerteHender)
                                .resizable()
                                .frame(width: 48, height: 48)

                            VStack(alignment: .leading, spacing: dsSpacing.spaceXS) {
                                Text("Overfør til lag/forening")
                                    .font(.ds(dsFonts.header2Heading))
                                    .foregroundStyle(dsColors.textDefault)
                                Text("Overfør \(amount: receipt.amount) til laget/foreningen")
                                    .font(.ds(dsFonts.caption))
                                    .foregroundStyle(dsColors.textSubtle)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: dsSizing.sizeSM)
                                .foregroundStyle(dsColors.surfacePrimary)
                        )
                        .padding()
                    }
                }

                Spacer()
            }
        }
        .padding(.top, dsSpacing.spaceXL)
        .padding()
        .background(dsColors.surfaceSubtle1)
    }
}

#Preview {
    let receipt = DepositReceipt(id: "1", amount: 37.50, date: Date.generateRandomDateInRange(), store: "REMA 1000 Majorstuen", state: DepositReceipt.State.isNew)

    PaymentView(receipt: receipt, depositAmount: .constant(37.50), activeSheet: .constant(.payment(receipt)))
}
