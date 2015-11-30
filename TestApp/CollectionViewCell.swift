//
//  CollectionViewCell.swift
//  TestApp
//
//  Created by Kabir Gogia on 11/27/15.
//  Copyright © 2015 Kabir. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    var textLabel: UILabel?
    var imageView: UIImageView?
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLabel = UILabel(frame: CGRect(x: 0, y: 80, width: self.frame.width, height: 25))
        imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 75, height: 75))
        self.addSubview(textLabel!)
        self.addSubview(imageView!)
    }
    
}
