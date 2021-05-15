//
//  ObjectDetectionService.swift
//  TouristNavigation
//
//  Created by Mikhail Kudimov on 12.05.2021.
//

import SwiftUI
import VideoToolbox
import Firebase

class ObjectDetectionService {
    
    lazy var functions = Functions.functions()
    
    private var completion: ((Result<Response, Error>) -> Void)?
    
    func detect (on request: Request, completion: @escaping (Result<Response, Error>) -> Void) {
        self.completion = completion
        
        let uiImage = UIImage(pixelBuffer: request.pixelBuffer)
        guard let imageData = uiImage!.jpegData(compressionQuality: 1.0) else { return }
        let base64encodedImage = imageData.base64EncodedString()
        
        let requestData = [
            "image": ["content": base64encodedImage],
            "features": [["maxResults": 5, "type": "LANDMARK_DETECTION"]]
        ] as [String : Any]
        
        //print(base64encodedImage)
        functions.httpsCallable("annotateImage").call(requestData) { (result, error) in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    print("Code: \(error.code)\nMessage: \(message)\nDetails: \(details)")
                }
                // ...
            }
            
            guard let data = result?.data as? [Any] else {return}
            
            // Function completed succesfully
            if let labelArray = (data[0] as? [String: Any])?["landmarkAnnotations"] as? [[String:Any]] {
                
                let labelObj = labelArray.max { a, b in
                    let aScore = a["score"] as! Double
                    let bScore = b["score"] as! Double
                    return aScore < bScore
                }
                //for labelObj in labelArray {
                guard let landmarkName = labelObj?["description"] else {
                    self.complete(.failure(RecognitionError.requestError))
                    print("No description")
                    return
                }
                let entityId = labelObj!["mid"]
                let score = labelObj!["score"]
                let bounds = labelObj!["boundingPoly"]
                
                
                guard let vertices = (bounds as? [String:Any])?["vertices"] as? [[String:Double]] else {
                    self.complete(.failure(RecognitionError.requestError))
                    print("No vertices")
                    return
                }
                
                let centerPoint = CGPoint(x: (vertices[0]["x"]! + vertices[1]["x"]!)/2, y: (vertices[0]["y"]! + vertices[2]["y"]!)/2)
                
                let response = Response(centerPoint: centerPoint, classification: landmarkName as! String)
                self.complete(.success(response))
                // Multiple locations are possible, e.g., the location of the depicted
                // landmark and the location the picture was taken.
//                guard let locations = labelObj!["locations"] as? [[String: [String: Any]]] else { continue }
//                for location in locations {
//                    let latitude = location["latLng"]?["latitude"]
//                    let longitude = location["latLng"]?["longitude"]
//                }
                //}
            }
        }
    }
}

private extension ObjectDetectionService {
    
    func complete(_ result: Result<Response, Error>) {
        DispatchQueue.main.async {
            self.completion?(result)
            self.completion = nil
        }
    }
}

enum RecognitionError: Error {
    case requestError
    case resultIsEmpty
    case lowConfidence
}

extension ObjectDetectionService {
    struct Request {
        let pixelBuffer: CVPixelBuffer
    }
    
    struct Response {
        let centerPoint: CGPoint
        let classification: String
    }
}

extension UIImage {
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        
        guard let cgImage = cgImage else {
            return nil
        }
        
        self.init(cgImage: cgImage)
    }
}
