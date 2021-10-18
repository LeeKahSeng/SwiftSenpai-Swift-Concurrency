//
//  UnderstandTaskGroupViewController.swift
//  SwiftSenpai-Swift-Concurrency
//
//  Created by Kah Seng Lee on 12/10/2021.
//

import UIKit

class UnderstandTaskGroupViewController: UIViewController {
    
    struct DivideTask {
        
        let name: String
        let a: Double
        let b: Double
        let sleepDuration: UInt64
        
        func execute() async -> Double {
            
            // Sleep for x seconds
            await Task.sleep(sleepDuration * 1_000_000_000)
            
            let value = a / b
            return value
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func asyncLetButtonTapped(_ sender: Any) {
        
        let tasks = [
            DivideTask(name: "task-0", a: 5, b: 1, sleepDuration: 5),
            DivideTask(name: "task-1", a: 14, b: 7, sleepDuration: 1),
            DivideTask(name: "task-2", a: 8, b: 2, sleepDuration: 3),
        ]
        
        Task {
            
            print("Task start   : \(Date())")
            
            async let result0 = tasks[0].execute()
            async let result1 = tasks[1].execute()
            async let result2 = tasks[2].execute()
            
            // Create a dictionary with all the result
            let allResults = await [tasks[0].name: result0,
                                    tasks[1].name: result1,
                                    tasks[2].name: result2]
            
            print("Task end     : \(Date())")
            print("allResults   : \(allResults)")
            
        }
    }
    
    @IBAction func taskGroupButtonTapped(_ sender: Any) {
        
        let tasks = [
            DivideTask(name: "task-0", a: 5, b: 1, sleepDuration: 5),
            DivideTask(name: "task-1", a: 14, b: 7, sleepDuration: 1),
            DivideTask(name: "task-2", a: 8, b: 2, sleepDuration: 3),
        ]
        
        Task {
            
            print("Task start   : \(Date())")
            
            // NOTE: Define child task return type & task group return type (do not mix up)
            // NOTE: `body` is a closure that take taskGroup & return some value (if no return result then no need `-> [String: Double]`
            // NOTE: Explain what is task group
            
            let allResults = await withTaskGroup(of: (String, Double).self, returning: [String: Double].self, body: { taskGroup in
                
//            let allResults = await withTaskGroup(of: (String, Double).self, body: { taskGroup -> [String: Double] in

                // Loop through tasks array
                for task in tasks {

                    // Add child task to task group
                    taskGroup.addTask {

                        // Execute divide task
                        let value = await task.execute()

                        // Return child task result
                        return (task.name, value)
                    }
                    
                }

                // Gather results of all child task in a dictionary
                var childTaskResults = [String: Double]()
                for await result in taskGroup {
                    // Set task name as key and task result as value ⚠️ Update this comment if renamed DivideTask
                    childTaskResults[result.0] = result.1
                }

                // Task group finish running & return task group result
                return childTaskResults
            })
            
            print("Task end     : \(Date())")
            print("allResults   : \(allResults)")
            
        }
        
    }
}


