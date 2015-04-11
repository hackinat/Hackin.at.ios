//
//  SendFriendshipRequestButton.swift
//  Hackin.at
//
//  Created by Prateek on 3/13/15.
//  Copyright (c) 2015 Prateek Dayal. All rights reserved.
//

import UIKit
import PureLayout

class FriendshipButtonSet: UIView {
    
    var toBeFriend: Hacker!
    var button: UIButton!
    
    init(toBeFriend: Hacker){
        super.init(frame: CGRectZero)
        self.toBeFriend = toBeFriend
        renderButton()
    }
    
    func renderButton(){
        button = Helpers.friendshipButton(toBeFriend)
        self.frame = button.frame
        self.addSubview(button)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        button.autoPinEdgesToSuperviewMargins()
    }
    
}

class SendFriendshipRequestButton: UIButton {
    
    var toBeFriend: Hacker!
    
    var title: String {
        return ""
    }
    
    var disabledTitle: String {
        return ""
    }
    
    var requestSent = false
    
    convenience init(toBeFriend: Hacker){
        self.init()
        self.toBeFriend = toBeFriend
        renderButton()
        setupTargetAction()
        sizeToFit()
    }
    
    func renderButton(){
        setTitle(title, forState: UIControlState.Normal)
        setTitle(disabledTitle, forState: UIControlState.Disabled)
    }
    
    func setupTargetAction(){
       addTarget(self, action: "buttonPressed", forControlEvents: UIControlEvents.TouchUpInside)
    }
   
}