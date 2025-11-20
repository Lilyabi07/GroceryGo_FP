// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "GroceryGo",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "GroceryGo",
            targets: ["GroceryGo"]),
    ],
    targets: [
        .target(
            name: "GroceryGo",
            path: "Models"),
        .testTarget(
            name: "GroceryGoTests",
            dependencies: ["GroceryGo"],
            path: "Tests"),
    ]
)
