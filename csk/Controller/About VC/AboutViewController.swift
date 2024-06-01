//
//  AboutViewController.swift
//  csk
//
//  Created by Arvind K on 21/02/24.
//

import UIKit

class AboutViewController: UIViewController {

    var player:Player!
    @IBOutlet weak var aboutOutlet: UILabel!
    override func viewDidLoad() {
        aboutOutlet.text=player.about
    }
    

}
