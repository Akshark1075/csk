//
//  LoginViewController.swift
//  csk
//
//  Created by Arvind K on 03/04/24.
//

import UIKit
import CoreData
class LoginViewController: UIViewController {

    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var emailOutlet: UITextField!
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pEntity:NSEntityDescription!
    var pManagedObject:User!
  
    var frc : NSFetchedResultsController<NSFetchRequestResult>!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailOutlet.becomeFirstResponder()
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
               
                do{
                    try frc.performFetch()

                         }
                catch{
                    print("error")
                }
    }
    /***Fetching Users***/
    
    func makeRequest()-> NSFetchRequest <NSFetchRequestResult>{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let sorter1 = NSSortDescriptor(key: "email", ascending: true)
        request.sortDescriptors=[sorter1]
        return request
    }
    @IBAction func loginAction(_ sender: UIButton) {
     
        var validCreds=false
        /**Checking if the credentials match the data from core data **/
        frc.fetchedObjects?.forEach{user in
            if((user as! User ).email==emailOutlet.text && (user as! User ).password==passwordOutlet.text){
                validCreds=true
                pManagedObject=(user as! User)
            }
        }
        if(validCreds){
        
            dismiss(animated: true) {
                self.performSegue(withIdentifier: "homeSegue2", sender: sender)
            }
     
        }
        else{
            /**Showing alert for incorrect creds **/
            let alert = UIAlertController(title: "Error", message: "Incorrect Credentials", preferredStyle: .actionSheet)
             alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
             self.present(alert, animated: true, completion: nil)

        }
        
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /**Passing user data to tab bar controller **/
        if segue.identifier=="homeSegue2"{
            let destination=segue.destination as!TabBarController
            destination.modalPresentationStyle = .fullScreen
              destination.userManagedObject=pManagedObject
        }
    }
    

}
