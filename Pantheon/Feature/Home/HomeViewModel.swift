//
//  HomeViewModel.swift
//  Pantheon
//
//  Created by Kjetil Haug Terjesen on 14/02/2025.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var selectedReceipt: DepositReceipt?

    @Published var scannedCode: String?
    @Published var shouldStartScanning: Bool = false
}
