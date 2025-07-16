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
        contentSize = CGSize(width: CGFloat(numPages + 2) * 329, height: 128)

        loadScrollViewWithPage(0)
        loadScrollViewWithPage(1)
        loadScrollViewWithPage(2)

        scrollRectToVisible(CGRect(x: 329, y: 0, width: 329, height: 128), animated: false)
    }

    private func loadScrollViewWithPage(_ page: Int) {
        if page < 0 || page >= numPages + 2 { return }

        let index: Int
        if page == 0 {
            index = numPages - 1
        } else if page == numPages + 1 {
            index = 0
        } else {
            index = page - 1
        }

        guard let view = viewObjects?[index] else { return }

        view.frame = CGRect(x: CGFloat(page) * 329, y: 0, width: 329, height: 128)

        if view.superview == nil {
            addSubview(view)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = 329
        let page = Int((contentOffset.x + (0.5 * pageWidth)) / pageWidth)

        pageControl?.currentPage = {
            if page == 0 { return numPages - 1 }
            else if page == numPages + 1 { return 0 }
            else { return page - 1 }
        }()

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
        let pageWidth: CGFloat = 329
        let page = Int((contentOffset.x + (0.5 * pageWidth)) / pageWidth)

        if page == 0 {
            contentOffset = CGPoint(x: CGFloat(numPages) * pageWidth, y: 0)
        } else if page == numPages + 1 {
            contentOffset = CGPoint(x: pageWidth, y: 0)
        }
    }
}
