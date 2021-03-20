//
//  MetadataScanner.swift
//
//
//  Created by 史 翔新 on 2021/03/18.
//

#if os(iOS)

import SwiftUI

public struct MetadataScanner: View {
    
    private static let sharedEngine: ScannerEngine? = try? .init()
    
    private let engine: ScannerEngine
    var videoGravity: VideoGravity
    var metadataObjectTypes: [ScannableObjectType]
    var scans: Bool
    
    @Binding var scannedMetadataObjects: [ScannedMetadataObject]?
    
    public init?(videoGravity: VideoGravity, objectTypes: [ScannableObjectType], scans: Bool, scannedMetadataObjects: Binding<[ScannedMetadataObject]?>) {
        guard let engine = Self.sharedEngine else {
            return nil
        }
        self.engine = engine
        self.metadataObjectTypes = objectTypes
        self.videoGravity = videoGravity
        self.scans = scans
        self._scannedMetadataObjects = scannedMetadataObjects
    }
    
    public var body: some View {
        MetadataScannerPreview(engine: engine, videoGravity: videoGravity, metadataObjectTypes: metadataObjectTypes, scans: scans, scannedMetadataObjects: $scannedMetadataObjects)
    }
    
}

#endif
