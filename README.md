# MetadataScanner

MetadataScanner is a metadata scanning library built for SwiftUI apps. It provides a `Button`-like view component to make scanning view easy to implement.

## Requirements

- iOS 14.0+
- Xcode 12.4+
- Swift 5.3+

## Usage

You can use `MetadataScanner` just like any other `View` component inside a `body: some View` property in your projects. 

One thing you need to notice is that the initializer may return `nil` if no available camera found. You can replace it with any placeholder view using `if let else` statement ([check the example](Example/MetadataScannerExample/ContentView.swift)), or if you don't need a placeholder you can also just ignore it, and SwiftUI will handle it as there is no view at all.

## Example

```swift
MetadataScanner(videoGravity: .resizeAspectFill,
                objectTypes: [.qr],
                scans: true,
                onScannedObjectUpdate: { print($0) })
```

You may find a more real-situation example project in [Example](Example) path, and it looks like below:

![Example App Screenshots](README_Resource/example_app.gif)

## Installation

### Use SwiftPM (in Xcode)

1. Xcode > File > Swift Packages > Add Package Dependency
2. Add https://github.com/el-hoshino/MetadataScanner.git
3. Select "Up to Next Major" with "0.1.0"

### Use SwiftPM (using Package.swift)

1. Create a `Package.swift` file.
2. Add dependencies like below:
    ```swift
    // swift-tools-version:5.3
    // The swift-tools-version declares the minimum version of Swift required to build this package.

    import PackageDescription

    let package = Package(
        name: "MyAwsomeProject",
        dependencies: [
            .package(url: "https://github.com/el-hoshino/MetadataScanner.git", from: "0.1.0")
        ],
        targets: [
            .target(name: "MyAwsomeProject", dependencies: ["MetadataScanner"])
        ]
    )
