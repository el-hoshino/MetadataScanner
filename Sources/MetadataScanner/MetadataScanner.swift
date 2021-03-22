//
//  MetadataScanner.swift
//
//
//  Created by 史 翔新 on 2021/03/18.
//

#if os(iOS)

import SwiftUI

/// `MetadataScanner` is a `Button`-like `SwiftUI.View` component.
/// You can use it anywhere in your `body: some View` property in a `View` just like any other `View` component.
/// It will call `onScannedObjectUpdate` callback when found any metadata, just like a `Button` callback when tapped.
public struct MetadataScanner: View {
    
    private static let sharedEngine: ScannerEngine? = try? .init()
    
    private let engine: ScannerEngine
    var videoGravity: VideoGravity
    var metadataObjectTypes: [ScannableObjectType]
    var scans: Bool
    
    var onScannedObjectUpdate: (([ScannedMetadataObject]?) -> Void)
    
    /// MetadataScanner initializer.
    /// Please note that this is a failable initializer and it will be nil if it can't find any usable camera.
    /// And in that case, you may want to create another placeholder view.
    ///
    /// - Parameters:
    ///   - videoGravity: `VideoGravity` is actually a type alias of `AVLayerVideoGravity`.
    ///     You may set it with any of `.resize`, `.resizeAspect` or `.resizeAspectFill`.
    ///   - objectTypes: `ScannableObjectType` is actually a type alias of `AVMetadataObject.ObjectType`.
    ///     There are many available object types, including the most famous `.qr` for reading QR codes.
    ///   - scans: This property controls whether the camera should work or not.
    ///     Please note that if you are writing the scan result to a `@State` value, you may want to set it to `false` until the view did appear, otherwise SwiftUI will throw a warning of "Modifying state during view update" at runtime.
    ///   - onScannedObjectUpdate: A callback of `([ScannedMetadataObject]?) -> Void)`, when `MetadataScanner` initialized or found any result from camera.
    ///     `AVMetadataMachineReadableCodeObject` is actually a type alias of `AVMetadataMachineReadableCodeObject`.
    public init?(videoGravity: VideoGravity, objectTypes: [ScannableObjectType], scans: Bool, onScannedObjectUpdate: @escaping ([ScannedMetadataObject]?) -> Void) {
        guard let engine = Self.sharedEngine else {
            return nil
        }
        self.engine = engine
        self.metadataObjectTypes = objectTypes
        self.videoGravity = videoGravity
        self.scans = scans
        self.onScannedObjectUpdate = onScannedObjectUpdate
    }
    
    public var body: some View {
        MetadataScannerPreview(engine: engine, videoGravity: videoGravity, metadataObjectTypes: metadataObjectTypes, scans: scans, onUpdate: onScannedObjectUpdate)
    }
    
}

#endif
