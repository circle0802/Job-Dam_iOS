import UIKit
import SnapKit
import Then

class MainViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HomeVCDelegate {
    
    var homeCollectionV: UICollectionView!
    
    override func configureViewController() {
        self.title = "메인페이지"
        setupCollectionView()
    }
}

extension MainViewController {
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        
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
