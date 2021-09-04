//
//  DataRaceDispatchQueueViewController.swift
//  DataRaceDispatchQueueViewController
//
//  Created by Kah Seng Lee on 30/08/2021.
//

import UIKit

class DataRaceDispatchQueueViewController: UIViewController {
    
    // MARK: Counter Class
    class Counter {
        
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
        let group = DispatchGroup()

        // Call `addCount()` asynchronously 1000 times
        for _ in 0..<totalCount {
            
            DispatchQueue.global().async(group: group) {
                counter.addCount()
            }
        }

        group.notify(queue: .main) {
            // Dispatch group completed execution
            // Show `count` value on label
            self.statusLabel.text = "\(counter.count)"
        }
        
    }
}
