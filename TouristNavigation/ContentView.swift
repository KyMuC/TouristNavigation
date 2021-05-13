//
//  ContentView.swift
//  TouristNavigation
//
//  Created by Mikhail Kudimov on 11.05.2021.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        //let imageBuffer : CVImageBuffer = arView.session.currentFrame!.capturedImage
        
        //arView.
        
        // Load the "Box" scene from the "Experience" Reality File
        //let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        //arView.scene.anchors.append(boxAnchor)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            arView.rayCastingFunction(point: CGPoint(x: 0.5, y: 0.5))
        }
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

extension ARView {
    
    func rayCastingFunction(point: CGPoint) {
        
        guard let raycastQuery = self.makeRaycastQuery(from: point,
                                                       allowing: .existingPlaneInfinite,
                                                       alignment: .horizontal) else {
            print("failed first")
            return
        }
        
        guard let result = self.session.raycast(raycastQuery).first else {
            print("failed")
            return
        }
        
        let transformation = Transform(matrix: result.worldTransform)
        
        let stickyNote = StickyNoteEntity(classification: "Index")
        
        stickyNote.transform = transformation
        
        let raycastAnchor = AnchorEntity(raycastResult: result)
        raycastAnchor.addChild(stickyNote)
        self.scene.addAnchor(raycastAnchor)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
