//
//  ObjectDetectionService.swift
//  TouristNavigation
//
//  Created by Mikhail Kudimov on 12.05.2021.
//

import Foundation
import SwiftUI

class ObjectDetectionService {
    
    private var completion: ((Result<Response, Error>) -> Void)?
    
    func detect (on request: Request, completion: @escaping (Result<Response, Error>) -> Void) {
        self.completion = completion
        
        
    }
}

private extension ObjectDetectionService {
    
    func handleResponse() {
        
    }
    
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
        let boundingBox: CGRect
        let classification: String
    }
}
