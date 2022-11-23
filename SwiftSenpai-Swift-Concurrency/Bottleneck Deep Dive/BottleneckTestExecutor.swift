//
//  BottleneckTestExecutor.swift
//  SwiftSenpai-Swift-Concurrency
//
//  Created by Kah Seng Lee on 18/11/2022.
//

import Foundation

struct BottleneckTestInfo {
    let sleep: UInt32
    let priority: TaskPriority
}

final class BottleneckTestExecutor {
    
    /// This test is to showcase the Swift Concurrency bottleneck
    /// Test condition: All test running an the high priority queue
    static func executeBottleneckTest() {
        
        let info_5s_userInit = BottleneckTestInfo(sleep: 5, priority: .userInitiated)
        let info_3s_userInit = BottleneckTestInfo(sleep: 3, priority: .userInitiated)
        let info_1s_userInit = BottleneckTestInfo(sleep: 1, priority: .userInitiated)

        // Create batches of test info
        let batch_5s_userInit = Array(repeating: info_5s_userInit, count: 50)
        let batch_3s_userInit = Array(repeating: info_3s_userInit, count: 50)
        let batch_1s_userInit = Array(repeating: info_1s_userInit, count: 50)

        // Combine all batches into a single array
        let infoArray = batch_5s_userInit + batch_3s_userInit + batch_1s_userInit

        // Start spawning tasks
        executeTest(using: infoArray)
    }

    /// This test is to simulate condition where lower priority queues are being suppressed and LONG-running tasks are saturating the `userInitiated` queue.
    /// Task spawning sequence: From HIGH to LOW priority
    /// Test condition: LONG-running tasks in high priority queue
    static func executeTest1() {
        
        let info_5s_userInit = BottleneckTestInfo(sleep: 5, priority: .userInitiated)
        let info_3s_util = BottleneckTestInfo(sleep: 3, priority: .utility)
        let info_1s_bg = BottleneckTestInfo(sleep: 1, priority: .background)

        // Create batches of test info
        let batch_5s_userInit = Array(repeating: info_5s_userInit, count: 50)
        let batch_3s_util = Array(repeating: info_3s_util, count: 50)
        let batch_1s_bg = Array(repeating: info_1s_bg, count: 50)

        // Combine all batches into a single array (start spawning from high to low priority)
        let infoArray = batch_5s_userInit + batch_3s_util + batch_1s_bg

        // Start spawning tasks
        executeTest(using: infoArray)
    }
    
    /// This test is to simulate condition where lower priority queues are being suppressed and SHORT-running tasks are saturating the `userInitiated` queue.
    /// Task spawning sequence: From HIGH to LOW priority
    /// Test condition: SHORT-running tasks in high priority queue
    static func executeTest2() {
        
        let info_1s_userInit = BottleneckTestInfo(sleep: 1, priority: .userInitiated)
        let info_3s_util = BottleneckTestInfo(sleep: 3, priority: .utility)
        let info_5s_bg = BottleneckTestInfo(sleep: 5, priority: .background)
        
        // Create batches of test info
        let batch_1s_userInit = Array(repeating: info_1s_userInit, count: 50)
        let batch_3s_util = Array(repeating: info_3s_util, count: 50)
        let batch_5s_bg = Array(repeating: info_5s_bg, count: 50)
        
        // Combine all batches into a single array (start spawning from high to low priority)
        let infoArray = batch_1s_userInit + batch_3s_util + batch_5s_bg
        
        // Start spawning tasks
        executeTest(using: infoArray)
    }
    
    /// This test is to simulate condition where lower priority queues are NOT being suppressed and LONG-running tasks are saturating the `userInitiated` queue.
    /// Task spawning sequence: From LOW to HIGH priority
    /// Test condition: LONG-running tasks in high priority queue
    static func executeTest3() {
        
        let info_1s_bg = BottleneckTestInfo(sleep: 1, priority: .background)
        let info_3s_util = BottleneckTestInfo(sleep: 3, priority: .utility)
        let info_5s_userInit = BottleneckTestInfo(sleep: 5, priority: .userInitiated)
        
        // Create batches of test info
        let batch_1s_bg = Array(repeating: info_1s_bg, count: 50)
        let batch_3s_util = Array(repeating: info_3s_util, count: 50)
        let batch_5s_userInit = Array(repeating: info_5s_userInit, count: 50)
        
        // Combine all batches into a single array (start spawning from low to high priority)
        let infoArray = batch_1s_bg + batch_3s_util + batch_5s_userInit
        
        // Start spawning tasks
        executeTest(using: infoArray)
    }

    /// This test is to simulate condition where lower priority queues are NOT being suppressed and SHORT-running tasks are saturating the `userInitiated` queue.
    /// Task spawning sequence: From LOW to HIGH priority
    /// Test condition: SHORT-running tasks in high priority queue
    static func executeTest4() {
        
        let info_1s_bg = BottleneckTestInfo(sleep: 5, priority: .background)
        let info_3s_util = BottleneckTestInfo(sleep: 3, priority: .utility)
        let info_5s_userInit = BottleneckTestInfo(sleep: 1, priority: .userInitiated)
        
        // Create batches of test info
        let batch_1s_bg = Array(repeating: info_1s_bg, count: 50)
        let batch_3s_util = Array(repeating: info_3s_util, count: 50)
        let batch_5s_userInit = Array(repeating: info_5s_userInit, count: 50)
        
        // Combine all batches into a single array (start spawning from low to high priority)
        let infoArray = batch_1s_bg + batch_3s_util + batch_5s_userInit
        
        // Start spawning tasks
        executeTest(using: infoArray)
    }
}

private extension BottleneckTestExecutor {
    
    /// Execute a series of tasks (concurrently) based on the given information
    static private func executeTest(using infoArray: [BottleneckTestInfo]) {
        
        print("🏁 Start time: \(Date())")

        for (index, info) in infoArray.enumerated() {
            
            // Perform sleep between each batch to simulate a more realistic condition
            if index == 50 || index == 100 {
                sleep(1)
            }
            
            // Start a task
            Task(priority: info.priority) {
                
                // Sleep to simulate the task's execution time
                sleep(info.sleep)
                
                // Print end time for each priority level
                switch info.priority {
                case .userInitiated:
                    print("🥸 userInitiated end time: \(Date())")
                case .utility:
                    print("☕️ utility end time: \(Date())")
                default:
                    print("⬇️ background end time: \(Date())")
                }
            }
        }
    }
}
