//
//  HorizontalListView.swift
//  MiniProject
//
//  Created by yxyyxy on 2019/6/28.
//  Copyright © 2019 yxy. All rights reserved.
//

import UIKit
enum HorizontalListViewStyle {
    case normal // default style
    case zoom // zoom-in zomm-out
}
protocol HorizontalListViewCell {
    var viewModel:HorizontalListViewCellViewModel? {get set}
}
class HorizontalListViewItem {
    var relativeCellClass:AnyClass?
    var relativeViewModel:HorizontalListViewCellViewModel!
    init(cellClass:AnyClass?,viewModel:HorizontalListViewCellViewModel?) {
        self.relativeCellClass = cellClass
        self.relativeViewModel = viewModel
    }
}
class HorizontalListViewCellViewModel {
    var entity:AnyObject!
    init(entity:AnyObject) {
        self.entity = entity
    }
}
class HorizontalListView: UIView,PageObject {
    private lazy var  normalStyleLayout:UICollectionViewFlowLayout = {
        let layout =  UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()
    private lazy var zoomStyleLayout:ZoomCollectionViewLayout = {
        return ZoomCollectionViewLayout()
    }()
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: self.normalStyleLayout)
        view.backgroundColor = .clear
        return view
    }()
    private var cellIDReged:[String:Bool] =  [String:Bool]()
    var listItems:[HorizontalListViewItem] = [HorizontalListViewItem]()
    var defaultCellClass:AnyClass = HorizontalListViewDefaultCell.self
    var style:HorizontalListViewStyle = .normal {
        didSet {
            switch style {
            case .normal:
                self.noramlStyleSetting()
            case .zoom:
                self.zoomStyleSetting()
            }
        }
    }
    var currentLayout:UICollectionViewFlowLayout!
    var contentSize:CGSize {
        return self.collectionView.contentSize
    }
    var isOriginSender:Bool = false
    /// event
    var didPageChange:((CGFloat)->Void)?
    var didSelectItem:((Int)->Void)?
    /// storage handler
    var pageChangeHandler: ((CGFloat, PageObject) -> Void)?
    var becomeOriginSenderHandler:((PageObject)->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeSubViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeSubViews()
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
        normalStyleLayout.itemSize = CGSize(width: self.bounds.width, height: self.bounds.height)
    }
}
// MARK: - Private Methods
extension HorizontalListView {
    private func initializeSubViews () {
        self.addSubview(self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerCell(cellClass: defaultCellClass)
        markCellRegistered(cellClass: defaultCellClass)
    }
    /// 判断cell是否已经注册
    private func isCellRegistered(cellClass:AnyClass) ->Bool {
        let cellClassIDString = NSStringFromClass(cellClass)
        return  cellIDReged[cellClassIDString] ?? false
    }
    /// 标记某个CellClass已注册
    private func markCellRegistered(cellClass:AnyClass) {
        let cellClassIDString = NSStringFromClass(cellClass)
        cellIDReged[cellClassIDString] = true
    }
    private func noramlStyleSetting() {
        self.currentLayout = self.normalStyleLayout
        self.collectionView.collectionViewLayout = self.normalStyleLayout
        self.collectionView.isPagingEnabled = true
    }
    private func zoomStyleSetting() {
        self.collectionView.collectionViewLayout = self.zoomStyleLayout
        self.currentLayout = self.zoomStyleLayout
        self.collectionView.isPagingEnabled = false
    }
}
// MARK: - Public Methods
extension HorizontalListView {
    public func refresh() {
        self.collectionView.reloadData()
    }
    public func scrollToX(x:CGFloat) {
        self.collectionView.contentOffset = CGPoint(x: x, y: 0)
    }
    // page 有可能是1.2 1.3 这种形式
}
// MARK:PageObject protocol
extension HorizontalListView {
    func scrollToPage(page:CGFloat) {
        let page_w = self.currentLayout.itemSize.width + self.currentLayout.minimumLineSpacing
        self.collectionView.contentOffset = CGPoint(x: page_w * page , y: 0)
    }
    func initPageObject(pageChangeHandler: @escaping (CGFloat, PageObject) -> Void, becomeOriginSenderHandler: @escaping (PageObject) -> Void) {
        self.pageChangeHandler = pageChangeHandler
        self.becomeOriginSenderHandler = becomeOriginSenderHandler
    }
}
// MARK:UICollectionViewDelegate
extension  HorizontalListView:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let thisItem:HorizontalListViewItem = listItems[indexPath.row]
        var cellClass:AnyClass = defaultCellClass
        if let relativeCellClass:AnyClass = thisItem.relativeCellClass {
            // 如果有自定义cell，就使用自定义的cell，否则使用默认的
            cellClass = relativeCellClass
        }
        if !isCellRegistered(cellClass: cellClass) {
            // 尚未注册的cell，进行注册
            collectionView.registerCell(cellClass: cellClass)
            markCellRegistered(cellClass: cellClass)
        }
        let cellClassIDString:String = NSStringFromClass(cellClass)
        var cell:HorizontalListViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellClassIDString, for: indexPath) as! HorizontalListViewCell
        cell.viewModel = thisItem.relativeViewModel
        return cell as! UICollectionViewCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectItem?(indexPath.row)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.didPageChange != nil || self.pageChangeHandler != nil else {
            return
        }
        // 进度 , itwmWidth + padding 为一页宽度
        let offx = scrollView.contentOffset.x
        let page_w = self.currentLayout.itemSize.width + self.currentLayout.minimumLineSpacing
        let page_f  = offx / page_w
        self.didPageChange?(page_f)
        self.pageChangeHandler?(page_f,self)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard self.style == .zoom else {
            return
        }
        let offx = targetContentOffset.pointee.x
        let page_w = self.zoomStyleLayout.itemWidth + self.zoomStyleLayout.minimumLineSpacing
        let page_f  = offx / page_w
        targetContentOffset.pointee.x = CGFloat(roundf((Float(page_f)))) * page_w
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.becomeOriginSenderHandler?(self)
    }
}

