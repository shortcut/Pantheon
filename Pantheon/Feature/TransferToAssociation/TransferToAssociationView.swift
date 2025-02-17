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

    let associations: [String: [String]] = [
        "Frivillige organisasjoner": ["Røde kors", "Plan"],
        "Organisasjoner": ["Blindeforbundet", "Handicapforbundet"],
        "Idrettslag": ["Oslo Golfklubb", "Asker hockey"]
    ]

    init() {
        if #available(iOS 16, *) {
            // Handle it where the background is set
        } else {
            // Removes background color for prior iOS 15
            UITableView.appearance().backgroundColor = UIColor.clear
        }
    }

    var body: some View {
        VStack {
            Text("Velg lag eller forening")
                .padding(.vertical)
                .font(.ds(dsFonts.header2Heading))
                .foregroundStyle(dsColors.textDefault)

            platformAdaptiveView()  
        }
        .background(dsColors.surfaceDefaultMain)
        .edgesIgnoringSafeArea(.all)
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
    TransferToAssociationView()
}
