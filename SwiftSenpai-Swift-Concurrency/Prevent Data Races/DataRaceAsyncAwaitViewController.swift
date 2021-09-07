//
//  DataRaceAsyncAwaitViewController.swift
//  DataRaceAsyncAwaitViewController
//
//  Created by Kah Seng Lee on 30/08/2021.
//

import UIKit

class DataRaceAsyncAwaitViewController: UIViewController {

    // MARK: Counter Class
    class Counter {
        
        var count = 0
        
        func addCount() {
            count += 1
        }
    }
    
    // MARK: Implementation
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func startButtonTapped(_ sender: Any) {
        
        let totalCount = 1000
        let counter = Counter()

        // Create a parent task
        Task {
            
            // Create a task group
            await withTaskGroup(of: Void.self, body: { taskGroup in
                
                for _ in 0..<totalCount {
                    // Create child task
                    taskGroup.addTask {
                        counter.addCount()
                    }
                }
            })
            
            statusLabel.text = "\(counter.count)"
        }
   
    }
}
