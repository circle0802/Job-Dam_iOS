import UIKit

class MainViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HomeVCDelegate {
    
    var homeCollectionV: UICollectionView!
    
    override func configureViewController() {
        self.title = "메인페이지"
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 200) // 헤더 높이 지정
        
        homeCollectionV = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        homeCollectionV.delegate = self
        homeCollectionV.dataSource = self
        homeCollectionV.backgroundColor = .white
        homeCollectionV.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        homeCollectionV.register(ScrollBannerView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: "ScrollBannerView")
        
        view.addSubview(homeCollectionV)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0  // 예시 아이템 개수
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 셀 등록 및 설정 (기본 셀 사용 예시)
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
        // 원하는 동작 구현
    }
    func tryDoneeDetail() {
        print("tryDoneeDetail called")
        // 원하는 동작 구현
    }
    func goToGGNet() {
        print("goToGGNet called")
        // 원하는 동작 구현
    }
}
