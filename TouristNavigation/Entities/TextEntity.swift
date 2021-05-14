//
//  CustomBox.swift
//  RealityKitCollisionsAndPhysics
//
//  Created by Anupam Chugh on 14/01/20.
//  Copyright © 2020 iowncode. All rights reserved.
//

import SwiftUI
import RealityKit
import Combine
import ARKit

class TextEntity: Entity, HasModel, HasAnchoring, HasCollision {
    
    var collisionSubs: [Cancellable] = []
    
    required init(classification: String) {
        super.init()
        
//        self.components[CollisionComponent] = CollisionComponent(
//            shapes: [.generateBox(size: [0.05,0.05,0.05])],
//            mode: .trigger,
//            filter: CollisionFilter(group: CollisionGroup(rawValue: 1), mask: CollisionGroup(rawValue: 1))
//        )
        
        
        self.components[ModelComponent] = ModelComponent(
            mesh: .generateText(classification, extrusionDepth: TextElements().extrusionDepth, font: TextElements().font, containerFrame: .zero, alignment: .center, lineBreakMode: .byTruncatingTail),
            materials: [SimpleMaterial(color: TextElements().colour, isMetallic: false)]
        )
    }
    
    convenience init(classification: String, position: SIMD3<Float>) {
        self.init(classification: classification)
        self.position = position
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

struct TextElements{

  let extrusionDepth: Float = 0.001
  let font: MeshResource.Font = MeshResource.Font.systemFont(ofSize: 0.05, weight: .bold)
  let colour: UIColor = .white

}
