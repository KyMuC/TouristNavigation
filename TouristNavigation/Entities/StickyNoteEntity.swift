//
//  StickyNoteEntity.swift
//  TouristNavigation
//
//  Created by Mikhail Kudimov on 12.05.2021.
//

import Foundation
import ARKit
import RealityKit

class StickyNoteEntity: Entity, HasModel, HasAnchoring {
    
    init(classification: String) {
        super.init()
        self.components[ModelComponent] = ModelComponent(mesh: .generateText(classification, extrusionDepth: 0.1, font: .systemFont(ofSize: 2), containerFrame: .zero, alignment: .left, lineBreakMode: .byTruncatingTail), materials: [SimpleMaterial(color: .white, isMetallic: false)])
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
