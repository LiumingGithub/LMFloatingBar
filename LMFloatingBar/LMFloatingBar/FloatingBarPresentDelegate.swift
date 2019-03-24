//
//  FloatingBarPresentDelegate.swift
//  LMFloatingBar
//
//  Created by 刘明 on 2019/3/24.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

public protocol FloatingBarPresentHandler {
    
    /// 将要在返回UIViewController 上 present presentedVC
    func willReShow(_ keepAble: AnyFloatingKeepAble) -> UIViewController?
}

