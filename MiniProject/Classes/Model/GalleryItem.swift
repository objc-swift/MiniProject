//
//  GalleryItem.swift
//  MiniProject
//
//  Created by yxyyxy on 2019/7/2.
//  Copyright © 2019 yxy. All rights reserved.
//

import Foundation
class GalleryItem {
    var videoUrl:String!
    var imageUrl:String!
    var id:Int!
    init(videoUrl:String ,imageUrl:String,id:Int) {
        self.videoUrl = videoUrl
        self.imageUrl = imageUrl
        self.id = id
    }
}
