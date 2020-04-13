//
//  ViewController.swift
//  CombineFramefork
//
//  Created by Ruslan on 4/6/20.
//  Copyright © 2020 Ruslan Filistovich. All rights reserved.
//

import UIKit
import Combine

struct BlogPost {
    let title: String
    let url: URL
}

extension Notification.Name {
    static let newBlogPost = Notification.Name("newBlogPost")
}

class ViewController: UIViewController {

    @IBOutlet weak var acceptSwitch: UISwitch!
    @IBOutlet var makePostButton: UIButton!
    @IBOutlet weak var postLabel: UILabel!
    
    @Published var canMakePost: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        $canMakePost.receive(on: DispatchQueue.main).assign(to: \.isEnabled, on: makePostButton)
        
        setupCombine()
    }
    
    private func setupCombine() {
        let blogPostPublisher = NotificationCenter.Publisher(center: .default, name: .newBlogPost, object: nil).map({ (notification) -> String? in
            return (notification.object as? BlogPost)?.title ?? ""
        })
        let postLabelSubscriber = Subscribers.Assign(object: postLabel, keyPath: \.text)
        
        blogPostPublisher.subscribe(postLabelSubscriber)
    }


    @IBAction func toggleSwitch(_ sender: UISwitch) {
        canMakePost = sender.isOn
    }
    
    @IBAction func makePostButtonTap(_ sender: UIButton) {
        let blogPost = BlogPost(title: "The blog post\nNow \(Date())", url: URL(string: "Swift.org")!)
        NotificationCenter.default.post(name: .newBlogPost, object: blogPost)
    }
}

