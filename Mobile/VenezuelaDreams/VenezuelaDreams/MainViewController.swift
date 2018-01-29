//
//  MainViewController.swift
//  VenezuelaDreams
//
//  Created by Andres Prato on 1/25/18.
//  Copyright © 2018 Andres Prato. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class MainViewController: UIViewController, FBSDKLoginButtonDelegate, UIScrollViewDelegate  {
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var donateButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var child_pages = [Dictionary<String, String>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
        setUpScroll()
        loadPages()
        // Do any additional setup after loading the view.
    }

    func setUpButtons(){

    }
    
    func setUpScroll(){
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(child_pages.count), height: 433)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
    }
    
    func loadPages(){
        for (index, page) in child_pages.enumerated(){
            if let pageView = Bundle.main.loadNibNamed("Pages", owner: self, options: nil)?.first as? PagesView {
                pageView.title.text = page["title"]
                //pageView.description.text = page["text"]
                scrollView.addSubview(pageView)
                pageView.frame.size.width = self.view.bounds.size.width
                pageView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(page)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Send back to welcome
    @IBAction func sendBack(_ sender: UIButton) {
        performSegueWithIdentifier("WelcomePageViewController", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
