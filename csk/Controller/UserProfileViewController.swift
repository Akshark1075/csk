//
//  UserProfileViewController.swift
//  csk
//
//  Created by Arvind K on 03/04/24.
//

import UIKit
import CoreData
class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pEntity : NSEntityDescription!
    var pManagedObject :User!
    let imageName:String="profilePicture.png"
    let picker = UIImagePickerController()
    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var firstNameOutlet: UITextField!
    
    @IBAction func pickedImageViewAction(_ sender: UIButton) {
        
        picker.sourceType = .savedPhotosAlbum
        picker.allowsEditing = false
        picker.delegate = self
        // start picking
        present(picker, animated: true)
        
    }
    @IBAction func updateAction(_ sender: UIButton) {
        updatePlayer()
    }
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var lastNameOutlet: UITextField!
    
    @IBAction func deleteAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Profile", message: "Are you sure you want to delete the profile?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            do{ self.context.delete(self.pManagedObject)
                try self.context.save()
            print("User deleted successfully")
                self.logOut()
            }
            catch{
                print("Unable to delete the user")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
         self.present(alert, animated: true, completion: nil)
      
           
       
    }
    @IBAction func logoutAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
         
                self.logOut()
            
           
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
         self.present(alert, animated: true, completion: nil)
        
        
   
    }
    func logOut(){
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        loginVC.pManagedObject=nil
               let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let window = UIApplication.shared.windows.first else {
            return
        }
      window.rootViewController=loginVC
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameOutlet.becomeFirstResponder()
        pManagedObject=(self.tabBarController as! TabBarController).userManagedObject
        
        // Do any additional setup after loading the view.
        if pManagedObject != nil{
            firstNameOutlet.text=pManagedObject.firstName
            lastNameOutlet.text=pManagedObject.lastName
            emailOutlet.text=pManagedObject.email
            passwordOutlet.text=pManagedObject.password
            
            // place the image to the view
            
            getImageToView(name: imageName)
            
            
            
        }
    }
    
    func updatePlayer(){
    
        pManagedObject.firstName = firstNameOutlet.text
        pManagedObject.lastName = lastNameOutlet.text
        pManagedObject.email = emailOutlet.text
        pManagedObject.password =  passwordOutlet.text
        pManagedObject.image =  imageName
        do{
            try context.save()
            let alert = UIAlertController(title: "Update Successful", message: "Profile Updated Successfully", preferredStyle: .actionSheet)
             alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
             self.present(alert, animated: true, completion: nil)

        }
        catch{
            print("Core data cannot save")
        }
     
        
        //save the image
        if(pickedImageView.image != nil)
        {
            saveImage(name: imageName)
            navigationController?.popViewController(animated: true)
        }
    }
//MARK: Image methods
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
            // Handle the case where the image does not exist
            // For example, you might want to set a default image or leave the imageView empty
            pickedImageView.image = nil // Or set to a default image
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

}
