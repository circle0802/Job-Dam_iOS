import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.dynamicFramework(
    name: "ThirdPartyLib",
    deploymentTargets: .iOS("16.0"), packages: [
        .RxSwift,
        .Moya,
        .Then,
        .SnapKit,
        .Kingfisher,
        .Cosmos
    ],
    dependencies: [
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.RxMoya,
        .SPM.Then,
        .SPM.SnapKit,
        .SPM.Kingfisher,
        .SPM.Cosmos
    ]
)
