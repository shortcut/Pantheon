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

            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
                  let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
                parent.logger.error("Failed to initialize camera input")

                return
            }

            guard captureSession.canAddInput(videoInput) else {
                parent.logger.error("Cannot add video input to capture session")

                return
            }

            captureSession.addInput(videoInput)

            let metadataOutput = AVCaptureMetadataOutput()
            self.metadataOutput = metadataOutput

            guard captureSession.canAddOutput(metadataOutput) else {
                parent.logger.error("Cannot add metadata output to capture session")

                return
            }

            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr, .code128, .code39]

            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = CGRect(origin: .zero, size: frameSize)
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
            self.previewLayer = previewLayer

            startCaptureSession()
        }

        func startCaptureSession() {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession?.startRunning()
            }
        }

        func updateScanningState(shouldStartScanning: Bool) {
            guard let captureSession = captureSession else { return }

            if shouldStartScanning {
                if !captureSession.isRunning {
                    startCaptureSession()
                }
                metadataOutput?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            } else {
                stopCaptureSession()
            }
        }

        func stopCaptureSession() {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession?.stopRunning()
            }
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            guard let readableObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue else { return }

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

            DispatchQueue.main.async {
                self.parent.scannedCode = stringValue
                self.parent.shouldStartScanning = true // Restart scanning after capture
            }
        }
    }
}
