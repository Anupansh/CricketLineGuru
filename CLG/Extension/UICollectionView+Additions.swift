//
//  UICollectionView+Additions.swift
//  Extras
//
//  Created by Anmol's Macbook Air on 12/06/18.
//  Copyright © 2018 Girijesh Kumar. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    // Register nib on UICollectionView...
    func register(nib nibName:String) {
        
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: nibName)
    }
    
    // Register multiple nib at once
    func registerMultiple(nibs arrayNibs:[String]) {
        
        for nibName in arrayNibs {
            register(nib: nibName)
        }
    }
}
