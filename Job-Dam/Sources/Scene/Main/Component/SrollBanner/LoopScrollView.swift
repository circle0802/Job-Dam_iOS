import UIKit

struct Util {
    static func SW() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}

class LoopScrollView: UIScrollView, UIScrollViewDelegate {
    
    var viewObjects: [UIView] = []
    var numPages: Int = 0
    var pageControl: UIPageControl?
    
    private let bannerWidth: CGFloat = 329
    private let bannerHeight: CGFloat = 128
    private var isScrolling = false
    private var currentIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScroll()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupScroll()
    }
    
    private func setupScroll() {
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        bounces = false
        decelerationRate = .fast
    }
    
    func setup() {
        guard numPages > 0 else { return }
        
        // 3개의 뷰만 사용: 이전, 현재, 다음
        contentSize = CGSize(width: bannerWidth * 3, height: bannerHeight)
        
        // 초기 설정
        currentIndex = 0
        setupViews()
        
        // 가운데 위치로 설정
        contentOffset = CGPoint(x: bannerWidth, y: 0)
    }
    
    private func setupViews() {
        // 기존 뷰들 제거
        subviews.forEach { $0.removeFromSuperview() }
        
        // 3개 위치에 뷰 배치
        for i in 0..<3 {
            let viewIndex = getViewIndex(for: i)
            let view = viewObjects[viewIndex]
            
            view.frame = CGRect(
                x: CGFloat(i) * bannerWidth,
                y: 0,
                width: bannerWidth,
                height: bannerHeight
            )
            
            addSubview(view)
        }
    }
    
    private func getViewIndex(for position: Int) -> Int {
        switch position {
        case 0: // 이전
            return (currentIndex - 1 + numPages) % numPages
        case 1: // 현재
            return currentIndex
        case 2: // 다음
            return (currentIndex + 1) % numPages
        default:
            return currentIndex
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isScrolling else { return }
        
        let pageWidth = bannerWidth
        let currentPage = Int((contentOffset.x + pageWidth * 0.5) / pageWidth)
        
        if currentPage == 1 {
            // 가운데 위치 - 페이지 컨트롤 업데이트
            pageControl?.currentPage = currentIndex
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleScrollEnd()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        handleScrollEnd()
    }
    
    private func handleScrollEnd() {
        isScrolling = false
        
        let pageWidth = bannerWidth
        let currentPage = Int((contentOffset.x + pageWidth * 0.5) / pageWidth)
        
        switch currentPage {
        case 0: // 이전 페이지로 이동
            currentIndex = (currentIndex - 1 + numPages) % numPages
            resetToCenter()
        case 2: // 다음 페이지로 이동
            currentIndex = (currentIndex + 1) % numPages
            resetToCenter()
        default: // 가운데 위치 유지
            break
        }
        
        // 페이지 컨트롤 업데이트
        pageControl?.currentPage = currentIndex
    }
    
    private func resetToCenter() {
        // 뷰들 재배치
        setupViews()
        
        // 애니메이션 없이 가운데로 이동
        contentOffset = CGPoint(x: bannerWidth, y: 0)
    }
    
    func moveToNext() {
        guard !isScrolling else { return }
        
        isScrolling = true
        setContentOffset(CGPoint(x: bannerWidth * 2, y: 0), animated: true)
    }
    
    func moveToPrevious() {
        guard !isScrolling else { return }
        
        isScrolling = true
        setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
