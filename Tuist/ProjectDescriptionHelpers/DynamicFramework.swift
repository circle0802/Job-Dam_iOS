import ProjectDescription

public extension Project {
    static func dynamicFramework(
        name: String,
        destinations: Destinations = .iOS,
        deploymentTargets: DeploymentTargets,
        infoPlist: InfoPlist = .default,
        packages: [Package] = [],
        dependencies: [TargetDependency] = [
            .project(target: "ThirdPartyLib", path: "../ThirdPartyLib")
        ]
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
                    infoPlist: infoPlist,
                    sources: ["Sources/**"],
                    resources: [],
                    dependencies: dependencies,
                    settings: .settings()
                )
            ]
        )
    }
}
