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
        for _ in 1...10 {
            let newone = HorizontalListViewItem(cellClass: nil, viewModel: HorizontalListViewCellViewModel())
            self.topView.listItems.append(newone)
        }
        self.topView.refresh()
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
