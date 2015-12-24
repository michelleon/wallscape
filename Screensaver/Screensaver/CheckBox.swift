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

    //    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    //        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
    //        //First, we need to check if we are the current focus
    //        //Fortunately, the UIFocusUpdateContext object provides the nextFocusedView method
    //        //Let's check if we are required to be focused
    //        if(context.nextFocusedView == self){
    //            //At this point, the view has to become focused.
    //            //Let's use the coordinator to animate the changes
    //            coordinator.addCoordinatedAnimations({
    //                //Like we previously mentionned, we would like to respond to focus by changing colors
    //                self._label!.textColor = UIColor.blackColor()
    //                self._imageView!.image = self.getBackImageOfColor(UIColor.blackColor())
    //                //Also, we want to make the items bigger
    //                self._label!.font = self._label!.font.fontWithSize(40)
    //                self._imageView!.frame = CGRect(x: 0, y: 0, width: self._imageView!.bounds.width * 1.25, height: self._imageView!.bounds.height * 1.25)
    //                //Lets reposition the views correctly now that we modified their size
    //                self._imageView!.center = CGPoint(x: self._imageView!.bounds.width/2, y: self.frame.origin.y)
    //                self._label!.center = CGPoint(x: self._imageView!.bounds.width + self._label!.bounds.width/2, y: self.frame.origin.y)
    //                //Finally we gently ask the view to redraw itself
    //                self.layoutIfNeeded()
    //
    //                },
    //                completion: nil
    //            )
    //        }
    //            //We also need to respond to focus lost
    //            //Again fortunately, the UIFocusUpdateContext object provides the previouslyFocusedView method
    //            //Let's check if we lost the focus
    //        else if(context.previouslyFocusedView == self) {
    //            //At this point we have lost the focus
    //            //Let's change the UI back to it's "normal" state
    //            coordinator.addCoordinatedAnimations({
    //                self._label!.textColor = UIColor.whiteColor()
    //                self._imageView!.image = self.getBackImageOfColor(UIColor.whiteColor())
    //
    //                self._label!.font = self._label!.font.fontWithSize(30)
    //                self._imageView!.frame = CGRect(x: 0, y: 0, width: self._imageView!.bounds.width / 1.25, height: self._imageView!.bounds.height / 1.25)
    //                self._imageView!.center = CGPoint(x: self._imageView!.bounds.width/2, y: self.frame.origin.y)
    //                self._label!.center = CGPoint(x: self._imageView!.bounds.width + self._label!.bounds.width/2, y: self.frame.origin.y)
    //                
    //                self.layoutIfNeeded()
    //                },
    //                completion: nil
    //            )
    //        }
    //    }

}
