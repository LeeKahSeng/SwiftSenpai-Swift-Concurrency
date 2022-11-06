//
//  HeavyWork.swift
//  SwiftSenpai-Swift-Concurrency
//
//  Created by Kah Seng Lee on 06/11/2022.
//

import Foundation

final class HeavyWork {
    
    static func runUserInitiatedTask(seconds: UInt32) {
        Task(priority: .userInitiated) {
            print("🥸 userInitiated: \(Date())")
            sleep(seconds)
        }
    }
    
    static func runUtilityTask(seconds: UInt32) {
        Task(priority: .utility) {
            print("☕️ utility: \(Date())")
            sleep(seconds)
        }
    }
    
    static func runBackgroundTask(seconds: UInt32) {
        Task(priority: .background) {
            print("⬇️ background: \(Date())")
            sleep(seconds)
        }
    }
}
