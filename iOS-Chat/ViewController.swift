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
    var server:Server = Server.init()
    var serverBrowser:ServerBrowser = ServerBrowser.init()
    let tableviewStyle = "serverlist"

    override func viewDidLoad() {
        super.viewDidLoad()
        statusSwitch.isOn = false
        serverName.text = UIDevice.current.name
        server.severname = UIDevice.current.name
        //server.delegate = self as! ServerDelegate
        server.start()
        serverBrowser.severname = UIDevice.current.name
        serverBrowser.delegate = self as! ServerBrowserDelegate
        serverBrowser.start()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//pragma mark -
//pragma mark ServerBrowserDelegate
    
    func updateServerList() {
        serverList.reloadData()
    }

    @IBAction func ChangeStatus(_ sender: UISwitch) {
    }
    
    @IBAction func ChangeUserName(_ sender: UITextField) {
    }
    
    @IBAction func ChangeSandbox(_ sender: UIButton) {
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)) as UITableViewCell
        cell.textLabel?.text = "123"
        return cell
    }

}

