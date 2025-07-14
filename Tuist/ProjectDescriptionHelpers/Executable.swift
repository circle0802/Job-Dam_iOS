import ProjectDescription

public extension Project {
    static func executable(
        name: String,
        destinations: Destinations = .iOS,
        product: Product = .app,
        deploymentTargets: DeploymentTargets = .iOS("16.0"),
        dependencies: [TargetDependency] = []
    ) -> Project {
        Project(
            name: name,
            organizationName: "com.hackathon",
            targets: [
                Target.target(
                    name: name,
                    destinations: destinations,
                    product: product,
                    bundleId: "com.hackathon.\(name)",
                    deploymentTargets: deploymentTargets,
                    infoPlist: .file(path: Path("Support/Info.plist")),
                    sources: ["Sources/**"],
                    resources: ["Resources/**"],
                    dependencies: [
                        .project(target: "ThirdPartyLib", path: "../ThirdPartyLib")
                    ] + dependencies
                )
            ]
        )
    }
}
