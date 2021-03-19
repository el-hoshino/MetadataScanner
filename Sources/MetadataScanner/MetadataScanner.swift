//
//  MetadataScanner.swift
//
//
//  Created by 史 翔新 on 2021/03/18.
//

#if os(iOS)

import SwiftUI
import AVFoundation

public struct MetadataScanner: View {
    
    private static let sharedEngine: ScannerEngine? = try? .init()
    
    private let engine: ScannerEngine
    var metadataObjectTypes: [AVMetadataObject.ObjectType]
    var scans: Bool
    
    @Binding var scannedObject: [AVMetadataMachineReadableCodeObject]?
    
    public init?(objectTypes: [AVMetadataObject.ObjectType], scans: Bool, scannedObject: Binding<[AVMetadataMachineReadableCodeObject]?>) {
        guard let engine = Self.sharedEngine else {
            return nil
        }
        self.engine = engine
        self.metadataObjectTypes = objectTypes
        self.scans = scans
        self._scannedObject = scannedObject
    }
    
    public var body: some View {
        MetadataScannerPreview(engine: engine, metadataObjectTypes: metadataObjectTypes, scans: scans, scannedObject: $scannedObject)
    }
    
}

#endif
