import UIKit

protocol HomeVCDelegate: AnyObject {
    func tryDonating()
    func tryDoneeDetail()
    func goToGGNet()
}

class ScrollBannerView: UICollectionReusableView {
    
    let scrollView = LoopScrollView(frame: .zero)
    var delegate: HomeVCDelegate?
    
    // 슬라이드 뷰들 직접 코드로 생성
    let view1: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    }()
    
    let view2: UIView = {
        let v = UIView()
        v.backgroundColor = .green
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupScrollView()
        setupSlides()
        setupTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupScrollView() {
        scrollView.frame = bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(scrollView)
        
        // 제스처 연결
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(goToGGNet))
        view1.addGestureRecognizer(tap1)
        view1.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tryDoneeDetail))
        view2.addGestureRecognizer(tap2)
        view2.isUserInteractionEnabled = true
        
        scrollView.numPages = 2
        scrollView.viewObjects = [view1, view2]
        scrollView.setup()
    }
    
    private func setupSlides() {
        // 뷰는 LoopScrollView 내부에서 프레임 조정하므로 여기선 추가 작업 필요 없음
    }
    
    private func setupTimer() {
        Timer.scheduledTimer(timeInterval: 4.0,
                             target: self,
                             selector: #selector(autoScroll),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc func autoScroll() {
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + Util.SW(), y: 0), animated: true)
    }
    
    @objc func tryDonating() {
        delegate?.tryDonating()
    }
    
    @objc func tryDoneeDetail() {
        delegate?.tryDoneeDetail()
    }
    
    @objc func goToGGNet() {
        delegate?.goToGGNet()
    }
}
