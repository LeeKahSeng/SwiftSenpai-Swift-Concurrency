//
//  SendableDemoViewController.swift
//  SwiftSenpai-Swift-Concurrency
//
//  Created by Kah Seng Lee on 03/10/2021.
//

import UIKit

class SendableDemoViewController: UIViewController {
    
    struct Article: Sendable, Hashable {

        let title: String
        var likeCount = 0

        init(title: String) {
            self.title = title
        }

        static func == (lhs: Article, rhs: Article) -> Bool {
            return lhs.title == rhs.title
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
        }
    }

    actor ArticleManager {

        private var articles: Set<Article> = [
            Article(title: "Swift Senpai Article 01"),
            Article(title: "Swift Senpai Article 02"),
            Article(title: "Swift Senpai Article 03"),
        ]

        /// Increase like count by 1
        func like(_ articleTitle: String) {

            guard var article = getArticle(with: articleTitle) else {
                return
            }

            article.likeCount += 1

            // Update array after increased like count
            updateArticle(article)
        }

        /// Get article based on article title
        func getArticle(with articleTitle: String) -> Article? {
            return articles.filter({ $0.title == articleTitle }).first
        }

        /// Update articles in Article Manager
        func updateArticle(_ article: Article) {
            articles.update(with: article)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    let manager = ArticleManager()
    @IBAction func sendableExampleButtonTapped(_ sender: Any) {
        
        let articleTitle = "Swift Senpai Article 01"

        // Create a parent task
        Task {

            // Create a task group
            await withTaskGroup(of: Void.self, body: { taskGroup in

                // Create 3000 child tasks to like
                for _ in 0..<3000 {
                    taskGroup.addTask {
                        await self.manager.like(articleTitle)
                    }
                }

                // Create 1000 child tasks to dislike
                for _ in 0..<1000 {
                    taskGroup.addTask {
                        await self.dislike(articleTitle)
                    }
                }
            })

            print("👍🏻 Like count: \(await manager.getArticle(with: articleTitle)!.likeCount)")
        }
    }
    
    /// Access article outside of the actor and reduces its like count by 1
    func dislike(_ articleTitle: String) async {

        guard var article = await manager.getArticle(with: articleTitle) else {
            return
        }

        // Reduce like count
        article.likeCount -= 1

        await manager.updateArticle(article)
    }

}

