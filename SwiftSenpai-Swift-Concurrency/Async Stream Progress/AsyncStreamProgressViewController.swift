//
//  AsyncStreamProgressViewController.swift
//  SwiftSenpai-Swift-Concurrency
//
//  Created by Kah Seng Lee on 15/07/2023.
//

import UIKit

class AsyncStreamProgressViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBar.progress = 0
        statusLabel.text = ""
    }
    
    @IBAction func starButtonTapped(_ sender: Any) {
        
        let totalFile = 50
        
        // Generate file objects
        let files = (1...totalFile).map { File(name: "Image_\($0).jpg") }

        // Start download
        let downloaderStream = FileDownloader.download(files)
        
        Task {
            var downloadedFile = 0
            for await filename in downloaderStream {

                downloadedFile += 1
                
                // Update progress bar
                progressBar.progress = Float(downloadedFile) / Float(totalFile)
                
                // Update status label
                statusLabel.text = "Downloaded \(filename)"
            }
            
            statusLabel.text = "Download completed"
        }
        
    }
}
