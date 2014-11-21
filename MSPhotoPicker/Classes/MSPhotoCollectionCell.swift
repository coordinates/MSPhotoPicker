//
//  MSPhotoCollectionCell.swift
//  MSPhotoPickerController
//
//  Created by Masayoshi Ukida on 2014/11/19.
//  Copyright (c) 2014年 Masyaoshi Ukida. All rights reserved.
//

import UIKit

public class MSPhotoCollectionCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!;
    @IBOutlet var checkedImageView: UIImageView!;
    
//    override init?(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
    override public var selected: Bool {
        didSet {
            self.checkedImageView.hidden = !self.selected
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.checkedImageView.hidden = true
    }
    
    override public func prepareForReuse() {
        self.checkedImageView.hidden = true
    }
}
