import UIKit
import SnapKit

protocol HomeVCDelegate: AnyObject {
    func tryDonating()
    func tryDoneeDetail()
    func goToGGNet()
}

class ScrollBannerView: UICollectionReusableView {

    let scrollView = LoopScrollView(frame: .zero)
    let pageControl = UIPageControl()

    var delegate: HomeVCDelegate?

    let view1 = JobExperienceBannerView()
    let view2 = JobTestBannerView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupScrollView()
        setupPageControl()
        setupTimer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 329, height: 128))
        }

        view1.frame = CGRect(origin: .zero, size: CGSize(width: 329, height: 128))
        view2.frame = view1.frame

        scrollView.viewObjects = [view1, view2]
        scrollView.numPages = 2
        scrollView.pageControl = pageControl

        DispatchQueue.main.async {
            self.scrollView.setup()
        }

        view1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(banner1Tapped)))
        view2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(banner2Tapped)))
    }

    private func setupPageControl() {
        addSubview(pageControl)
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray

        pageControl.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
    }

    private func setupTimer() {
        Timer.scheduledTimer(timeInterval: 4.0,
                             target: self,
                             selector: #selector(autoScroll),
                             userInfo: nil,
                             repeats: true)
    }

    @objc private func autoScroll() {
        let nextX = scrollView.contentOffset.x + 329
        scrollView.setContentOffset(CGPoint(x: nextX, y: 0), animated: true)
    }

    @objc private func banner1Tapped() { delegate?.goToGGNet() }
    @objc private func banner2Tapped() { delegate?.tryDonating() }
}
