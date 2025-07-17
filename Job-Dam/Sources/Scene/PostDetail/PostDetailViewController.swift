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
        $0.font = .jobdamFont(.body3)
        $0.textColor = JobDamAsset.gray600.color
    }
    private let line = UIView().then {
        $0.backgroundColor = JobDamAsset.gray200.color
    }
    private let commentTableView = CommentTableView()
    private var evaluationPopupView: EvaluationPopupView?

    private let id: Int
    private var isAuthor: Bool = false  // 현재 로그인 유저가 글 작성자인지 여부

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
            commentTableView
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
        commentTableView.snp.makeConstraints {
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

        commentTableView.didSelectComment = { [weak self] comment in
            guard let self = self else { return }

            if self.isAuthor {
                self.showEvaluationPopup(for: comment)
            } else {
                self.showToast("작성자만 신뢰도를 평가할 수 있어요.")
            }
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
                        self.commentTableView.updateData(decodedData.commentList.comments)

                        // ✅ 작성자인지 여부 확인
                        self.isAuthor = decodedData.author == Token.userID
                        print("📌 작성자: \(decodedData.author)")
                        print("📌 내 ID: \(Token.userID ?? "nil")")

                    }
                } catch {
                    print("Decoding error:", error)
                }

            case .failure(let error):
                print("Network error:", error)
            }
        }
    }

    private func showEvaluationPopup(for comment: Comment) {
        evaluationPopupView = EvaluationPopupView(authorName: comment.author)
        evaluationPopupView?.onEvaluationComplete = { rating in
            self.submitEvaluation(commentId: comment.id, rating: rating)
        }
        evaluationPopupView?.show()
    }

    private func submitEvaluation(commentId: Int, rating: Double) {
        // 평가 제출 로직
        print("✅ 평가 제출 - 댓글 ID: \(commentId), 평점: \(rating)")
        // API 요청 등 추가 가능
    }

    private func showToast(_ message: String) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.font = .systemFont(ofSize: 14)
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true
        toastLabel.alpha = 0

        toastLabel.frame = CGRect(x: 20, y: view.frame.size.height - 100, width: view.frame.size.width - 40, height: 35)
        view.addSubview(toastLabel)

        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
