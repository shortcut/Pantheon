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
            BarcodeScannerView(
                scannedCode: $scannedCode,
                shouldStartScanning: $shouldStartScanning,
                frameSize: .init(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height
                )
            )
            .ignoresSafeArea(.all)
            // Black overlay with transparency
            Color.black.opacity(0.3)
                .ignoresSafeArea(.all)
                .mask(
                    RoundedRectangleMask()
                )
            
            CornerStrokeOverlay()
        }
        .ignoresSafeArea(.all)
        .onChange(of: scannedCode) { newValue in
            guard newValue != nil else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                dismiss()
            }
        }
        .overlay(alignment: .topTrailing) {
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
}

struct RoundedRectangleMask: View {
    var body: some View {
        ZStack {
            // Full screen black background
            Color.black
            
            // Rounded rectangle cutout
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 200, height: 200)
                .blendMode(.destinationOut) // This makes the rectangle transparent
        }
        .compositingGroup() // Required for the blendMode to work properly
    }
}

// MARK: - Custom Corner Stroke Overlay
struct CornerStrokeOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            let rectWidth: CGFloat = 232
            let rectHeight: CGFloat = 232
            let cornerRadius: CGFloat = 20
            let strokeWidth: CGFloat = 3
            
            ZStack {
                let strokeColor = Color.white
                
                // Top Left Corner
                Path { path in
                    path.addArc(center: CGPoint(x: (geometry.size.width - rectWidth) / 2 + cornerRadius,
                                                y: (geometry.size.height - rectHeight) / 2 + cornerRadius),
                                radius: cornerRadius,
                                startAngle: .degrees(180),
                                endAngle: .degrees(270),
                                clockwise: false)
                }
                .stroke(strokeColor, lineWidth: strokeWidth)
                
                // Top Right Corner
                Path { path in
                    path.addArc(center: CGPoint(x: (geometry.size.width + rectWidth) / 2 - cornerRadius,
                                                y: (geometry.size.height - rectHeight) / 2 + cornerRadius),
                                radius: cornerRadius,
                                startAngle: .degrees(270),
                                endAngle: .degrees(360),
                                clockwise: false)
                }
                .stroke(strokeColor, lineWidth: strokeWidth)
                
                // Bottom Left Corner
                Path { path in
                    path.addArc(center: CGPoint(x: (geometry.size.width - rectWidth) / 2 + cornerRadius,
                                                y: (geometry.size.height + rectHeight) / 2 - cornerRadius),
                                radius: cornerRadius,
                                startAngle: .degrees(90),
                                endAngle: .degrees(180),
                                clockwise: false)
                }
                .stroke(strokeColor, lineWidth: strokeWidth)
                
                // Bottom Right Corner
                Path { path in
                    path.addArc(center: CGPoint(x: (geometry.size.width + rectWidth) / 2 - cornerRadius,
                                                y: (geometry.size.height + rectHeight) / 2 - cornerRadius),
                                radius: cornerRadius,
                                startAngle: .degrees(0),
                                endAngle: .degrees(90),
                                clockwise: false)
                }
                .stroke(strokeColor, lineWidth: strokeWidth)
            }
        }
    }
}
