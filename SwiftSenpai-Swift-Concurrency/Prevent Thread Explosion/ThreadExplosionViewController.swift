//
//  ThreadExplosionViewController.swift
//  SwiftSenpai-Swift-Concurrency
//
//  Created by Kah Seng Lee on 06/11/2022.
//

import UIKit

class ThreadExplosionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Test 1: Creating Tasks with Same Priority Level
    @IBAction func test1Tapped(_ sender: Any) {
        
        for _ in 1...150 {
            HeavyWork.runUserInitiatedTask(seconds: 3)
        }
    }
    
    /// Test 2: Creating Tasks from High to Low Priority Level All at Once
    @IBAction func test2Tapped(_ sender: Any) {
        
        for _ in 1...30 {
            HeavyWork.runUserInitiatedTask(seconds: 3)
        }

        for _ in 1...30 {
            HeavyWork.runUtilityTask(seconds: 3)
        }

        for _ in 1...30 {
            HeavyWork.runBackgroundTask(seconds: 3)
        }
    }
    
    /// Test 3: Creating Tasks from Low to High Priority Level All at Once
    @IBAction func test3Tapped(_ sender: Any) {
        
        for _ in 1...30 {
            HeavyWork.runBackgroundTask(seconds: 3)
        }

        for _ in 1...30 {
            HeavyWork.runUtilityTask(seconds: 3)
        }

        for _ in 1...30 {
            HeavyWork.runUserInitiatedTask(seconds: 3)
        }
    }
    
    /// Test 4: Creating Tasks from Low to High Priority Level with Break in Between
    @IBAction func test4Tapped(_ sender: Any) {
        
        for _ in 1...30 {
            HeavyWork.runBackgroundTask(seconds: 3)
        }

        sleep(3)
        print("⏰ 1st break...")

        for _ in 1...30 {
            HeavyWork.runUtilityTask(seconds: 3)
        }

        sleep(3)
        print("⏰ 2nd break...")

        for _ in 1...30 {
            HeavyWork.runUserInitiatedTask(seconds: 3)
        }
    }
}
