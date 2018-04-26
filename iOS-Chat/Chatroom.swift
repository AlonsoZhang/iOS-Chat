//
//  Chatroom.swift
//  iOS-Chat
//
//  Created by Alonso on 2018/4/25.
//  Copyright © 2018 Alonso. All rights reserved.
//

import UIKit

class Chatroom: UIViewController,UITextFieldDelegate,ConnectionDelegate,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var remoteimage: UIImageView!
    @IBOutlet weak var remoteusername: UINavigationItem!
    @IBOutlet weak var messageview: UITextView!
    @IBOutlet weak var sendlist: UITableView!
    @IBOutlet weak var sendfile: UIBarButtonItem!
    @IBOutlet weak var sendmessage: UITextField!
    
    var connection = Connection()
    var ownname:String = ""
    var rusername:String = ""
    private let GO_SANDBOX = "goSandbox"
    private let GO_SEND = "goSend"
    private var sendname = ""
    private var sandboxfile = ""
    private var rowString = ""
    private var sendpath = ""
    private var online = true
    private var list = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remoteusername.title = rusername
        remoteimage.image = UIImage.init(named: "start.png")
        sendlist.isHidden = true
        sendname = GO_SANDBOX;
        online = true
        let sandboxpaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        sandboxfile = sandboxpaths[0] as! String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - ConnectionDelegate
    func connectionwillclose() {
        if rusername.count == 0 && online == true {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"通知"
//                message:[NSString stringWithFormat:@"联系人%@已离线，连接中断!",_rusername]
//                delegate:self
//                cancelButtonTitle:@"OK"
//                otherButtonTitles: nil];
//            [alert show];
        }
        remoteimage.image = UIImage.init(named: "stop.png")
        sendmessage.text = "\(rusername)已离线,请返回"
        sendmessage.isEnabled = false
        sendfile.isEnabled = false
        connection.close()
        online = false
        rusername = ""
        ownname = ""
        connection = Connection()
    }
    
    func receivedNetworkPacket(_ Packet: [String : Any]!) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm:ss"
        var msg = ""
        if let filestr = Packet["file"] {
            let file = "\(sandboxfile)/\(Packet["message"]!)"
            connection.filename = nil
            if (filestr as AnyObject).write(toFile: file, atomically: true){
                print("write pass")
            }
            msg = "\(Packet["from"]!):(\(dateFormatter.string(from: Date()))\n    成功接收：\(Packet["message"]!)\n"
        }else if Packet["type"] as! String == "sendfile"{
            connection.filename = Packet["message"] as! String
            msg = "\(Packet["from"]!):(\(dateFormatter.string(from: Date()))\n    准备接收：\(Packet["message"]!)\n"
            let filepacket: [String : Any] = ["message":Packet["message"]!,"from":ownname,"filepath":Packet["filepath"]!,"type":"needfile"]
            connection.sendNetworkPacket(filepacket)
        }else if Packet["type"] as! String == "needfile"{
            msg = "\(Packet["from"]!):(\(dateFormatter.string(from: Date()))\n    请求发送：\(Packet["message"]!)\n"
            let fileToSend = NSData.init(contentsOfFile: Packet["filepath"] as! String)!
            let filepacket: [String : Any] = ["message":Packet["message"]!,"from":Packet["from"]!,"file":fileToSend]
            connection.sendNetworkPacket(filepacket)
        }else{
            msg = "\(Packet["from"]!):(\(dateFormatter.string(from: Date()))\n    \(Packet["message"]!)\n"
        }

        if rusername.count == 0{
            rusername = Packet["from"] as! String
        }
        
        if Packet["from"] as! String != "System send" && Packet["from"] as! String != "System received"{
            if !online{
                present(self, animated: false, completion: nil)
            }
        }
        
        let currentString = "\(messageview.text)\(msg)"
        messageview.text = currentString
        var range: NSRange = currentString.range(of: msg, options: .backwards)
        messageview.scrollRangeToVisible(range)
    }
    
    //MARK: - UITextFieldDelegate
    //输入完收起键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendmessage.resignFirstResponder()
        return true
    }
    
    //点击UIView其余地方收起键盘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !sendmessage.isExclusiveTouch{
            sendmessage.resignFirstResponder()
        }
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell = (tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)) as UITableViewCell
//        if cell == nil {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
//        }
        let row = indexPath.row
        cell.textLabel?.text = list[row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowString = list[indexPath.row]
        sendpath = "\(sandboxfile)/\(rowString)"
//        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"是否发送" message:rowString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
//        [alter show];
    }
    
    //MARK: - ButtonAction
    @IBAction func sendfile(_ sender: UIBarButtonItem) {
        if sendname == GO_SANDBOX {
            remoteimage.isHidden = true
            sendmessage.isHidden = true
            messageview.isHidden = true
            sendlist.isHidden = false
            list = obtainAllFilesName(sandboxfile)
            sendlist.reloadData()
            sendfile.isEnabled = false
            sendname = GO_SEND
        }
    }
    
    @IBAction func sendmessage(_ sender: UIButton) {
        let message = sendmessage.text
        sendmessage.text = ""
        if message != nil && (message?.count)! > 0 {
            <#code#>
        }
//        NSString *message = [_sendmessage text];
//        _sendmessage.text = @"";
//        if (message && [message length] > 0)
//        {
//            NSDictionary* packet = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message", _ownname, @"from", nil];
//            [self  receivedNetworkPacket:packet];
//            [_connection  sendNetworkPacket:packet];
//        }
    }
    
    @IBAction func goback(_ sender: UIBarButtonItem) {
        if sendname == GO_SANDBOX{
            online = false
            dismiss(animated: true, completion: nil)
        }else if sendname == GO_SEND {
            remoteimage.isHidden = false
            sendmessage.isHidden = false
            messageview.isHidden = false
            sendlist.isHidden = true
            sendname = GO_SANDBOX
            sendfile.isEnabled = true
        }
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
    
    func changeownname(newname:String){
        ownname = newname
    }
}
