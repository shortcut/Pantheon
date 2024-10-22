import SwiftUI

struct ScannerView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var scannedCode: String?
    @Binding var shouldStartScanning: Bool

    var body: some View {

            BarcodeScannerView(
                scannedCode: $scannedCode,
                shouldStartScanning: $shouldStartScanning,
                frameSize: .init(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height
                )
            )
            .ignoresSafeArea(.all)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundStyle(.surfaceText)
                    .frame(width: 150, height: 150)
            })

        .onChange(of: scannedCode) {
            if let scannedCode {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    dismiss()
                }
            }
        }
    }
}
