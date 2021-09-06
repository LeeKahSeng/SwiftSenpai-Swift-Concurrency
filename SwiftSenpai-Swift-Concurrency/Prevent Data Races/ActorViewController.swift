//
//  ActorViewController.swift
//  ActorViewController
//
//  Created by Kah Seng Lee on 30/08/2021.
//

import UIKit

class ActorViewController: UIViewController {

    // MARK: Counter Actor
    actor Counter {
        
        private(set) var count = 0
        
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
                        await counter.addCount()
                    }
                }
            })
            
            statusLabel.text = "\(await counter.count)"
        }
   
    }

}
