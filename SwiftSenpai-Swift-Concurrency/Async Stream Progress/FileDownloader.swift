//
//  FileDownloader.swift
//  SwiftSenpai-Swift-Concurrency
//
//  Created by Kah Seng Lee on 15/07/2023.
//

import Foundation

struct File {
    
    let name: String
    
    func performDownload() async {
        
        // Sleep for a random amount of time to emulate the wait required to download a file
        let downloadTime = Double.random(in: 0.03...0.5)
        try? await Task.sleep(for: .seconds(downloadTime))
    }
}

final class FileDownloader {
    
    static func download(_ files: [File]) -> AsyncStream<String> {
        
        // Init AsyncStream with element type = `String`
        let stream = AsyncStream(String.self) { continuation in
            
            Task {
                for file in files {
                    
                    // Download the file
                    await file.performDownload()
                    
                    // Yield the element (filename) when download is completed
                    continuation.yield(file.name)
                }
                
                // All files are downloaded
                // Call the continuation’s finish() method when there are no further elements to produce
                continuation.finish()
            }
        }
        
        return stream
    }
    
    
    static func download(_ files: [File], completion: (String) -> Void) {
        
        // Download each file and trigger completion handler
        // ...
        // ...
    }
}
