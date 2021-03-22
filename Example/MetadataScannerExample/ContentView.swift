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
    
    @State private var readString: String = ""
    @State private var viewDidAppear: Bool = false
    var scans: Bool {
        readString.isEmpty
    }
    
    @ViewBuilder
    func ScannerView() -> some View {
        if let scanner = MetadataScanner(videoGravity: .resizeAspectFill,
                                         objectTypes: [.qr],
                                         scans: viewDidAppear && scans,
                                         onScannedObjectUpdate: {
                                            readString = $0?.lazy.compactMap({ $0.stringValue }).first ?? ""
                                         }) {
            scanner
        } else {
            Rectangle()
                .fill(Color.black)
        }
    }
    
    var body: some View {
        VStack {
            ScannerView()
                .aspectRatio(1.5, contentMode: .fit)
            TextField("Searching for QRCode...", text: $readString)
                .disabled(true)
            Spacer()
            Button("Rescan", action: { readString = "" })
                .disabled(scans)
        }
        .onAppear {
            viewDidAppear = true
        }
        .onDisappear {
            viewDidAppear = false
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
