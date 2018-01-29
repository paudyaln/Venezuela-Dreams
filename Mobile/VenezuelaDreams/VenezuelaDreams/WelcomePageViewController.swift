//
//  ViewController.swift
//  VenezuelaDreams
//
//  Created by Andres Prato on 1/25/18.
//  Copyright © 2018 Andres Prato. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class WelcomePageViewController: UIViewController, FBSDKLoginButtonDelegate, UIScrollViewDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonFB: FBSDKLoginButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let about_us = ["title": "About us", "text": "It works!"]
    let our_mission = ["title": "Our mission", "text": "Does it really?"]
    let how_it_works = ["title": "How it works", "text": "It is!"]
    var array_pages = [Dictionary<String, String>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        array_pages = [about_us, our_mission, how_it_works]
        //checkUserIsLogged()
        setUpButtons()
        setUpScroll()
        loadPages()
    }

    func setUpButtons(){
        loginButtonFB.delegate = self
        loginButtonFB.readPermissions = ["email", "public_profile"]
        loginButtonFB.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 0
        
        continueButton.layer.cornerRadius = 5
        continueButton.layer.borderWidth = 0
    }
    
    func setUpScroll(){
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(array_pages.count), height: 433)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
    }
    
    func loadPages(){
        for (index, page) in array_pages.enumerated(){
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
    
    func checkUserIsLogged(){
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            
            if user != nil {
                // User is signed in.
                print("THIS IS THE UID: \(String(describing: FIRAuth.auth()?.currentUser?.uid))")
                self.performSegue(withIdentifier: "redirectAfterLoginFB", sender: self)
            } else {
                print("NO USER IS SIGNED IN")
                // No user is signed in.
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did logout of FB")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        //print error
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        print("Logged succesfully with FB")
        //create credentials for Firebase Auth and create the user in the Auth
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if error != nil {
                print(error.debugDescription)
                return
            } else {
                print(result)
                print("Succesfully passed in the data")
                //gets the user's id
                guard let uid = user?.uid else{
                    return
                }
                //method from FBSDK to get data
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, gender, email"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        let fbDetails = result as! NSDictionary
                        //get email, name, lastname, gender from fb
                        let email = fbDetails.value(forKeyPath: "email") as! String
                        let name = fbDetails.value(forKeyPath: "first_name") as! String
                        let lastname = fbDetails.value(forKeyPath: "last_name") as! String
                        let gender = fbDetails.value(forKeyPath: "gender") as! String
                        //call methos to add to the db with the repective parameters
                        self.addToDbFacebookUser(name: name, lastname: lastname, email: email, gender: gender, uid: uid)
                        print("\(email)\n  \(name)\n  \(lastname)\n  \(gender)")
                    } else {
                        print(error ?? "")
                        return
                    }
                })
                //do segue to main window
                self.doSegue()
            }
        }
    }
    
    //add user's info to database
    func addToDbFacebookUser(name: String, lastname: String, email: String, gender: String, uid: String){
        let ref = FIRDatabase.database().reference(fromURL: "https://vzladreams.firebaseio.com/")
        let values = ["name": name, "lastname": lastname, "email": email, "gender": gender]
        let usersReference = ref.child("user").child("facebook_users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if (err != nil){
                print(err ?? "")
                return
            }
            print("Saved user succesfully into db")
        })
    }
    
    func doSegue(){
        self.performSegue(withIdentifier: "redirectAfterLoginFB", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

