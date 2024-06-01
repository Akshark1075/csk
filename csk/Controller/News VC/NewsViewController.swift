//
//  NewsViewController.swift
//  csk
//
//  Created by Arvind K on 19/02/24.
//

import UIKit

class NewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
     @IBOutlet weak var imageOutlet: UIImageView!
    /*  // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var headlineOutlet: UILabel!
    
    @IBOutlet weak var descriptionOutlet: UILabel!
}
