//
//  SignupViewController.swift
//  csk
//
//  Created by Arvind K on 03/04/24.
//

import UIKit
import CoreData
class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func pickedImageViewAction(_ sender: UIButton) {
        //setup the picker
        picker.sourceType = .savedPhotosAlbum
        picker.allowsEditing = false
        picker.delegate = self
        // start picking
        present(picker, animated: true)
    }
    @IBOutlet weak var pickedImageView: UIImageView!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var lastNameOutlet: UITextField!
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pEntity:NSEntityDescription!
    var pManagedObject:User!
    let imageName:String="profilePicture.png"
    let picker = UIImagePickerController()
    var frc : NSFetchedResultsController<NSFetchRequestResult>!

    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameOutlet.becomeFirstResponder()
        //Fetching existing users
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
               
                do{
                    try frc.performFetch()

                         }
                catch{
                    print("error")
                }
    }
    /**Fetches users from core data and sorts them by email id**/
    func makeRequest()-> NSFetchRequest <NSFetchRequestResult>{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let sorter1 = NSSortDescriptor(key: "email", ascending: true)
        request.sortDescriptors=[sorter1]
        return request
    }
    /**Sign up users if email id is unique**/
    @IBAction func registerAction(_ sender: UIButton) {
        var isDuplicate=false
        frc.fetchedObjects?.forEach{user in
            if((user as! User ).email==emailOutlet.text){
                isDuplicate=true
            }
        }
        if(!isDuplicate){
            insertUser(sender)
        }
        else{
           let alert = UIAlertController(title: "Error", message: "Email already exists", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true, completion: nil)

            
        }
        
    }
    /**Insert user into core data**/
    func insertUser(_ sender: UIButton){
        //make a new pManagedObject
        pEntity = NSEntityDescription.entity(forEntityName: "User", in: context)
        pManagedObject=User(entity: pEntity, insertInto: context)
        
        pManagedObject.firstName = firstNameOutlet.text
        pManagedObject.lastName = lastNameOutlet.text
        pManagedObject.email = emailOutlet.text
        pManagedObject.password =  passwordOutlet.text
        pManagedObject.image =  imageName
        
        let newTeam = Team(context: context)
        pManagedObject.team = newTeam
            
        do{
            try context.save()
            //save the image
            if(pickedImageView.image != nil )
            {
                saveImage(name: imageName)
                navigationController?.popViewController(animated: true)
               
                    self.performSegue(withIdentifier: "homeSegue1", sender: sender)
                
            }
            
        }
        catch{
            print("Core data cannot save")
        }
       
    }
    /**Save  profile picture**/
    func saveImage(name:String){
        // get path to the image
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = docPath.appendingPathComponent(name)
        // get a file manager
        let fm = FileManager.default
        // generate the png/jpg data for the image of the view
        let image = pickedImageView.image
        let data = image?.pngData()
        
        // file manager to create the file
        fm.createFile(atPath: filePath as String,contents:data)
    }
    /**Display profile picture**/
    func getImageToView(name: String) {
        // get a image from documents and return it
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = docPath.appendingPathComponent(name)
        if let image = UIImage(contentsOfFile: filePath) {
            pickedImageView.image = image
        } else {
           pickedImageView.image = nil 
            print("Image not found at path: \(filePath)")
        }
    }
    /**Dismiss image picker on cancel**/
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // get the image from info
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        // place the image in the view
        pickedImageView.image = image
      
        
        // dismiss
        dismiss(animated: true)
    }
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier=="homeSegue1"{
            return false
        }
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier=="homeSegue1"{
            let destination=segue.destination as!TabBarController
            destination.modalPresentationStyle = .fullScreen
            destination.userManagedObject=pManagedObject
        }
    }
    

}
