import SwiftUI
import DesignSystem

struct ScannerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.designSystemIcons) fileprivate var dsIcons
    @Environment(\.designSystemColors) fileprivate var dsColors
    @Environment(\.designSystemSizing) fileprivate var dsSizing
    @Environment(\.designSystemSpacing) fileprivate var dsSpacing

    @Binding var scannedCode: String?
    @Binding var shouldStartScanning: Bool

    var body: some View {
        ZStack {
            barcodeScannerView()
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Skanner område")
                .accessibilityHint("Pek kameraet mot pantemaskinens QR kode.")
                .accessibilitySortPriority(2)

            VStack {
                Text("Skann pantemaskinkode".uppercased())
                    .padding(.top, 60)
                    .font(.headline.bold())
                    .foregroundStyle(dsColors.surfaceActive)
                    .accessibilityLabel("Skann pantemaskinkode.")
                    .accessibilityAddTraits(.isHeader)
                    .accessibilitySortPriority(3)

                RoundedRectangleStroke()

                closeButton()
                    .accessibilitySortPriority(1)
            }
        }
        .ignoresSafeArea(.all)
        .onChange(of: scannedCode) { newValue in
            guard newValue != nil else { return }

            dismiss()
        }
    }

    private func barcodeScannerView() -> some View {
        BarcodeScannerView(
            scannedCode: $scannedCode,
            shouldStartScanning: $shouldStartScanning,
            frameSize: .init(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height
            )
        )
        .ignoresSafeArea(.all)
    }
    
    private func closeButton() -> some View {
        Button {
            dismiss()
        } label: {
            Text("Avbryt")
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(dsColors.surfaceActionDefault)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .foregroundStyle(dsColors.textInvertedDefault)
        .padding(.horizontal, 24)
        .padding(.bottom, 30)
    }
}

// MARK: - Rounded Rectangle Stroke
// Use this so the design matches the QR scanner for selecting store
struct RoundedRectangleStroke: View {
    @Environment(\.designSystemColors) fileprivate var dsColors

    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(ds: dsColors.surfaceActionDefault), lineWidth: 3)
                .frame(
                    width: geometry.size.width - 20,
                    height: geometry.size.height / 2
                )
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

// I'll keeep this code in case the design will change to something like this:
// MARK: - For the View
//            overlayMask() // It's not used in the qr scanner for select store
//                    CornerStrokeOverlay( // Should this be used so it is similar to the scanner in scann and pay or use the rectangle as in scann qr code to select store?
//                        strokeColor: Color(ds:dsColors.surfaceSubtle2)
//                    )
//            .overlay(alignment: .topTrailing) { closeButton() } // This is set on the .onChange on the zstack

// Should this be used so it is similar to the scanner in scann and pay or use the rectangle as in scann qr code to select store?
//    private func overlayMask() -> some View {
//        Color(ds: dsColors.surfaceStrongStatic)
//            .opacity(0.3)
//            .ignoresSafeArea(.all)
//            .mask(RoundedRectangleMask())
//    }

// Changed this so it matches the design in select store qr scanner view
//    private func closeButton() -> some View {
//        Button {
//            dismiss()
//        } label: {
//            Image(ds: dsIcons.actionsClose)
//                .resizable()
//                .foregroundStyle(dsColors.textInvertedDefault)
//                .frame(width: dsSizing.size2XL, height: dsSizing.size2XL)
//        }
//        .padding()
//    }

// MARK: - The mask
// This is not used in the Scan store scanner in the R app, but in the scan products
//struct RoundedRectangleMask: View {
//    @Environment(\.designSystemSizing) fileprivate var dsSizing
//
//    var body: some View {
//        ZStack {
//            Color.black
//
//            RoundedRectangle(cornerRadius: dsSizing.sizeMD)
//                .frame(width: 200, height: 200)
//                .blendMode(.destinationOut)
//        }
//        .compositingGroup()
//    }
//}

// MARK: - Custom Corner Stroke Overlay
// // Should this be used so it is similar to the scanner in scann and pay or use the rectangle as in scann qr code to select store?
//struct CornerStrokeOverlay: View {
//    @Environment(\.designSystemSizing) fileprivate var dsSizing
//
//    private let rectWidth: CGFloat = 232
//    private let rectHeight: CGFloat = 232
//    private let strokeWidth: CGFloat = DesignSystem.default.sizing.size2XS
//
//    let strokeColor: Color
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                drawCornerPath(in: geometry, startAngle: 180, endAngle: 270, xOffset: -1, yOffset: -1)
//                drawCornerPath(in: geometry, startAngle: 270, endAngle: 360, xOffset: 1, yOffset: -1)
//                drawCornerPath(in: geometry, startAngle: 90, endAngle: 180, xOffset: -1, yOffset: 1)
//                drawCornerPath(in: geometry, startAngle: 0, endAngle: 90, xOffset: 1, yOffset: 1)
//            }
//        }
//    }

// Should this be used so it is similar to the scanner in scann and pay or use the rectangle as in scann qr code to select store?
//    private func drawCornerPath(in geometry: GeometryProxy, startAngle: Double, endAngle: Double, xOffset: CGFloat, yOffset: CGFloat) -> some View {
//        Path { path in
//            let centerX = (geometry.size.width + rectWidth * xOffset) / 2 - dsSizing.sizeMD * xOffset
//            let centerY = (geometry.size.height + rectHeight * yOffset) / 2 - dsSizing.sizeMD * yOffset
//
//            path.addArc(
//                center: CGPoint(x: centerX, y: centerY),
//                radius: dsSizing.sizeMD,
//                startAngle: .degrees(startAngle),
//                endAngle: .degrees(endAngle),
//                clockwise: false
//            )
//        }
//        .stroke(strokeColor, lineWidth: strokeWidth)
//    }
//}
