import UIKit
import SnapKit
import Then

class MainViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HomeVCDelegate {
    
    var homeCollectionV: UICollectionView!
    private let summationView = SummationView(job: "선생님", content: "피드백 요약 피드백 요약 피드백 요약 피드백 요약 피드백 요약 피드백 요약 피드백 요약 피드백 요약 피드백 요약 피드백 요약 피드백")
    private let newLabel = UILabel().then {
        $0.text = "새로 올라온 글"
        $0.font = .jobdamFont(.body3)
    }
    private let backgroundView = UIView().then {
        $0.backgroundColor = JobDamAsset.main50.color
        $0.layer.cornerRadius = 10
    }
    private let postTableView = MainPostTableView()
    private let moreButton = UIButton().then {
        $0.setTitle("다른 글도 보러가기", for: .normal)
        $0.setTitleColor(JobDamAsset.black.color, for: .normal)
        $0.titleLabel?.font = .jobdamFont(.body3)
    }
    
    override func configureViewController() {
        self.title = "메인페이지"
        setupCollectionView()
    }
    
    override func addView() {
        [
            homeCollectionV!,
            summationView,
            newLabel,
            backgroundView,
            moreButton
        ].forEach { view.addSubview($0) }
        backgroundView.addSubview(postTableView)
    }
    
    override func setLayout() {
        homeCollectionV.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        summationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        newLabel.snp.makeConstraints {
            $0.top.equalTo(summationView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(32)
        }
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(newLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        postTableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(190)
        }
        moreButton.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(32)
        }
    }

    override func bind() {
        moreButton.rx.tap
            .bind { [weak self] in
                self?.tabBarController?.selectedIndex = 0
            }
            .disposed(by: disposeBag)

        postTableView.didSelectName = { [weak self] name in
            let postDetailVC = PostDetailViewController()
            postDetailVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(postDetailVC, animated: true)
        }
    }
}

extension MainViewController {
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        
        homeCollectionV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        homeCollectionV.delegate = self
        homeCollectionV.dataSource = self
        homeCollectionV.backgroundColor = .clear
        homeCollectionV.register(ScrollBannerView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: "ScrollBannerView")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        homeCollectionV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .lightGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 30) / 2, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                        withReuseIdentifier: "ScrollBannerView",
                                                                        for: indexPath) as! ScrollBannerView
            header.delegate = self
            return header
        }
        return UICollectionReusableView()
    }
    
    func tryDonating() {
        print("tryDonating called")
    }
    
    func tryDoneeDetail() {
        print("tryDoneeDetail called")
    }
    
    func goToGGNet() {
        print("goToGGNet called")
    }
}
