//
//  ImageDisplayerCell.swift
//  MiniProject
//
//  Created by yxyyxy on 2019/7/2.
//  Copyright © 2019 yxy. All rights reserved.
//

import UIKit
import Kingfisher
class ImageDisplayerCell: UICollectionViewCell,HorizontalListViewCell {
 
    
    @IBOutlet weak var imageView: UIImageView!
    var viewModel: HorizontalListViewCellViewModel? {
        didSet {
            if let vm = viewModel {
                let item = vm.entity as! GalleryItem
                let url = URL(string: item.imageUrl)
                self.imageView.kf.setImage(with: url)
            }
           
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = Color.red.cgColor
        // Initialization code
    }

}
