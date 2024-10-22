import SwiftUI
import AVFoundation
import OSLog

struct BarcodeScannerView: UIViewRepresentable {
    @Binding var scannedCode: String?
    @Binding var shouldStartScanning: Bool

    var frameSize: CGSize
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "BarcodeScanner")

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        context.coordinator.setupCaptureSession(frameSize: frameSize, in: view)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.updateScanningState(shouldStartScanning: shouldStartScanning)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: BarcodeScannerView
        var captureSession: AVCaptureSession?
        var previewLayer: AVCaptureVideoPreviewLayer?
        var metadataOutput: AVCaptureMetadataOutput?

        init(parent: BarcodeScannerView) {
            self.parent = parent
        }

        func setupCaptureSession(frameSize: CGSize, in view: UIView) {
            let captureSession = AVCaptureSession()
            self.captureSession = captureSession

            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                parent.logger.error("Failed to get the camera device")
                return
            }

            guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
                parent.logger.error("Failed to create video input")
                return
            }

            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                parent.logger.error("Cannot add video input to the capture session")
                return
            }

            let metadataOutput = AVCaptureMetadataOutput()
            self.metadataOutput = metadataOutput

            if captureSession.canAddOutput(metadataOutput) {
                captureSession.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [
                    .ean8, .ean13, .pdf417, .qr, .code128, .code39
                ]
            } else {
                parent.logger.error("Cannot add metadata output to the capture session")
                return
            }

            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = CGRect(origin: .zero, size: frameSize)
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
            self.previewLayer = previewLayer

            // Start the capture session
            DispatchQueue.global(qos: .userInitiated).async {
                captureSession.startRunning()
            }
        }

        func updateScanningState(shouldStartScanning: Bool) {
            guard let captureSession = captureSession else { return }

            if shouldStartScanning {
                if !captureSession.isRunning {
                    DispatchQueue.global(qos: .userInitiated).async {
                        captureSession.startRunning()
                    }
                }
                // Re-enable metadata output
                metadataOutput?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            } else {
                // Disable metadata output by setting the delegate to nil
                metadataOutput?.setMetadataObjectsDelegate(nil, queue: nil)
            }
        }

        func metadataOutput(
            _ output: AVCaptureMetadataOutput,
            didOutput metadataObjects: [AVMetadataObject],
            from connection: AVCaptureConnection
        ) {
            guard
                let metadataObject = metadataObjects.first,
                let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                let stringValue = readableObject.stringValue
            else {
                return
            }

            // Vibrate the device to provide feedback
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

            // Update the scanned code and scanning state on the main thread
            DispatchQueue.main.async {
                self.parent.scannedCode = stringValue
                self.parent.shouldStartScanning = false
            }

            // Disable further scanning by setting the delegate to nil
            metadataOutput?.setMetadataObjectsDelegate(nil, queue: nil)
        }
    }
}
