//
//  TransitionCoordinator+Inter.swift
//  LMFloatingBar
//
//  Created by 刘明 on 2019/3/23.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

extension UIViewControllerTransitionCoordinator
{
    public func notifyWhenInteractionCancelled(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {
        if #available(iOS 10.0, *) {
            notifyWhenInteractionChanges { (context) in
                if context.initiallyInteractive
                    && !context.isInteractive
                    && !context.isCancelled {
                    handler(context)
                }
            }
        } else {
            notifyWhenInteractionEnds { (context) in
                if context.initiallyInteractive
                    && !context.isInteractive
                    && !context.isCancelled {
                    handler(context)
                }
            }
        }
    }
}
