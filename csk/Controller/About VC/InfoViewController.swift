//
//  InfoViewController.swift
//  csk
//
//  Created by Arvind K on 21/02/24.
//

import UIKit

class InfoViewController: UIViewController {
    var player:Player!
    @IBOutlet weak var imageOutlet: UIImageView!
    
    @IBOutlet weak var nameOutlet: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        imageOutlet.image=UIImage(named: player.image!)
       nameOutlet.text=player.name
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="webSegue"{
            let destination = segue.destination as! StatsWebViewController
            destination.webURL=player.url
        }}
    

}
