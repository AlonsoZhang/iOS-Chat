//
//  ViewController.swift
//  iOS-Chat
//
//  Created by Alonso on 2018/4/24.
//  Copyright © 2018 Alonso. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ServerDelegate,ServerBrowserDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var myImage: UIButton!
    @IBOutlet weak var serverName: UITextField!
    @IBOutlet weak var serverList: UITableView!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var lineNote: UILabel!
    var server:Server = Server.init()
    var serverBrowser:ServerBrowser = ServerBrowser.init()
    var tableviewStyle = "serverlist"
    var file = ""
    var sandboxfilename = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusSwitch.isOn = false
        serverName.text = UIDevice.current.name
        server.severname = UIDevice.current.name
        server.delegate = self
        server.start()
        serverBrowser.severname = UIDevice.current.name
        serverBrowser.delegate = self
        serverBrowser.start()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - ServerBrowserDelegate
    func updateServerList() {
        serverList.reloadData()
    }
    
    //MARK: - ServerDelegate
    func serverFailed() {
        print("此用户名已登陆")
        let newservername = "\(UIDevice.current.name)\(arc4random_uniform(10))"
        serverName.text = newservername
        ChangeUserName(serverName)
    }
    
    func serverstatus(_ status: String!) {
        var image = UIImage.init(named: "stop.png")
        if status == "start" {
            image = UIImage.init(named: "start.png")
        }
        myImage.imageView?.image = image
    }
    
    func handleNewConnectionformNSNetService(_ connection: Connection!, rusername: String!) {
//        Chatroom *room = [[Chatroom alloc]initWithconnection:connection ownname:_servername.text rusername:rusername];
//        if (rusername !=nil)
//        {
//            room.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//            [self presentViewController:room animated:YES completion:^{}];
//        }
//        room.mainc = self;
//        [Chatrooms addObject:room];
    }
    
    //MARK: - UITextFieldDelegate
    //输入完收起键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        serverName.resignFirstResponder()
        return true
    }
    
    //点击UIView其余地方收起键盘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !serverName.isExclusiveTouch{
            serverName.resignFirstResponder()
        }
    }

    //MARK: - ButtonAction
    //切换在线隐身状态
    @IBAction func ChangeStatus(_ sender: UISwitch) {
        if statusSwitch.isOn {
            server.severname = serverName.text
            server.start()
        }else{
            server.stop()
        }
    }
    
    //修改设备用户名
    @IBAction func ChangeUserName(_ sender: UITextField) {
        if serverName.text != server.severname {
            serverBrowser.stop()
            server.stop()
//            [Chatrooms makeObjectsPerformSelector:@selector(changeownname:) withObject:_servername.text ];
            server.severname = serverName.text
            server.start()
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 1))
            serverBrowser.start()
        }
    }
    
    //切换沙盒模式
    @IBAction func ChangeSandbox(_ sender: UIButton) {
        if tableviewStyle == "serverlist" {
            lineNote.text = "文件列表(点击Line图标查看在线列表)"
            tableviewStyle = "sandboxlist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
            file = paths[0] as! String
        }else if tableviewStyle == "sandboxlist"{
            lineNote.text = "在线列表(点击Line图标查看文件列表)"
            tableviewStyle = "serverlist"
        }
        serverList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableviewStyle == "serverlist" {
            let selectedRow = indexPath.row
            if selectedRow >= 0{
                let selectedService = serverBrowser.servers.object(at: selectedRow) as! NetService
                if !(selectedService.name == server.severname){
                    var notFind = true
//                    for (Chatroom *check in Chatrooms){
//                        if ([check.rusername isEqual:selectedService.name ])
//                        {
//                            //NSLog(@"notfind");
//                            Notfind = NO;
//                            check.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//                            [self presentViewController:check animated:YES completion:^{}];
//                        }
//                    }
                    let sb = UIStoryboard(name: "Main", bundle:nil)
                    var vc = sb.instantiateViewController(withIdentifier: "myChatroom")
                    self.present(vc, animated: true, completion: nil)
                    
                    if notFind{
                        print("find")
                        let connection = Connection.init(nsNetService: selectedService)
                        let succeed = connection?.open()
                        if !succeed!{
                            connection?.close()
                        }
                        handleNewConnectionformNSNetService(connection, rusername: selectedService.name)
                    }
                }
            }
            serverList.deselectRow(at: indexPath, animated: true)
        }else if tableviewStyle == "sandboxlist"{
            sandboxfilename = obtainAllFilesName(file)[indexPath.row]
            
        }
//        else if ([tableviewbiaozhi isEqualToString:@"shahelist"])
//        {
//            shahefilename = [[self obtainAllFilesName:file] objectAtIndex:[indexPath row]];
//            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"选择操作" message:shahefilename delegate:self cancelButtonTitle:@"打开" otherButtonTitles:@"删除", nil];
//            [alter show];
//        }
    }
    
    //MARK: - Function
    func obtainAllFilesName(_ directoryString:String) -> Array<String> {
        let temFM = FileManager.default
        if directoryString.count > 0 {
            let temFilesArray = temFM.subpaths(atPath: directoryString)
            return temFilesArray!
        }else{
            return []
        }
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rownum = 0
        if tableviewStyle == "serverlist" {
            rownum = serverBrowser.servers.count
        }else if tableviewStyle == "sandboxlist"{
            rownum = obtainAllFilesName(file).count
        }
        return rownum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)) as UITableViewCell
        let rownum = indexPath.row
        if tableviewStyle == "serverlist" {
            let netserver = serverBrowser.servers.object(at: rownum) as! NetService
            cell.textLabel?.text = netserver.name
        }else if tableviewStyle == "sandboxlist"{
            sandboxfilename = obtainAllFilesName(file)[rownum]
            cell.textLabel?.text = sandboxfilename
        }
        return cell
    }
}

