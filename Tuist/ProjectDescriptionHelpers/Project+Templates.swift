import ProjectDescription

public extension Project {
    static func framework(
        name: String,
        destinations: Destinations = .iOS,
        deploymentTargets: DeploymentTargets,
        packages: [Package] = [],
        dependencies: [TargetDependency] = []
    ) -> Project {
        return Project(
            name: name,
            packages: packages,
            targets: [
                .target(
                    name: name,
                    destinations: destinations,
                    product: .framework,
                    bundleId: "com.hackathon.\(name)",
                    deploymentTargets: deploymentTargets,
                    infoPlist: .default,
                    sources: ["Sources/**"],
                    resources: [],
                    dependencies: dependencies
                )
            ]
        )
    }
    
    static func app(
        name: String,
        destinations: Destinations = .iOS,
        deploymentTargets: DeploymentTargets,
        dependencies: [TargetDependency] = []
    ) -> Project {
        return Project(
            name: name,
            targets: [
                .target(
                    name: name,
                    destinations: destinations,
                    product: .app,
                    bundleId: "com.hackathon.\(name)",
                    deploymentTargets: deploymentTargets,
                    infoPlist: .default,
                    sources: ["Sources/**"],
                    resources: ["Resources/**"],
                    dependencies: dependencies
                )
            ]
        )
    }
}
