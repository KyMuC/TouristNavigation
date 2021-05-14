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
    
    let objectDetectionService = ObjectDetectionService()
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config, options: [])
        
        arView.addCoaching()
        //arView.setupGestures()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            guard let capturedImage = arView.session.currentFrame?.capturedImage else { return }
            objectDetectionService.detect(on: .init(pixelBuffer: capturedImage)) { result in
//                [weak self] result in
//
//                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    arView.rayCastingMethod(classification: response.classification, point: response.centerPoint)
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        }
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

extension ARView{
    
    func setupGestures() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        guard let touchInView = sender?.location(in: self) else {
            return
        }
        
        rayCastingMethod(classification: "Index", point: touchInView)
    }
    
    func rayCastingMethod(classification: String, point: CGPoint) {
        
        guard let raycastQuery = self.makeRaycastQuery(from: point,
                                                       allowing: .existingPlaneInfinite,
                                                       alignment: .any) else {
            return
        }
        
        guard let result = self.session.raycast(raycastQuery).first else {return}
        
        let transformation = Transform(matrix: result.worldTransform)
        
        //        let note = StickyNoteEntity(classification: "Index")
        //
        //        note.transform = transformation
        //
        //        let raycastAnchor = AnchorEntity(raycastResult: result)
        //        raycastAnchor.addChild(note)
        //
        //        self.scene.addAnchor(raycastAnchor)
        
        let note = TextEntity(classification: classification)
        self.installGestures(.all, for: note)
        note.transform = transformation
        
        let raycastAnchor = AnchorEntity(raycastResult: result)
        raycastAnchor.addChild(note)
        
        self.scene.addAnchor(raycastAnchor)
    }
}

extension ARView: ARCoachingOverlayViewDelegate {
    
    func addCoaching() {
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        coachingOverlay.goal = .horizontalPlane
        self.addSubview(coachingOverlay)
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        coachingOverlayView.activatesAutomatically = false
    }
    
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
