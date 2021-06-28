//
//  Label.swift
//  SolarSystem
//
//  Created by Enes Yavuz on 29.10.2020.
//  Copyright © 2020 Enes Yavuz. All rights reserved.
//

import Foundation
import SkeletonView
extension UILabel{
    func skeletonLabel(text:String){
        self.isSkeletonable=true
        self.linesCornerRadius=10
        self.skeletonCornerRadius=15
        let gradient = SkeletonGradient(baseColor: UIColor.silver)
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        self.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        self.text=text
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            self.hideSkeleton()
        }
    }
  
           
   
}
