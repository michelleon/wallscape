//
//  CustomButton.swift
//  Screensaver
//
//  Created by Michelle Leon on 1/7/16.
//  Copyright © 2016 Michelle Leon. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton
{
    private var initialBackgroundColour: UIColor!
    
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        initialBackgroundColour = backgroundColor
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator)
    {
        coordinator.addCoordinatedAnimations(
            {
                if self.focused
                {
                    self.backgroundColor = UIColor.whiteColor()
                    
                    UIView.animateWithDuration(0.2, animations:
                        {
                            self.transform = CGAffineTransformMakeScale(1.1, 1.1)
                        },
                        completion:
                        {
                            finished in
                            
                            UIView.animateWithDuration(0.2, animations:
                                {
                                    self.transform = CGAffineTransformIdentity
                                },
                                completion: nil)
                    })
                }
                else
                {
                    self.backgroundColor = self.initialBackgroundColour
                }
            },
            completion: nil)
    }
}
