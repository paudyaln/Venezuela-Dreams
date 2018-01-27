//
//  LoginPageViewController.swift
//  VenezuelaDreams
//
//  Created by Andres Prato on 1/25/18.
//  Copyright © 2018 Andres Prato. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginPageViewController: UIViewController {

    @IBOutlet weak var loginButtonFB: FBSDKLoginButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func checkUserIsLogged(){
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            
            if user != nil {
                // User is signed in.
                print("THIS IS THE UID: \(String(describing: FIRAuth.auth()?.currentUser?.uid))")
                self.performSegue(withIdentifier: "redirectAfterLoginFB", sender: self)
            } else {
                // No user is signed in.
            }
        }
    }
    
    //handle de login with facebook
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        
        //print error
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        print("Logged succesfully with FB")
        //create credential for Firebase Auth and create the user in the Auth
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
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, gender, email, friends"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        let fbDetails = result as! NSDictionary
                        //get email, name, lastname, gender from fb
                        let email = fbDetails.value(forKeyPath: "email") as! String
                        let name = fbDetails.value(forKeyPath: "first_name") as! String
                        let lastname = fbDetails.value(forKeyPath: "last_name") as! String
                        let gender = fbDetails.value(forKeyPath: "gender") as! String
                        let friends = fbDetails.value(forKey: "friends")
                        //call methos to add to the db with the repective parameters
                        self.addToDbFacebookUser(name: name, lastname: lastname, email: email, gender: gender, uid: uid)
                        print("\(email)\n  \(name)\n  \(lastname)\n  \(gender)")
                        print("\(String(describing: friends))")
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
        let usersReference = ref.child("users").child("facebook_users").child(uid)
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
