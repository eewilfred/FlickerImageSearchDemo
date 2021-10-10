//
//  UICollectionView+Extenstion.swift
//  FlickerImageSearch
//
//  Created by Edwin Wilson on 10/10/2021.
//

import UIKit

extension UICollectionReusableView {

    /// Class name as cell identifier string
    class var identifier: String { return String(describing: self) }

    /// Initialize xib using Class name
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
}
