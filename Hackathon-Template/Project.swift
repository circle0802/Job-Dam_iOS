import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.executable(
    name: "Hackathon-Template",
    destinations: .iOS,
    deploymentTargets: .iOS("16.0"),
    dependencies: []
)
