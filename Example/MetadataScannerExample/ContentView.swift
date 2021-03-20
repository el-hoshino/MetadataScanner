//
//  ContentView.swift
//  MetadataScannerExample
//
//  Created by 史 翔新 on 2021/03/18.
//

import SwiftUI
import AVFoundation
import MetadataScanner

struct ContentView: View {
    
    @State private var readStrings: [String]?
    @State private var videoGravity: VideoGravity = .resizeAspect
    @State private var scans: Bool = false
    
    var body: some View {
        MetadataScanner(videoGravity: videoGravity, objectTypes: [.qr], scans: scans) { readStrings = $0?.compactMap({ $0.stringValue }) }
            .onChange(of: readStrings, perform: { value in
                scans = value == nil
            })
            .onTapGesture(count: 2, perform: {
                videoGravity.toggle()
            })
            .onTapGesture(perform: {
                scans = true
            })
            .onAppear(perform: {
                scans = true
            })
    }
    
}

private extension VideoGravity {
    
    mutating func toggle() {
        if self == .resizeAspect {
            self = .resizeAspectFill
        } else {
            self = .resizeAspect
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
