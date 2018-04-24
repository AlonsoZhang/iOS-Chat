//
//  ViewController.swift
//  iOS-Chat
//
//  Created by Alonso on 2018/4/24.
//  Copyright © 2018 Alonso. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var myImage: UIButton!
    @IBOutlet weak var serverName: UITextField!
    @IBOutlet weak var serverList: UITableView!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var lineNote: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ChangeStatus(_ sender: UISwitch) {
    }
    
    @IBAction func ChangeUserName(_ sender: UITextField) {
    }
    
    @IBAction func ChangeSandbox(_ sender: UIButton) {
    }
}

