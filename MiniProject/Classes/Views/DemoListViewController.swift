//
//  DemoListViewController.swift
//  MiniProject
//
//  Created by yxyyxy on 2019/6/29.
//  Copyright © 2019 yxy. All rights reserved.
//

import UIKit
import Alamofire
class DemoListViewController: UIViewController {

    @IBOutlet weak var topView: HorizontalListView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTopView()
    }
    func initTopView() {
        self.topView.style = .zoom
        let titles = ["正常模式","全zoom动画模式","加入一些自定义Cell"]
        for title in titles {
            let vm = HorizontalListViewCellViewModel(entity: title as AnyObject )
            let item = HorizontalListViewItem(cellClass: HorizontalListViewDefaultCell.self, viewModel: vm)
            self.topView.listItems.append(item)
        }
        self.topView.refresh()
        self.topView.didSelectItem = {[weak self] (index:Int) in
            switch index {
            case 0:
                self?.normalDemo()
            case 1:
                self?.allZoomDemo()
            case 2:
                self?.customDemo()
            default:
                self?.normalDemo()
            }
        }
    }
    
    func normalDemo() {
        self.readDataFromHttp {[weak self] (items, isSucc) in
            guard isSucc &&  (items != nil) else {
                return
            }
            let miniUIVC =  MiniGalleryViewController()
            miniUIVC.galleryItems = items
            // 设置样式
            miniUIVC.topStyle = .normal
            miniUIVC.bottomStyle = .zoom
            self?.present(miniUIVC, animated: true, completion: {
                
            })
        }
    }
    // 全部Zoom效果
    func allZoomDemo() {
        self.readDataFromHttp {[weak self] (items, isSucc) in
            guard isSucc &&  (items != nil) else {
                return
            }
            let miniUIVC =  MiniGalleryViewController()
            miniUIVC.galleryItems = items
            // 设置样式
            miniUIVC.topStyle = .zoom // 都为zoom
            miniUIVC.bottomStyle = .zoom // 都为zoom
            self?.present(miniUIVC, animated: true, completion: {
                
            })
        }

    }
    // 加入一些自定义的cell
    func customDemo() {
        self.readDataFromHttp {[weak self] (items, isSucc) in
            guard isSucc &&  (items != nil) else {
                return
            }
            let miniUIVC =  MiniGalleryViewController()
            miniUIVC.galleryItems = items
            // 设置样式
            miniUIVC.topStyle = .normal
            miniUIVC.bottomStyle = .zoom
            // 附加2对
            let exItem0 = HorizontalListViewItem(cellClass: ADCollectionViewCell.self, viewModel: nil)
            let exItem1 = HorizontalListViewItem(cellClass: NotificationCollectionViewCell.self.self, viewModel: nil)
            let exItem2 = HorizontalListViewItem(cellClass: HorizontalListViewDefaultCell.self, viewModel: nil)
            let exItem3 = HorizontalListViewItem(cellClass: HotCollectionViewCell.self, viewModel: nil)
            
            miniUIVC.addtionTopItems = [exItem0,exItem1]
            miniUIVC.addtionBottomItems = [exItem2,exItem3]
            self?.present(miniUIVC, animated: true, completion: {
                
            })
        }
    }
    // 从网络中读取
    func readDataFromHttp( handler:@escaping ([GalleryItem]?,Bool)->Void) {
        AF.request("http://private-04a55-videoplayer1.apiary-mock.com/pictures").responseJSON { (response) in
            do {
                let res = try response.result.get() as! [[String: Any]]
                var resArray = [GalleryItem]()
                for dic in res {
                    let item = GalleryItem(videoUrl: dic["videoUrl"] as! String,
                                           imageUrl: dic["imageUrl"] as! String,
                                           id: dic["id"] as! Int)
                    resArray.append(item)
                }
                handler(resArray,true)
            } catch {
                handler(nil,false)
            }
        }
    }

}
