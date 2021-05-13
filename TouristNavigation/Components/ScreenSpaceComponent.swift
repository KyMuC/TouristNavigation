//
//  ScreenSpaceComponent.swift
//  TouristNavigation
//
//  Created by Mikhail Kudimov on 12.05.2021.
//

import Foundation
import ARKit
import RealityKit


struct ScreenSpaceComponent: Component {
    var view: StickyNoteView?

    var shouldAnimate = false

    var projection: Projection?
}

struct Projection {
    
    let projectedPoint: CGPoint
    let isVisible: Bool
    
}
