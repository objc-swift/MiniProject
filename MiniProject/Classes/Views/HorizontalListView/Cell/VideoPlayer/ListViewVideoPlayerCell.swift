//
//  ListViewVideoPlayerCell.swift
//  MiniProject
//
//  Created by yxyyxy on 2019/6/29.
//  Copyright © 2019 yxy. All rights reserved.
//
import UIKit
import AVKit
class ListViewVideoPlayerCell: UICollectionViewCell,HorizontalListViewCell {
    var avPlayerView:AVPlayerView!
    var viewModel: HorizontalListViewCellViewModel? {
        didSet {
            if let vm = viewModel {
                let item = vm.entity as! GalleryItem
                avPlayerView.urlString = item.videoUrl
                avPlayerView.play()
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avPlayerView = AVPlayerView()
        self.contentView.addSubview(self.avPlayerView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.avPlayerView.frame = self.bounds
    }
}
