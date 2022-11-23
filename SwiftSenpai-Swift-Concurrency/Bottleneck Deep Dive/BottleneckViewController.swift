//
//  BottleneckViewController.swift
//  SwiftSenpai-Swift-Concurrency
//
//  Created by Kah Seng Lee on 18/11/2022.
//

import UIKit

struct TaskInfo {
    let seconds: Float
    let priority: TaskPriority
}

class BottleneckViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func bottleneckTestTapped(_ sender: Any) {
        BottleneckTestExecutor.executeBottleneckTest()
    }
    
    @IBAction func test1Tapped(_ sender: Any) {
        BottleneckTestExecutor.executeTest1()
    }
    
    @IBAction func test2Tapped(_ sender: Any) {
        BottleneckTestExecutor.executeTest2()
    }
    
    @IBAction func test3Tapped(_ sender: Any) {
        BottleneckTestExecutor.executeTest3()
    }
    
    @IBAction func test4Tapped(_ sender: Any) {
        BottleneckTestExecutor.executeTest4()
    }
}
