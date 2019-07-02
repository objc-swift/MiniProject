//
//  MiniGalleryViewController.swift
//  MiniProject
//
//  Created by yxyyxy on 2019/7/2.
//  Copyright © 2019 yxy. All rights reserved.
//

import UIKit

class MiniGalleryViewController: UIViewController {
    @IBOutlet private weak var topView: HorizontalListView!
    @IBOutlet private weak var bottomView: HorizontalListView!
    private var pageSyner:PageSyner = PageSyner() // 同步器
    var galleryItems:[GalleryItem]?
    var addtionTopItems:[HorizontalListViewItem]?
    var addtionBottomItems:[HorizontalListViewItem]?
    var topStyle:HorizontalListViewStyle?
    var bottomStyle:HorizontalListViewStyle?
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 
        if let items = self.galleryItems {
            for item in items {
                self.addNewGalleryItem(item)
            }
        }
        if let items = self.addtionTopItems {
            for item in items {
                self.topView.listItems.append(item)
            }
        }
        if let items = self.addtionBottomItems {
            for item in items {
                self.bottomView.listItems.append(item)
            }
        }
        self.topView.style = topStyle ?? .normal
        self.bottomView.style = bottomStyle ?? .normal
        //  加入到同步器
        pageSyner.appendNewPageObject(pageObject: topView)
        pageSyner.appendNewPageObject(pageObject: bottomView)
    }
    @IBAction func backTap(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
}

// MARK: - Private Methods
extension MiniGalleryViewController {
    private func addNewGalleryItem(_ item:GalleryItem) {
        guard self.topView != nil && self.bottomView != nil else {
            return
        }
        let topVM = HorizontalListViewCellViewModel(entity: item as AnyObject)
        let topListItem = HorizontalListViewItem(cellClass: ListViewVideoPlayerCell.self, viewModel: topVM)
        self.topView.listItems.append(topListItem)
        let bottomVM = HorizontalListViewCellViewModel(entity: item as AnyObject)
        let bottomListItem = HorizontalListViewItem(cellClass: ImageDisplayerCell.self, viewModel: bottomVM)
        self.bottomView.listItems.append(bottomListItem)
    }
    private func refresh () {
        guard self.topView != nil && self.bottomView != nil else {
            return
        }
        self.topView.refresh()
        self.bottomView.refresh()
    }
}
// MARK: - public Methods
extension MiniGalleryViewController {
    
}
