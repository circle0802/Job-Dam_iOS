import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.executable(
    name: "Job-Dam",
    destinations: .iOS,
    deploymentTargets: .iOS("16.0"),
    dependencies: []
)
