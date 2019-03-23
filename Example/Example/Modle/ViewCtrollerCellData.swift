//
//  ViewCtrollerCellData.swift
//  Example
//
//  Created by 刘明 on 2019/3/23.
//  Copyright © 2019 刘明. All rights reserved.
//

import UIKit

let DefaultCellData: [ViewCtrollerCellData] = [
    ViewCtrollerCellData(ViewController.Constant.Segue.NoInteractive, .photo1),
    ViewCtrollerCellData(ViewController.Constant.Segue.Interactive, .photo2),
    ViewCtrollerCellData(ViewController.Constant.Segue.FloatingAble, .photo3),
    ViewCtrollerCellData(ViewController.Constant.Segue.FloatingAble, .photo4),
    ViewCtrollerCellData(ViewController.Constant.Segue.FloatingAble, .photo5)]


public struct ViewCtrollerCellData {
    
    public enum CellImage: String {
        case photo1     = "photo1"
        case photo2     = "photo2"
        case photo3     = "photo3"
        case photo4     = "photo4"
        case photo5     = "photo5"
    }
    
    public let title: String
    public let image: CellImage
    
    public init(_ title: String,
                _ image: CellImage) {
        self.title = title
        self.image = image
    }
}

extension ViewCtrollerCellData.CellImage {
    
    var nameOfImage: String {
        return rawValue
    }
    
    public var backgroundImage: UIImage? {
        return UIImage(named: nameOfImage)
    }
    
    public var imageForFloatingBar: UIImage? {
        switch self {
        case .photo1, .photo2, .photo3:
            return nil
        default:
            return UIImage(named: nameOfImage + "_bar")
        }
    }
}
