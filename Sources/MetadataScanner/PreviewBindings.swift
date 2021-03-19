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
        
        ScannerEngineView(engine: configuredEngine, onUpdate: onUpdate)
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
    
    var onUpdate: ([ScannedMetadataObject]?) -> Void
    
    func makeUIView(context: Context) -> ScannerEngineUIView {
        ScannerEngineUIView(engine: engine, onUpdate: onUpdate)
    }
    
    func updateUIView(_ uiView: ScannerEngineUIView, context: Context) {
        
    }
    
}

final class ScannerEngineUIView: UIView {
    
    let engine: ScannerEngine
    
    private let previewLayer: AVCaptureVideoPreviewLayer
    private var cancellables: Set<AnyCancellable> = []
    
    private var onUpdate: ([ScannedMetadataObject]?) -> Void
    
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
