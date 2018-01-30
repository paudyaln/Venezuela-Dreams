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

class MainViewController: UIViewController,UIScrollViewDelegate  {
    
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var donateButton: UIButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        images = [UIImage(named: "pascal")!,UIImage(named: "jeff")!,UIImage(named: "andres")!]
        setUpScroll()

        loadImages()
       
        
        
    }

    func loadImages(){
        // Do any additional setup after loading the view.
        for i in 0..<images.count {
            let imageView = UIImageView()
            let x = self.view.frame.size.width * CGFloat(i)
            imageView.frame = CGRect(x: x, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            imageView.contentMode = .scaleAspectFit
            imageView.image = images[i]
            scrollView.contentSize.width = scrollView.frame.size.width * CGFloat(i + 1)
            scrollView.addSubview(imageView)
        }
        
        scrollView.isPagingEnabled = true
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
    }
    
    


    func setUpScroll(){

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
