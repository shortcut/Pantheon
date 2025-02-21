//
//  SwiftUIView.swift
//  Pantheon
//
//  Created by Kjetil Haug Terjesen on 13/02/2025.
//

import SwiftUI
import DesignSystem

struct TransferToAssociationView: View {
    @Environment(\.designSystemFonts) fileprivate var dsFonts
    @Environment(\.designSystemColors) fileprivate var dsColors
    @Environment(\.designSystemSpacing) private var dsSpacing

    @Binding var activeSheet: SheetType?

    let associations: [String: [String]] = [
        "Frivillige organisasjoner": ["Røde kors", "Plan"],
        "Organisasjoner": ["Blindeforbundet", "Handicapforbundet"],
        "Idrettslag": ["Oslo Golfklubb", "Asker hockey"]
    ]

    var body: some View {
        NavigationView {
            VStack {
                platformAdaptiveView()  
            }
            .background(dsColors.surfaceDefaultMain)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("Velg lag eller forening")
                        .font(.ds(dsFonts.header2Heading))
                        .foregroundStyle(Color(ds: dsColors.textActionDefault))
                        .padding(.top, dsSpacing.spaceLG)
                }
            })
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Avbryt") {
                        activeSheet = nil
                    }
                    .foregroundStyle(Color(ds: dsColors.textActionDefault))
                    .padding(.top, dsSpacing.spaceLG)
                }
            })
        }
        .onAppear {
            if #available(iOS 16, *) {
                // Handle it where the background is set
            } else {
                // Removes background color for prior iOS 15
                UITableView.appearance().backgroundColor = UIColor.clear
            }
        }
    }
}

// MARK: - Components
private extension TransferToAssociationView {
    @ViewBuilder
    func platformAdaptiveView() -> some View {
        if #available(iOS 16, *) {
            List {
                ForEach(associations.keys.sorted(), id: \.self) { category in
                    Section {
                        ForEach(associations[category] ?? ["Fant ikke lag"], id: \.self) { item in
                            Button {
                                DispatchQueue.main.async {
                                    activeSheet = nil
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        activeSheet = .confirmTransferToAssociation
                                    }
                                }
                            } label: {
                                Text(item)
                                    .font(.ds(dsFonts.header2Heading))
                                    .foregroundStyle(dsColors.textDefault)
                            }
                        }
                    } header: {
                        Text(category)
                            .font(.ds(dsFonts.header2Heading))
                            .foregroundStyle(dsColors.textDefault)
                    }
                    .textCase(nil)
                }
            }
            .scrollContentBackground(.hidden)
            .background(dsColors.surfaceDefaultMain)
        } else {
            List {
                ForEach(associations.keys.sorted(), id: \.self) { category in
                    Section {
                        ForEach(associations[category] ?? ["Fant ikke lag"], id: \.self) { item in
                            Button {
                                DispatchQueue.main.async {
                                    activeSheet = nil
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        activeSheet = .confirmTransferToAssociation
                                    }
                                }
                            } label: {
                                Text(item)
                                    .font(.ds(dsFonts.header2Heading))
                                    .foregroundStyle(dsColors.textDefault)
                            }
                        }
                    } header: {
                        Text(category)
                            .font(.ds(dsFonts.header2Heading))
                            .foregroundStyle(dsColors.textDefault)
                    }
                    .textCase(nil)
                }
            }
            .background(dsColors.surfaceDefaultMain)
        }
    }
}

#Preview {
    TransferToAssociationView(activeSheet: .constant(.transferToAssociation))
        .environmentObject(ReceiptRepository())
}
