import UIKit
import SnapKit
import Then
import RxSwift

class PostDetailViewController: BaseViewController {
    private let titleLabel = UILabel().then {
        $0.text = "인생이 너무 힘들어요 ㅜ"
        $0.font = .jobdamFont(.heading3)
        $0.numberOfLines = 0
    }
    private let idLabel = UILabel().then {
        $0.text = "circle08"
        $0.font = .jobdamFont(.body1)
        $0.textColor = JobDamAsset.gray600.color
    }
    private let contentLabel = UILabel().then {
        $0.text = "저만 그런가요? 요즘 너무 무기력하고 뭘 하고 싶지도 않네요. 하 너무 인생이 재미가 없는 것 같아요. 저에게 인생의 재미 를 알려주실 분 안계신가요? 시급해요. 평점 5점 드릴게요."
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
    private let inputContainerView = UIView().then {
        $0.backgroundColor = JobDamAsset.white.color
    }

    private let inputTextView = UITextView().then {
        $0.font = .jobdamFont(.body2)
        $0.textColor = JobDamAsset.black.color
        $0.backgroundColor = JobDamAsset.gray50.color
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        $0.layer.cornerRadius = 10
    }

    private let sendButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(JobDamAsset.white.color, for: .normal)
        $0.titleLabel?.font = .jobdamFont(.body2)
        $0.backgroundColor = JobDamAsset.main400.color
        $0.layer.cornerRadius = 5
    }


    override func addView() {
        [
            titleLabel,
            idLabel,
            contentLabel,
            dayLabel,
            line,
            commemtTableView,
            inputContainerView
        ].forEach { view.addSubview($0) }

        [
            inputTextView,
            sendButton
        ].forEach { inputContainerView.addSubview($0) }
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
        inputContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.height.greaterThanOrEqualTo(60)
        }

        inputTextView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-8)
        }

        sendButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalTo(inputTextView)
            $0.width.equalTo(59)
            $0.height.equalTo(33)
        }

    }
    override func configureViewController() {
        self.title = "질문"

        let backImage = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = JobDamAsset.black.color

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
