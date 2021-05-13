//
//  ContentView.swift
//  TouristNavigation
//
//  Created by Mikhail Kudimov on 11.05.2021.
//

import SwiftUI
import RealityKit
import ARKit

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
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        arView.session.run(config, options: [])
        
        arView.setupGestures()
        
        // Load the "Box" scene from the "Experience" Reality File
        //let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        //arView.scene.anchors.append(boxAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

extension ARView {
    
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        guard let touchInView = sender?.location(in: self) else {
            return
        }
        
        rayCastingFunction(point: touchInView)
        _ = self.entities(at: touchInView)
        
    }
    
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
