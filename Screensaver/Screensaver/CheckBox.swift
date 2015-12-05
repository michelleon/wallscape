//
//  CheckBox.swift
//  Screensaver
//
//  Created by Michelle Leon on 12/4/15.
//  Copyright © 2015 Michelle Leon. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
    // Images
    let checkedImage = UIImage(named: "checked_box_2.png")
    let uncheckedImage = UIImage(named: "unchecked_box_2.png")
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(uncheckedImage, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }

}
