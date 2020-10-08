// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Unilib",
    platforms: [
        .iOS(.v13) 
        // NOTE: if version enum case is not available, use string based e.g. "14"
    ],
    products: [
        .library(
            name: "Unilib",
            targets: ["Unilib"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Unilib",
            dependencies: [],
            path: "Unilib/Sources" 
        ),
        // .target( .. ) etc
        .testTarget(
            name: "UnilibTests",
            dependencies: ["Unilib"], // <-- target(s) to test
            path: "UnilibTests"
        ),
    ]
)
