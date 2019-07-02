//
//  HorizontalListViewDefaultCell.swift
//  MiniProject
//
//  Created by yxyyxy on 2019/6/28.
//  Copyright © 2019 yxy. All rights reserved.
//

import UIKit

class HorizontalListViewDefaultCell: UICollectionViewCell,HorizontalListViewCell {
    
    @IBOutlet weak var descLabel: UILabel!
    var viewModel: HorizontalListViewCellViewModel? {
        didSet {
            if let vm = viewModel {
                let desc = vm.entity as! String
                self.descLabel.text = desc
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    deinit {
        
    }

}
