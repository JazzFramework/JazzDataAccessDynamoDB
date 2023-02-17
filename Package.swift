// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JazzDataAccessDynamoDB",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "JazzDataAccessDynamoDB",
            targets: ["JazzDataAccessDynamoDB"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JazzFramework/Jazz.git", from: "0.0.8"),

        .package(url: "https://github.com/awslabs/aws-sdk-swift", from: "0.10.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "JazzDataAccessDynamoDB",
            dependencies: [
                .product(name: "JazzConfiguration", package: "Jazz"),
                .product(name: "JazzCore", package: "Jazz"),
                .product(name: "JazzDataAccess", package: "Jazz"),

                .product(name: "AWSClientRuntime", package: "aws-sdk-swift"),
                .product(name: "AWSDynamoDB", package: "aws-sdk-swift"),
            ]),
        .testTarget(
            name: "JazzDataAccessDynamoDBTests",
            dependencies: ["JazzDataAccessDynamoDB"]),
    ]
)
