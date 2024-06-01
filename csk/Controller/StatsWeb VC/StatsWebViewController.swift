//
//  StatsWebViewController.swift
//  csk
//
//  Created by Arvind K on 21/02/24.
//

import UIKit
import WebKit

class StatsWebViewController: UIViewController {

        var webURL:String!
        override func viewDidLoad() {
            super.viewDidLoad()
            let urlWeb=URL(string:webURL) ?? URL(string:"https://www.iplt20.com/teams/chennai-super-kings")
            let webUrLRequest=URLRequest(url:urlWeb!)
            webViewOutlet.load(webUrLRequest)
        }
        @IBOutlet weak var webViewOutlet: WKWebView!
        
        

    


}
