//
//  Line.swift
//  DrawingApp
//
//  Created by Karin Prater on 18.06.21.
//

import Foundation
import SwiftUI

struct Line: Identifiable {
    
    var points: [CGPoint]
    var color: Color
    var lineWidth: CGFloat

    let id = UUID()
}
