//
//  ScannerEngine.swift
//
//
//  Created by 史 翔新 on 2021/03/18.
//

#if os(iOS)

import AVFoundation
import CoreImage
import Combine

// swiftlint:disable file_types_order

final class ScannerEngine: ObservableObject {
    
    enum InitError: Error {
        case noCameraDeviceFound
    }
    
    let session: AVCaptureSession
    
    private let metadataOutput: AVCaptureMetadataOutput
    private let captureOutputReceiver: CaptureOutputReceiver
    
    var metadataObjectTypes: [AVMetadataObject.ObjectType] {
        get { return metadataOutput.metadataObjectTypes }
        set { metadataOutput.metadataObjectTypes = newValue }
    }
    
    @Published var readableMetadataObjects: [ScannedMetadataObject]?
        
    init() throws {
        
        guard let device = AVCaptureDevice.default(for: .video) else {
            throw InitError.noCameraDeviceFound
        }
        
        let session = AVCaptureSession()
        
        session.beginConfiguration()
        defer { session.commitConfiguration() }
        
        session.sessionPreset = .photo
        
        let input = try AVCaptureDeviceInput(device: device)
        session.addInput(input)
        
        let receiver = CaptureOutputReceiver()
                
        let metadataOutput = AVCaptureMetadataOutput()
        session.addOutput(metadataOutput)
        
        self.session = session
        self.metadataOutput = metadataOutput
        self.captureOutputReceiver = receiver
        
        receiver.delegate = self
        metadataOutput.setMetadataObjectsDelegate(receiver, queue: .main)
        
    }
    
    private func start() {
        if !session.isRunning {
            session.startRunning()
        }
    }
    
    private func stop() {
        if session.isRunning {
            session.stopRunning()
        }
    }
    
    func setMetadataObjectTypes(_ types: [AVMetadataObject.ObjectType]) -> Self {
        metadataObjectTypes = types
        return self
    }
    
    func scans(_ scans: Bool) -> Self {
        if scans {
            start()
        } else {
            stop()
        }
        return self
    }
    
}

extension ScannerEngine: CaptureOutputDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        let objects = metadataObjects.compactMap { $0 as? AVMetadataMachineReadableCodeObject }
        if objects.isEmpty {
            readableMetadataObjects = nil
        } else {
            readableMetadataObjects = objects
        }

    }
    
}

private protocol CaptureOutputDelegate: AnyObject {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
}

private final class CaptureOutputReceiver: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    weak var delegate: CaptureOutputDelegate?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        delegate?.metadataOutput(output, didOutput: metadataObjects, from: connection)
    }
    
}

#endif
