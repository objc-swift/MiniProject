//
//  ZoomCollectionViewLayout.swift
//  MiniProject
//
//  Created by yxyyxy on 2019/6/30.
//  Copyright © 2019 yxy. All rights reserved.
//

import UIKit
private let minSpan:CGFloat = 20.0
class ZoomCollectionViewLayout: UICollectionViewFlowLayout {
    var itemWidth:CGFloat {
        return (self.collectionView?.frame.width ?? 0) * 0.6
    }
    var itemHeight:CGFloat {
        return (self.collectionView?.frame.height ?? 0)
    }
    var paddingLeftAndRight:CGFloat {
        return ((self.collectionView?.frame.width ?? 0) - self.itemWidth) / 2.0
    }
    override func prepare() {
        super.prepare()
        self.scrollDirection = .horizontal
        self.itemSize = CGSize(width: self.itemWidth,height: self.itemHeight)
        self.minimumLineSpacing = minSpan
        self.sectionInset = UIEdgeInsets(top: 0, left: paddingLeftAndRight, bottom: 0, right: paddingLeftAndRight)
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        guard attributes != nil else {
            return nil
        }
        if let collectionView = self.collectionView {
            let coView_w = collectionView.frame.size.width
            let center_x = collectionView.contentOffset.x + collectionView.frame.size.width / 2.0
            let total_w = (coView_w + self.itemWidth) / 2.0
            for attr in attributes! {
                let distanceFromCenterX = abs(attr.center.x - center_x)
                let persent = distanceFromCenterX / total_w
                if (persent > 1)  {
                    //已经移除
                    continue
                }
                let scale = abs(cos(persent * CGFloat(Double.pi / 4.0)));
                attr.transform = CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: 0, ty: 0)
                if distanceFromCenterX == 0 {
                    print("-------")
                }
            }
        }
        return attributes
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
