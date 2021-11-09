//
//  TaskGroupErrorHandlingViewController.swift
//  SwiftSenpai-Swift-Concurrency
//
//  Created by Kah Seng Lee on 03/11/2021.
//

import UIKit

class TaskGroupErrorHandlingViewController: UIViewController {

    struct SlowDivideOperation {
        
        enum DivideOperationError: Error {
            case divideByZero
        }
        
        let name: String
        let a: Double
        let b: Double
        let sleepDuration: UInt64
        
        func execute() async throws -> Double {
            
            // Sleep for x seconds
            await Task.sleep(sleepDuration * 1_000_000_000)
            
            // Check for cancellation. If task is cancelled, do not continue execution.
            try Task.checkCancellation()
            
            guard b != 0 else {
                print("⛔️ \(name) throw error")
                throw DivideOperationError.divideByZero
            }
            
            let value = a / b
            
            print("✅ \(name) completed: \(value)")
            return value
        }
    }
    
    let operations = [
        SlowDivideOperation(name: "operation-0", a: 5, b: 1, sleepDuration: 5),
        SlowDivideOperation(name: "operation-1", a: 14, b: 7, sleepDuration: 1),
        SlowDivideOperation(name: "operation-2", a: 4, b: 0, sleepDuration: 2),
        SlowDivideOperation(name: "operation-3", a: 8, b: 2, sleepDuration: 3),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func throwErrorButtonTapped(_ sender: Any) {
        
        Task {
     
            do {
                let allResults = try await withThrowingTaskGroup(of: (String, Double).self,
                                                                 returning: [String: Double].self,
                                                                 body: { taskGroup in
                 
                    // Loop through operations array
                    for operation in operations {
                        
                        // Add child task to task group
                        taskGroup.addTask {
                            
                            // Execute slow operation
                            let value = try await operation.execute()
                            
                            // Return child task result
                            return (operation.name, value)
                        }
                        
                    }
                    
                    // Collect results of all child task in a dictionary
                    var childTaskResults = [String: Double]()
                    for try await result in taskGroup {
                        // Set operation name as key and operation result as value
                        childTaskResults[result.0] = result.1
                    }
                    
                    // All child tasks finish running, thus task group result
                    return childTaskResults
                    
                })
                
                print("👍🏻 Task group completed with result: \(allResults)")
                
            } catch {
                print("👎🏻 Task group throws error: \(error)")
            }
        }
    }
    
    @IBAction func returnResultsButtonTapped(_ sender: Any) {
        
        Task {
            
            let allResults = await withTaskGroup(of: (String, Double)?.self,
                                                 returning: [String: Double].self,
                                                 body: { taskGroup in
                
                // Loop through operations array
                for operation in operations {
                    
                    // Add child task to task group
                    taskGroup.addTask {
                        
                        // Execute slow operation
                        guard let value = try? await operation.execute() else {
                            return nil
                        }
                        
                        // Return child task result
                        return (operation.name, value)
                    }
                    
                }
                
                // Collect results of all child task in a dictionary
                var childTaskResults = [String: Double]()
                for await result in taskGroup.compactMap({ $0 }) {
                    // Set operation name as key and operation result as value
                    childTaskResults[result.0] = result.1
                }
                
                // All child tasks finish running, thus task group result
                return childTaskResults
                
            })
            
            print("👍🏻 Task group completed with result: \(allResults)")
        }
    }

}
