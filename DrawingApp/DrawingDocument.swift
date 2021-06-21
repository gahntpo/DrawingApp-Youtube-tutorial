//
//  DrawingDocument.swift
//  DrawingApp
//
//  Created by Karin Prater on 20.06.21.
//

import Foundation


class DrawingDocument: ObservableObject {
   
    
    @Published var lines = [Line]() {
        didSet {
            save()
        }
    }
    
    init() {
        //load the data
        if FileManager.default.fileExists(atPath: url.path),
           let data = try? Data(contentsOf: url) {
            
            let decoder = JSONDecoder()
            do {
                let lines = try decoder.decode([Line].self, from: data)
                self.lines = lines
            } catch {
                print("decoding error \(error)")
            }
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(self.lines)
        
        do {
            
            try data?.write(to: self.url)
        }catch {
            print("error saving \(error)")
        }
    }
    
    var url: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("Document").appendingPathExtension("json")
    }
    
}
