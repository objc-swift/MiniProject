//
//  PageSyner.swift
//  MiniProject
//
//  Created by yxyyxy on 2019/6/30.
//  Copyright © 2019 yxy. All rights reserved.
//

import Foundation
import UIKit
protocol PageObject: class{
    var isOriginSender:Bool {set get}
    func initPageObject( pageChangeHandler:@escaping (CGFloat,PageObject)->Void ,
                         becomeOriginSenderHandler:@escaping (PageObject)->Void )->Void
    func scrollToPage(page:CGFloat)->Void
}
class PageSyner {
    var pageObjects:[PageObject] = [PageObject]()
    func appendNewPageObject(pageObject:PageObject) {
        self.pageObjects.append(pageObject)
        pageObject.initPageObject(pageChangeHandler: pageChange(page:sender:),becomeOriginSenderHandler: becomeOriginSender(originSender:))
    }
    private func pageChange(page:CGFloat,sender:PageObject) -> Void {
        
        guard sender.isOriginSender else {
            // 只接受原始发送者的数据
            return
        }
        print(page)
        for pageObject in self.pageObjects {
            if sender === pageObject {
                continue
            }
            pageObject.scrollToPage(page: page)
        }
    }
    private func becomeOriginSender(originSender:PageObject) {
        originSender.isOriginSender = true
        for pageObject in self.pageObjects {
            if  pageObject === originSender {
                continue
            }
            pageObject.isOriginSender = false
        }
    }
}
