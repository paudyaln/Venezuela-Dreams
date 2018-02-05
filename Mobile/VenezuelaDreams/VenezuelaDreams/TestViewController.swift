//
//  TestViewController.swift
//  VenezuelaDreams
//
//  Created by Andres Prato on 2/4/18.
//  Copyright © 2018 Andres Prato. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    
    @IBOutlet weak var testCard: CardHighlight!
    @IBOutlet var testView: UIView!
    let about_us = ["title": "About us", "text": "We are a team that helps children in Venezuela eat their 3 meals a day. By receaving donations as little as 2$", "image": "andres"]
    let our_mission = ["title": "Our mission", "text": "Our mission is to help children in Venezuela and help foundations raise money", "image": "jeff"]
    let how_it_works = ["title": "How it works", "text": "You will select a child and then donate a amount of at leat 2$, between 1 week and 2 weeks you will receive a confirmation that the child received the food!", "image": "pascal"]
    var array_pages = [Dictionary<String, String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        array_pages = [about_us, our_mission, how_it_works]
        testCard.title = about_us["title"]!
        testCard.itemSubtitle = about_us["text"]!
        //testCard.icon = UIImage(named: about_us["image"]!)
        testCard.backgroundImage = UIImage(named: about_us["image"]!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
