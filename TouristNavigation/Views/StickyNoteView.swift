//
//  StickyNoteView.swift
//  TouristNavigation
//
//  Created by Mikhail Kudimov on 12.05.2021.
//

import SwiftUI

struct StickyNoteView: View {
    
    var classification: String
    
    weak var stickyNote: StickyNoteEntity!
    
    var body: some View {
        Text(classification)
    }
}

struct StickyNoteView_Previews: PreviewProvider {
    static var previews: some View {
        StickyNoteView(classification: "")
    }
}
