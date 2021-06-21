//
//  DrawingView.swift
//  DrawingApp
//
//  Created by Karin Prater on 18.06.21.
//

import SwiftUI

struct DrawingView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var drawingDocument = DrawingDocument()
    @State private var deletedLines = [Line]()
    
    @StateObject var selectedColor = UserDefaultColor()
   // @State private var selectedColor: Color = .black
    @SceneStorage("selectedLineWidth") var selectedLineWidth: Double = 1
    
    let engine = DrawingEngine()
    @State private var showConfirmation: Bool = false
    
    var body: some View {
        
        VStack {
            
            HStack {
                ColorPicker("line color", selection: $selectedColor.color)
                    .labelsHidden()
                Slider(value: $selectedLineWidth, in: 1...20) {
                    Text("linewidth")
                }.frame(maxWidth: 100)
                Text(String(format: "%.0f", selectedLineWidth))
                
                Spacer()
                
                Button {
                    let last = drawingDocument.lines.removeLast()
                    deletedLines.append(last)
                } label: {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .imageScale(.large)
                }.disabled(drawingDocument.lines.count == 0)
                
                Button {
                    let last = deletedLines.removeLast()
                    
                    drawingDocument.lines.append(last)
                } label: {
                    Image(systemName: "arrow.uturn.forward.circle")
                        .imageScale(.large)
                }.disabled(deletedLines.count == 0)

                Button(action: {
                   showConfirmation = true
                }) {
                    Text("Delete")
                }.foregroundColor(.red)
                    .confirmationDialog(Text("Are you sure you want to delete everything?"), isPresented: $showConfirmation) {
                        
                        Button("Delete", role: .destructive) {
                            drawingDocument.lines = [Line]()
                            deletedLines = [Line]()
                        }
                    }
                
            }.padding()
            
            
            ZStack {
                Color.white

                ForEach(drawingDocument.lines){ line in
                    DrawingShape(points: line.points)
                        .stroke(line.color, style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                }
            }
            
//        Canvas { context, size in
//
//            for line in drawingDocument.lines {
//
//                let path = engine.createPath(for: line.points)
//
//                context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
//
//            }
//        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ value in
            let newPoint = value.location
            if value.translation.width + value.translation.height == 0 {
                //TODO: use selected color and linewidth
                drawingDocument.lines.append(Line(points: [newPoint],
                                                  color: selectedColor.color, lineWidth: selectedLineWidth))
            } else {
                let index = drawingDocument.lines.count - 1
                drawingDocument.lines[index].points.append(newPoint)
            }
            
        }).onEnded({ value in
            if let last = drawingDocument.lines.last?.points, last.isEmpty {
                drawingDocument.lines.removeLast()
            }
        })
        
        )
            
        }
        
        .onChange(of: scenePhase) { newValue in
            if newValue == .background {
                drawingDocument.save()
            }
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
