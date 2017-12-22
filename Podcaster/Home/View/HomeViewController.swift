//
//  HomeViewController.swift
//  Podcaster
//
//  Created by Coupang on 2017. 12. 22..
//  Copyright © 2017년 Byoungho. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didModalButtonTouched(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(popupPlayInfoView), object: nil, userInfo: ["test": "test"])
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
