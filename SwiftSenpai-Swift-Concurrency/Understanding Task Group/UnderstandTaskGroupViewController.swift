//
//  UnderstandTaskGroupViewController.swift
//  SwiftSenpai-Swift-Concurrency
//
//  Created by Kah Seng Lee on 12/10/2021.
//

import UIKit

class UnderstandTaskGroupViewController: UIViewController {
    
    struct SlowDivideOperation {
        
        let name: String
        let a: Double
        let b: Double
        let sleepDuration: UInt64
        
        func execute() async -> Double {
            
            // Sleep for x seconds
            try? await Task.sleep(nanoseconds: sleepDuration * 1_000_000_000)
            
            let value = a / b
            return value
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func taskGroupButtonTapped(_ sender: Any) {
        
        let operations = [
            SlowDivideOperation(name: "operation-0", a: 5, b: 1, sleepDuration: 5),
            SlowDivideOperation(name: "operation-1", a: 14, b: 7, sleepDuration: 1),
            SlowDivideOperation(name: "operation-2", a: 8, b: 2, sleepDuration: 3),
        ]
        
        Task {
            
            print("Task start   : \(Date())")
            
            let allResults = await withTaskGroup(of: (String, Double).self,
                                                 returning: [String: Double].self,
                                                 body: { taskGroup in
                
                // Loop through operations array
                for operation in operations {
                    
                    // Add child task to task group
                    taskGroup.addTask {
                        
                        // Execute slow operation
                        let value = await operation.execute()
                        
                        // Return child task result
                        return (operation.name, value)
                    }
                    
                }
                
                // Collect results of all child task in a dictionary
                var childTaskResults = [String: Double]()
                for await result in taskGroup {
                    // Set operation name as key and operation result as value
                    childTaskResults[result.0] = result.1
                }
                
                // All child tasks finish running, thus return task group result
                return childTaskResults
            })
            
            print("Task end     : \(Date())")
            print("allResults   : \(allResults)")
            
        }
        
    }
}


