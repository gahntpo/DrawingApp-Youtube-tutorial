//
//  DrawingShape.swift
//  DrawingApp
//
//  Created by Karin Prater on 18.06.21.
//

import SwiftUI

struct DrawingShape: Shape {
    let points: [CGPoint]
    let engine = DrawingEngine()
    func path(in rect: CGRect) -> Path {
        engine.createPath(for: points)
    }
}

//struct DrawingShape_Previews: PreviewProvider {
//    static var previews: some View {
//        DrawingShape()
//    }
//}
