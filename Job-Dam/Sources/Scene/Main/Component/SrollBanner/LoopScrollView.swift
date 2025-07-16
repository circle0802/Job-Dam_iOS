import UIKit

struct Util {
    static func SW() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}

class LoopScrollView: UIScrollView, UIScrollViewDelegate {

    var viewObjects: [UIView]?
    var numPages: Int = 0
    var pageControl: UIPageControl?

    private let bannerWidth: CGFloat = 329
    private let bannerHeight: CGFloat = 128

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
    }

    func setup() {
        guard numPages > 0 else { return }

        contentSize = CGSize(width: bannerWidth * CGFloat(numPages + 2), height: bannerHeight)

        // 로드 페이지: 0 ~ numPages+1 (맨 앞과 맨 뒤 복제)
        for page in 0...(numPages + 1) {
            loadScrollViewWithPage(page)
        }

        // 첫 페이지 위치로 셋팅 (page 1)
        contentOffset = CGPoint(x: bannerWidth, y: 0)
    }

    private func loadScrollViewWithPage(_ page: Int) {
        guard page >= 0 && page <= numPages + 1 else { return }

        let index: Int
        if page == 0 {
            index = numPages - 1
        } else if page == numPages + 1 {
            index = 0
        } else {
            index = page - 1
        }

        guard let view = viewObjects?[index] else { return }

        view.frame = CGRect(x: CGFloat(page) * bannerWidth, y: 0, width: bannerWidth, height: bannerHeight)

        if view.superview == nil {
            addSubview(view)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = bannerWidth
        let page = Int((contentOffset.x + (0.5 * pageWidth)) / pageWidth)

        // 페이지 컨트롤 인덱스 보정
        let currentPage: Int
        if page == 0 {
            currentPage = numPages - 1
        } else if page == numPages + 1 {
            currentPage = 0
        } else {
            currentPage = page - 1
        }
        pageControl?.currentPage = currentPage

        // 주변 페이지 뷰도 미리 로드 (최적화)
        loadScrollViewWithPage(page - 1)
        loadScrollViewWithPage(page)
        loadScrollViewWithPage(page + 1)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        fixScrollPosition()
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        fixScrollPosition()
    }

    private func fixScrollPosition() {
        let pageWidth = bannerWidth
        let page = Int((contentOffset.x + (0.5 * pageWidth)) / pageWidth)

        if page == 0 {
            // 맨 앞 페이지에서 마지막 실제 페이지로 점프
            contentOffset = CGPoint(x: pageWidth * CGFloat(numPages), y: 0)
        } else if page == numPages + 1 {
            // 맨 뒤 페이지에서 첫 실제 페이지로 점프
            contentOffset = CGPoint(x: pageWidth, y: 0)
        }
    }
}
