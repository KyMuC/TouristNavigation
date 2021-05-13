//
//  StickyNoteEntity.swift
//  TouristNavigation
//
//  Created by Mikhail Kudimov on 12.05.2021.
//

import ARKit
import RealityKit

class StickyNoteEntity: Entity, HasModel, HasAnchoring {
    
    required init(classification: String) {
        super.init()
        self.components[ModelComponent] = ModelComponent(mesh: .generateText(classification, extrusionDepth: 0.1, font: .systemFont(ofSize: 2), containerFrame: .zero, alignment: .left, lineBreakMode: .byTruncatingTail), materials: [SimpleMaterial(color: .white, isMetallic: false)])
    }
    
    convenience init(classification: String, position: SIMD3<Float>) {
        self.init(classification: classification)
        self.position = position
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
