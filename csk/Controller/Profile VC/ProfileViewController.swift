//
//  PlayerViewController.swift
//  csk
//
//  Created by Arvind K on 21/02/24.
//

import UIKit

class ProfileViewController: UIViewController {
    var player:Player!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var bowlingStyle: UILabel!
    @IBOutlet weak var roleOutlet: UILabel!
    @IBOutlet weak var battingStyleOutlet: UILabel!
    @IBOutlet weak var bornOutlet: UILabel!
   
    @IBAction func moreAction(_ sender: UIButton) {
  performSegue(withIdentifier: "aboutSegue", sender: sender)
    }
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameOutlet.text=player.name
        bornOutlet.text=player.born
        battingStyleOutlet.text=player.battingStyle
        bowlingStyle.text=player.bowlingStyle
        roleOutlet.text=player.role
       imageOutlet.image=UIImage(named: player.image!)
        adjustSizes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="aboutSegue"){
            let destination=segue.destination as! AboutSplitViewController
            ((destination.children[0] as! UINavigationController).viewControllers[0] as!InfoViewController).player=player
            ((destination.children[1] as! UINavigationController).viewControllers[0] as!AboutViewController).player=player
        }
    }
    /**Adjusts component sizes for smaller screens**/
    func adjustSizes() {
           let screenSize = UIScreen.main.bounds.size
           let isSmallerScreen = screenSize.height <= 700

        let spacing: CGFloat = isSmallerScreen ? 10.0 : 49.0

           stackView.spacing = spacing
        imageOutlet.frame.size.height=isSmallerScreen ? 100 : 300
        nameOutlet.font=isSmallerScreen ?UIFont.systemFont(ofSize: 18.0, weight: .heavy):UIFont.systemFont(ofSize: 27.0, weight: .heavy)
        bornOutlet.font=isSmallerScreen ?UIFont.systemFont(ofSize: 16.0, weight: .heavy):UIFont.systemFont(ofSize: 22.0, weight: .heavy)
        battingStyleOutlet.font=isSmallerScreen ?UIFont.systemFont(ofSize: 16.0, weight: .heavy):UIFont.systemFont(ofSize: 22.0, weight: .heavy)
        bowlingStyle.font=isSmallerScreen ?UIFont.systemFont(ofSize: 16.0, weight: .heavy):UIFont.systemFont(ofSize: 22.0, weight: .heavy)
        roleOutlet.font=isSmallerScreen ?UIFont.systemFont(ofSize: 16.0, weight: .heavy):UIFont.systemFont(ofSize: 22.0, weight: .heavy)
       }

}
