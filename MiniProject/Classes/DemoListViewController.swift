//
//  DemoListViewController.swift
//  MiniProject
//
//  Created by yxyyxy on 2019/6/29.
//  Copyright © 2019 yxy. All rights reserved.
//

import UIKit

class DemoListViewController: UIViewController {

    @IBOutlet weak var topView: HorizontalListView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let addrs = ["https://media.giphy.com/media/l0ExncehJzexFpRHq/giphy.mp4","https://media.giphy.com/media/26gsqQxPQXHBiBEUU/giphy.mp4","https://media.giphy.com/media/oqLgjAahmDPvG/giphy.mp4","https://media.giphy.com/media/d1E1szXDsHUs3WvK/giphy.mp4","https://media.giphy.com/media/OiJjUsdAb11aE/giphy.mp4","https://media.giphy.com/media/4My4Bdf4cakLu/giphy.mp4"]
        for addr in addrs {
            let newone = HorizontalListViewItem(cellClass: ListViewVideoPlayerCell.self, viewModel: HorizontalListViewCellViewModel(entity: addr as AnyObject))
            self.topView.listItems.append(newone)
        }
        self.topView.refresh()
        // Do any additional setup after loading the view.
    }


}
