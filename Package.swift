// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DrinkMore",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "DrinkMore", targets: ["DrinkMore"])
    ],
    targets: [
        .executableTarget(
            name: "DrinkMore",
            path: "Sources/DrinkMore"
        )
    ]
)
