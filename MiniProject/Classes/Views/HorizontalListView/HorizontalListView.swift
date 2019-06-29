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
    var viewModel:HorizontalListViewCellViewModel! {get set}
}
class HorizontalListViewItem {
    var relativeCellClass:AnyClass?
    var relativeViewModel:HorizontalListViewCellViewModel!
    init(cellClass:AnyClass?,viewModel:HorizontalListViewCellViewModel) {
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
class HorizontalListView: UIView {
    private lazy var  normalStyleLayout:UICollectionViewFlowLayout = {
        let layout =  UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: self.normalStyleLayout)
        view.isPagingEnabled = true
        return view
    }()
    private var cellIDReged:[String:Bool] =  [String:Bool]()
    var listItems:[HorizontalListViewItem] = [HorizontalListViewItem]()
    var defaultCellClass:AnyClass = HorizontalListViewDefaultCell.self
    var style:HorizontalListViewStyle = .normal {
        didSet {
            switch style {
            case .normal:
                self.collectionView.collectionViewLayout = self.normalStyleLayout
            case .zoom:
                self.collectionView.collectionViewLayout = self.zoomStyleLayout()
            }
        }
    }
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
    private func isCellRegistered(cellClass:AnyClass) ->Bool {
        let cellClassIDString = NSStringFromClass(cellClass)
        return  cellIDReged[cellClassIDString] ?? false
    }
    private func markCellRegistered(cellClass:AnyClass) {
        let cellClassIDString = NSStringFromClass(cellClass)
        cellIDReged[cellClassIDString] = true
    }
    private func zoomStyleLayout() ->UICollectionViewLayout {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 20, height: 20)
        return layout
    }
}
// MARK: - Public Methods
extension HorizontalListView {
    public func refresh() {
        collectionView.reloadData()
    }
}
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
}

