//
//  PreviewBindings.swift
//
//
//  Created by 史 翔新 on 2021/03/19.
//

#if os(iOS)

import SwiftUI
import Combine
import AVFoundation

struct MetadataScannerPreview: View {
    
    @ObservedObject var engine: ScannerEngine
    
    var videoGravity: AVLayerVideoGravity
    var metadataObjectTypes: [AVMetadataObject.ObjectType]
    var scans: Bool
    @State private var displaying: Bool = false
    
    var onUpdate: ([ScannedMetadataObject]?) -> Void
    
    private var configuredEngine: ScannerEngine {
        engine
            .setMetadataObjectTypes(metadataObjectTypes)
            .scans(displaying && scans)
    }
    
    var body: some View {
        
        ScannerEngineView(engine: configuredEngine, videoGravity: videoGravity, onUpdate: onUpdate)
            .onAppear {
                displaying = true
            }
            .onDisappear {
                displaying = false
            }
        
    }
    
}

struct ScannerEngineView: UIViewRepresentable {
    
    @ObservedObject var engine: ScannerEngine
    
    var videoGravity: AVLayerVideoGravity
    var onUpdate: ([ScannedMetadataObject]?) -> Void
    
    func makeUIView(context: Context) -> ScannerEngineUIView {
        let view = ScannerEngineUIView(engine: engine, onUpdate: onUpdate)
        view.videoGravity = videoGravity
        return view
    }
    
    func updateUIView(_ uiView: ScannerEngineUIView, context: Context) {
        uiView.onUpdate = onUpdate
        uiView.videoGravity = videoGravity
    }
    
}

final class ScannerEngineUIView: UIView {
    
    let engine: ScannerEngine
    
    private let previewLayer: AVCaptureVideoPreviewLayer
    private var cancellables: Set<AnyCancellable> = []
    
    var onUpdate: ([ScannedMetadataObject]?) -> Void
    var videoGravity: AVLayerVideoGravity {
        get { return previewLayer.videoGravity }
        set { previewLayer.videoGravity = newValue }
    }
    
    init(engine: ScannerEngine, onUpdate: @escaping ([ScannedMetadataObject]?) -> Void) {
        
        self.engine = engine
        self.previewLayer = AVCaptureVideoPreviewLayer(session: engine.session)
        
        self.onUpdate = onUpdate
        
        super.init(frame: .zero)
        
        self.togglePreviewOrientation()
        self.layer.addSublayer(previewLayer)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        subscribeIfNeeded()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        subscribeIfNeeded()
    }
    
    private func subscribeIfNeeded() {
        
        guard cancellables.isEmpty else {
            return
        }
        
        engine.$readableMetadataObjects
            .dropFirst() // @Published publisher will immediately send current value at subscription, which will cause `Modifying state during view update` warning on @State variables.
            .sink(receiveValue: onUpdate)
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .sink { [weak self] _ in self?.togglePreviewOrientation() }
            .store(in: &cancellables)
        
    }
    
    private func togglePreviewOrientation() {
        
        if let newOrientation = UIApplication.shared.windows.last?.windowScene?.interfaceOrientation.avCaptureVideoOrientation {
            previewLayer.connection?.videoOrientation = newOrientation
        }
        
    }
    
}

private extension UIInterfaceOrientation {
    
    var avCaptureVideoOrientation: AVCaptureVideoOrientation {
        switch self {
        case .landscapeLeft:
            return .landscapeLeft
            
        case .landscapeRight:
            return .landscapeRight
            
        case .portrait:
            return .portrait
            
        case .portraitUpsideDown:
            return .portraitUpsideDown
            
        case .unknown:
            fallthrough
            
        @unknown default:
            return .landscapeRight
        }
    }
    
}

#endif
