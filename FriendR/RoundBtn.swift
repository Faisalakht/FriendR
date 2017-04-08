//
//  RoundBtn.swift
//  FriendR
//
//  Created by Faisal Akhtar on 2017-04-03.
//  Copyright © 2017 Home. All rights reserved.
//
//
//  RoundBtn.swift
//  FriendR
//
//  Created by Faisal Akhtar on 2017-04-01.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit
@IBDesignable


class RoundBtn: UIButton {
    
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            
            
        }
        
        
        
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
            
            
        }
        
        
        
    }
    
    
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
            
            
        }
        
        
        
    }
    
    
    
}
