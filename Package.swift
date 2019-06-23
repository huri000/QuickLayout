// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "QuickLayout",
  platforms: [
    .iOS(.v9),
    .tvOS(.v9),
    .macOS(.v10_10)
  ],
  products: [
    .library(name: "QuickLayout", targets: ["QuickLayout"])
  ],
  targets: [
    .target(
      name: "QuickLayout",
      dependencies: [],
      path: "QuickLayout"
    )
  ],
  swiftLanguageVersions: [
    .v5
  ]
)
