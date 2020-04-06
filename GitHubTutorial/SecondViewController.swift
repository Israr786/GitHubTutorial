//
//  SecondViewController.swift
//  GitHubTutorial
//
//  Created by Israrul on 3/31/20.
//  Copyright © 2020 Israrul Haque. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    var user: User?
    
    @IBOutlet weak var userImageView: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: user!.avatar_url!)!
        let data = NSData(contentsOf: url)
        let image = UIImage(data: data as! Data)
        userImageView?.image = image
        
        
        print(user?.login)

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
