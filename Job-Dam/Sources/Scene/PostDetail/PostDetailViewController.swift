import UIKit
import SnapKit
import Then
import RxSwift
import Moya

class PostDetailViewController: BaseViewController {
    private let manager: Session = Session(configuration: URLSessionConfiguration.default, serverTrustManager: CustomServerTrustManager())
    private lazy var provider = MoyaProvider<PostAPI>(session: manager, plugins: [MoyaLoggingPlugin()])

    private let titleLabel = UILabel().then {
        $0.font = .jobdamFont(.heading3)
        $0.numberOfLines = 0
    }
    private let idLabel = UILabel().then {
        $0.font = .jobdamFont(.body1)
        $0.textColor = JobDamAsset.gray600.color
    }
    private let contentLabel = UILabel().then {
        $0.font = .jobdamFont(.body1)
        $0.numberOfLines = 0
    }
    private let dayLabel = UILabel().then {
        $0.text = "2025.07.16"
        $0.font = .jobdamFont(.body3)
        $0.textColor = JobDamAsset.gray600.color
    }
    private let line = UIView().then {
        $0.backgroundColor = JobDamAsset.gray200.color
    }
    private let commemtTableView = CommentTableView()
    private let evaluationPopupView = EvaluationPopupView(id: "circle08")

    private let id: Int
    init(id: Int) {
            self.id = id
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    override func addView() {
        [
            titleLabel,
            idLabel,
            contentLabel,
            dayLabel,
            line,
            commemtTableView
        ].forEach { view.addSubview($0) }
    }
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        idLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(32)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        dayLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(32)
        }
        line.snp.makeConstraints {
            $0.top.equalTo(dayLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        commemtTableView.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
    override func configureViewController() {
        self.title = "질문"

        let backImage = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = JobDamAsset.black.color

        commemtTableView.didSelectName = { [weak self] commentCount in
            self?.evaluationPopupView.show()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPostDetail()
    }

    private func getPostDetail() {
        provider.request(.viewDetailPost(id: id)) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(PostDetailResponse.self, from: response.data)

                    DispatchQueue.main.async {
                        self.titleLabel.text = decodedData.title
                        self.idLabel.text = decodedData.author
                        self.contentLabel.text = decodedData.content
                        self.dayLabel.text = decodedData.createdAt
                        
                        self.commemtTableView.updateData(decodedData.commentList.comments)
                    }
                } catch {
                    print("Decoding error:", error)
                }

            case .failure(let error):
                print("Network error:", error)
            }
        }
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
