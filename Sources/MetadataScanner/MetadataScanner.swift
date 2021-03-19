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
    var metadataObjectTypes: [ScannableObjectType]
    var scans: Bool
    
    var onScannedObjectUpdate: (([ScannedMetadataObject]?) -> Void)
    
    public init?(objectTypes: [ScannableObjectType], scans: Bool, onScannedObjectUpdate: @escaping ([ScannedMetadataObject]?) -> Void) {
        guard let engine = Self.sharedEngine else {
            return nil
        }
        self.engine = engine
        self.metadataObjectTypes = objectTypes
        self.scans = scans
        self.onScannedObjectUpdate = onScannedObjectUpdate
    }
    
    public var body: some View {
        MetadataScannerPreview(engine: engine, metadataObjectTypes: metadataObjectTypes, scans: scans, onUpdate: onScannedObjectUpdate)
    }
    
}

#endif
