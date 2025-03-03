//
//  HomeViewModel.swift
//  Pantheon
//
//  Created by Kjetil Haug Terjesen on 14/02/2025.
//

import Foundation

/// HomeViewModel for homeView. Holds also acticeSheet,
/// depositAmount and assosioatoinName that is sent to some other views and viewModel. Might consider to extract them to a more globel class later
class HomeViewModel: ObservableObject {
    @Published var selectedReceipt: DepositReceipt?

    @Published var scannedCode: String?
    @Published var shouldStartScanning: Bool = false

    @Published var filteredState: Int = 0

    @Published var activeSheet: SheetType?
    @Published var activeFullScreenCover: FullScreenCoverType?

    @Published var depositAmount: Double = 0.0

    @Published var assosioationName: String = ""
}
