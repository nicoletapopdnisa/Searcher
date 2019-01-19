//
//  UIImageView+URL.swift
//  Searcher
//
//  Created by user148651 on 1/19/19.
//  Copyright © 2019 user148651. All rights reserved.
//

import Foundation
import UIKit

fileprivate var associatedObjectPointer : UInt8 = 7

extension UIImageView {

    
    var attachedIndexPath: Int {
        get {
         return objc_getAssociatedObject(self, &associatedObjectPointer) as! Int
        }
        set {
            objc_setAssociatedObject(self, &associatedObjectPointer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
}
