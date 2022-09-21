// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PIPWKit",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PIPWKit",
            targets: ["PIPWKit"]),
    ],
    targets: [
        .target(
            name: "PIPWKit",
            path: "Classes"),
    ]
)
