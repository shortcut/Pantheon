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
            
            overlayMask()
            
            CornerStrokeOverlay(
                strokeColor: Color(ds:dsColors.surfaceSubtle2)
            )
        }
        .ignoresSafeArea(.all)
        .onChange(of: scannedCode) { newValue in
            guard newValue != nil else { return }
            
            dismiss()
        }
        .overlay(alignment: .topTrailing) { closeButton() }
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
    
    private func overlayMask() -> some View {
        Color(ds: dsColors.surfaceStrongStatic)
            .opacity(0.3)
            .ignoresSafeArea(.all)
            .mask(RoundedRectangleMask())
    }
    
    private func closeButton() -> some View {
        Button {
            dismiss()
        } label: {
            Image(ds: dsIcons.actionsClose)
                .resizable()
                .foregroundStyle(dsColors.iconInvertedDefault)
                .frame(width: dsSizing.size2XL, height: dsSizing.size2XL)
        }
        .padding()
    }
}

struct RoundedRectangleMask: View {
    @Environment(\.designSystemSizing) fileprivate var dsSizing
    
    var body: some View {
        ZStack {
            Color.black
            
            RoundedRectangle(cornerRadius: dsSizing.sizeMD)
                .frame(width: 200, height: 200)
                .blendMode(.destinationOut)
        }
        .compositingGroup()
    }
}

// MARK: - Custom Corner Stroke Overlay
struct CornerStrokeOverlay: View {
    @Environment(\.designSystemSizing) fileprivate var dsSizing
    
    private let rectWidth: CGFloat = 232
    private let rectHeight: CGFloat = 232
    private let strokeWidth: CGFloat = DesignSystem.default.sizing.size2XS

    let strokeColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                drawCornerPath(in: geometry, startAngle: 180, endAngle: 270, xOffset: -1, yOffset: -1)
                drawCornerPath(in: geometry, startAngle: 270, endAngle: 360, xOffset: 1, yOffset: -1)
                drawCornerPath(in: geometry, startAngle: 90, endAngle: 180, xOffset: -1, yOffset: 1)
                drawCornerPath(in: geometry, startAngle: 0, endAngle: 90, xOffset: 1, yOffset: 1)
            }
        }
    }
    
    private func drawCornerPath(in geometry: GeometryProxy, startAngle: Double, endAngle: Double, xOffset: CGFloat, yOffset: CGFloat) -> some View {
        Path { path in
            let centerX = (geometry.size.width + rectWidth * xOffset) / 2 - dsSizing.sizeMD * xOffset
            let centerY = (geometry.size.height + rectHeight * yOffset) / 2 - dsSizing.sizeMD * yOffset
            
            path.addArc(
                center: CGPoint(x: centerX, y: centerY),
                radius: dsSizing.sizeMD,
                startAngle: .degrees(startAngle),
                endAngle: .degrees(endAngle),
                clockwise: false
            )
        }
        .stroke(strokeColor, lineWidth: strokeWidth)
    }
}
