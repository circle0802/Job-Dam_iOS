import UIKit
import Foundation

struct Util {
    static func SW() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}

class LoopScrollView: UIScrollView, UIScrollViewDelegate {
    
    var viewObjects: [UIView]?
    var numPages: Int = 0
    var pageControl: UIPageControl?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        isPagingEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        delegate = self
    }

    func setup() {
        guard let parent = superview else { return }

        contentSize = CGSize(width: (Util.SW() * (CGFloat(numPages) + 2)), height: frame.size.height)

        let pageView = UIView(frame: CGRect(x: 0, y: parent.frame.size.height - 20, width: Util.SW(), height: 20))

        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: Util.SW(), height: 20))
        pageControl?.numberOfPages = numPages
        pageControl?.currentPage = 0
        pageView.addSubview(pageControl!)
        parent.addSubview(pageView)

        loadScrollViewWithPage(page: 0)
        loadScrollViewWithPage(page: 1)
        loadScrollViewWithPage(page: 2)

        var newFrame = frame
        newFrame.origin.x = Util.SW()
        newFrame.origin.y = 0
        scrollRectToVisible(newFrame, animated: false)
        
        layoutIfNeeded()
    }

    private func loadScrollViewWithPage(page: Int) {
        if page < 0 { return }
        if page >= numPages + 2 { return }

        var index = 0

        if page == 0 {
            index = numPages - 1
        } else if page == numPages + 1 {
            index = 0
        } else {
            index = page - 1
        }

        guard let view = viewObjects?[index] else { return }

        var newFrame = frame
        newFrame.origin.x = Util.SW() * CGFloat(page)
        newFrame.origin.y = 0
        view.frame = newFrame

        if view.superview == nil {
            addSubview(view)
        }

        layoutIfNeeded()
    }

    @objc func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageWidth = Util.SW()
        let page: Int = Int(floor((contentOffset.x - (pageWidth / 2)) / pageWidth) + 1)
        
        if page == 0 {
            contentOffset = CGPoint(x: pageWidth * (CGFloat(numPages)), y: 0)
        } else if page == numPages + 1 {
            contentOffset = CGPoint(x: pageWidth, y: 0)
        }
    }

    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = Util.SW()
        let page = Int(floor((contentOffset.x - (pageWidth / 2)) / pageWidth) + 1)
        pageControl?.currentPage = Int(page - 1)
        
        loadScrollViewWithPage(page: Int(page - 1))
        loadScrollViewWithPage(page: Int(page))
        loadScrollViewWithPage(page: Int(page + 1))
    }

    @objc func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = Util.SW()
        let page: Int = Int(floor((contentOffset.x - (pageWidth / 2)) / pageWidth) + 1)
        
        if page == 0 {
            contentOffset = CGPoint(x: pageWidth * (CGFloat(numPages)), y: 0)
        } else if page == numPages + 1 {
            contentOffset = CGPoint(x: pageWidth, y: 0)
        }
    }
}
