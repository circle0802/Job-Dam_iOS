import UIKit
import SnapKit
import Then
import RxSwift
import Moya

class CreateViewController: BaseViewController {
    private let manager: Session = Session(configuration: URLSessionConfiguration.default, serverTrustManager: CustomServerTrustManager())
    private lazy var provider = MoyaProvider<PostAPI>(session: manager, plugins: [MoyaLoggingPlugin()])

    private let titleTextField = JobdamTextField("제목", placeholder: "제목을 입력해주세요")

    private let infoLabel = UILabel().then {
        $0.text = "100자 이내"
        $0.font = .jobdamFont(.caption)
        $0.textColor = JobDamAsset.gray700.color
    }

    private let contentLabel = UILabel().then {
        $0.text = "질문 내용"
        $0.font = .jobdamFont(.body3)
    }

    private let contentTextView = UITextView().then {
        $0.font = .jobdamFont(.body2)
        $0.backgroundColor = JobDamAsset.gray50.color
        $0.layer.cornerRadius = 5
        $0.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }

    private let placeholderLabel = UILabel().then {
        $0.text = "내용을 자세히 작성해주세요"
        $0.font = .jobdamFont(.body2)
        $0.textColor = JobDamAsset.gray400.color
        $0.numberOfLines = 1
    }
    private let infoLabel2 = UILabel().then {
        $0.text = "5000자 이내"
        $0.font = .jobdamFont(.caption)
        $0.textColor = JobDamAsset.gray700.color
    }
    private let createButton = JobdamButton(text: "질문 생성")

    override func configureViewController() {
        self.title = "질문 생성"

        let backImage = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = JobDamAsset.black.color

        contentTextView.delegate = self
    }

    override func addView() {
        [
            titleTextField,
            infoLabel,
            contentLabel,
            contentTextView,
            placeholderLabel,
            infoLabel2,
            createButton
        ].forEach { view.addSubview($0) }
    }

    override func setLayout() {
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.trailing.equalToSuperview()
        }

        infoLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom)
            $0.trailing.equalToSuperview().inset(24)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(24)
        }

        contentTextView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(200)
        }

        placeholderLabel.snp.makeConstraints {
            $0.top.equalTo(contentTextView).offset(12)
            $0.leading.equalTo(contentTextView).offset(15)
        }

        infoLabel2.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(24)
        }

        createButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(48)
            $0.height.equalTo(50)
        }
    }

    override func bind() {
        Observable
            .combineLatest(
                titleTextField.textField.rx.text.orEmpty,
                contentTextView.rx.text.orEmpty
            )
            .map { !$0.isEmpty && !$1.isEmpty }
            .distinctUntilChanged()
            .bind(to: createButton.rx.isEnabled)
            .disposed(by: disposeBag)
        createButton.rx.tap
            .bind { [weak self] in
                self?.createPost()
            }
            .disposed(by: disposeBag)
    }

    private func createPost() {
        provider.request(.createPost(title: titleTextField.textField.text ?? "", content: contentTextView.text ?? "")) { result in
            switch result {
            case .success(let response):
                print("성공!! \(response)")
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension CreateViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
