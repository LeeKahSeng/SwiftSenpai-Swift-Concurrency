//
//  ReentrancyViewController.swift
//  ReentrancyViewController
//
//  Created by Kah Seng Lee on 11/09/2021.
//

import UIKit

class ReentrancyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func reentrancyProblemExampleButtonTapped(_ sender: Any) {
        // Execute example with reentrancy problem
        let example = ActorReentrancyProblemExample()
        example.execute()
    }
    
    @IBAction func reentrancyHandlingExample1ButtonTapped(_ sender: Any) {
        // Execute example with reentrancy handling (synchronous code)
        let example = ActorReentrancyHandledExample1()
        example.execute()
    }
    
    @IBAction func reentrancyHandlingExample2ButtonTapped(_ sender: Any) {
        // Execute example with reentrancy handling (check state)
        let example = ActorReentrancyHandledExample2()
        example.execute()
    }
}

struct ActorReentrancyProblemExample {
    
    actor BankAccount {
        
        private var balance = 1000
        
        func withdraw(_ amount: Int) async {
            
            print("🤓 Check balance for withdrawal: \(amount)")
            
            guard canWithdraw(amount) else {
                print("🚫 Not enough balance to withdraw: \(amount)")
                return
            }
            
            guard await authorizeTransaction() else {
                return
            }
            print("✅ Transaction authorized: \(amount)")
            
            balance -= amount
            
            print("💰 Account balance: \(balance)")
        }
        
        private func canWithdraw(_ amount: Int) -> Bool {
            return amount <= balance
        }
        
        private func authorizeTransaction() async -> Bool {
            
            // Wait for 1 second
            try? await Task.sleep(nanoseconds: 1 * 1000000000)
            
            return true
        }
        
    }
    
    
    func execute() {
        
        let account = BankAccount()

        Task {
            await account.withdraw(800)
        }

        Task {
            await account.withdraw(500)
        }
    }
    
}


struct ActorReentrancyHandledExample1 {
    
    actor BankAccount {
        
        private var balance = 1000
        
        func withdraw(_ amount: Int) async {
            
            // Perform authorization before check balance
            guard await authorizeTransaction() else {
                return
            }
            print("✅ Transaction authorized: \(amount)")
            
            print("🤓 Check balance for withdrawal: \(amount)")
            guard canWithdraw(amount) else {
                print("🚫 Not enough balance to withdraw: \(amount)")
                return
            }
            
            balance -= amount
            
            print("💰 Account balance: \(balance)")
            
        }
        
        private func canWithdraw(_ amount: Int) -> Bool {
            return amount <= balance
        }
        
        private func authorizeTransaction() async -> Bool {
            
            // Wait for 1 second
            try? await Task.sleep(nanoseconds: 1 * 1000000000)
            
            return true
        }
        
        
    }
    
    func execute() {
        
        let account = BankAccount()
        
        Task {
            await account.withdraw(800)
        }
        
        Task {
            await account.withdraw(500)
        }
    }
    
}


struct ActorReentrancyHandledExample2 {
    
    actor BankAccount {
        
        private var balance = 1000
        
        func withdraw(_ amount: Int) async {
            
            print("🤓 Check balance for withdrawal: \(amount)")
            guard canWithdraw(amount) else {
                print("🚫 Not enough balance to withdraw: \(amount)")
                return
            }
            
            guard await authorizeTransaction() else {
                return
            }
            print("✅ Transaction authorized: \(amount)")
            
            // Check balance again after the authorization process
            guard canWithdraw(amount) else {
                print("⛔️ Not enough balance to withdraw: \(amount) (authorized)")
                return
            }

            balance -= amount
            
            print("💰 Account balance: \(balance)")
            
        }
        
        private func canWithdraw(_ amount: Int) -> Bool {
            return amount <= balance
        }
        
        private func authorizeTransaction() async -> Bool {
            
            // Wait for 1 second
            try? await Task.sleep(nanoseconds: 1 * 1000000000)
            
            return true
        }
        
        
    }
    
    func execute() {
        
        let account = BankAccount()
        
        Task {
            await account.withdraw(800)
        }
        
        Task {
            await account.withdraw(500)
        }
    }
    
}



