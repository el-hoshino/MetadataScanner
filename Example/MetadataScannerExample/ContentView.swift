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
    @State private var scans: Bool = false
    
    var body: some View {
        MetadataScanner(objectTypes: [.qr], scans: scans) { readStrings = $0?.compactMap({ $0.stringValue }) }
            .onChange(of: readStrings, perform: { value in
                scans = value == nil
            })
            .onTapGesture(perform: {
                scans = true
            })
            .onAppear(perform: {
                scans = true
            })
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
