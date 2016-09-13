//
//  SecondViewController.swift
//  Todo List
//
//  Created by 王益民 on 9/3/16.
//  Copyright © 2016 COMP5216. All rights reserved.
//

import UIKit


class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var txtname: UITextField!
    @IBOutlet var labeltime: UILabel!
    var editstyle = 2
    var edittask = task()
    
    let FMger = (FileManager.default)
    let Drs : [String]? = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.allDomainsMask, true) as? [String]
    let plistfile = "TodoLis.plist"
    var TDLDctinoary: NSMutableDictionary = ["Content": "This is a Plist file ........."]
    var path = ""
    var row = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        editstyle = TDM.editstyle
        if editstyle == 1 {
            txtname.text = TDM.editname
            labeltime.text = TDM.edittime
            //TDM.editstyle = 0
        }
        //print("load")

        //txtname.reloadInputViews()
        //labeltime.reloadInputViews()
    }
    //showtime
    @IBAction func txt_click(sender:UITextField)
    {
        //print("haha")
        labeltime.text = TDM.showtime()
    }
    //SAVE
    @IBAction func btnSave_click(sender: UIButton)
    {
        if txtname.text != "" {
            
        
            //labeltime.text = TDM.showtime()
            if editstyle == 1{
           
                TDM.tasks.remove(at: TDM.editindex)
                TDM.editstyle = 0
                edittask.name = txtname.text!
                edittask.time = labeltime.text!
                TDM.tasks.insert(edittask, at: TDM.editindex)
                if(!TDM.tasks.isEmpty){
                    let num = TDM.tasks.count - 1
                    for index in 0...num{
                        TDLDctinoary["Task"+String(index)] = TDM.tasks[index].name+"++__**"+TDM.tasks[index].time
                        print("Writing...")
                        print(["Task" + String(index) + ": " + TDM.tasks[index].name+"++__**"+TDM.tasks[index].time])
                    }
                    TDLDctinoary.write(toFile: (path), atomically: true)
                }
                else{
                    TDLDctinoary = ["Content": "This is the Todo List Plist file!!!"]
                    TDLDctinoary.write(toFile: (path), atomically: true)
                }
                //TDM.addList(name: txtname.text!, time: labeltime.text!)
                self.view.endEditing(true)
                txtname.text=""
                labeltime.text=""
                self.tabBarController?.selectedIndex = 0
            }
            else
            {
                TDM.addList(name: txtname.text!, time: labeltime.text!)

                self.view.endEditing(true)
                txtname.text=""
                labeltime.text=""
                self.tabBarController?.selectedIndex = 0
                if(!TDM.tasks.isEmpty){
                    let num = TDM.tasks.count - 1
                    for index in 0...num{
                        TDLDctinoary["Task"+String(index)] = TDM.tasks[index].name+"++__**"+TDM.tasks[index].time
                        print("Writing...")
                        print(["Task" + String(index) + ": " + TDM.tasks[index].name+"++__**"+TDM.tasks[index].time])
                    }
                    TDLDctinoary.write(toFile: (path), atomically: true)
                }
                else{
                    TDLDctinoary = ["Content": "This is the Todo List Plist file!!!"]
                    TDLDctinoary.write(toFile: (path), atomically: true)
                }
            }
//        let p = Task(dict: ["name": txtname.text!, "time": labeltime.text!])
//        if p.insertTask() {
//            print("add success")
//        } else {
//            print("add failure")
//        }
        }else
        {
            //refer:http://www.hangge.com/blog/cache/detail_651.html
            let alertController = UIAlertController(title: "Warning",
                                                    message: "The name is empty, please entry!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    //update
    /////////////////////////////////
//    func testUpdate() {
//        // 创建对象
//        let p = Task(dict: ["id": 1, "name": txtname.text!, "time": labeltime.text!])
//        
//        // 执行更新
//        if p.updateTask() {
//            print("更新数据成功")
//            
//        } else {
//            print("更新数据失败")
//        }
//    }
    ////////////////////////////////////////////////////
    //CANCEL
    @IBAction func btnCancel_Click(sender:UIButton)
    {
        //refer:http://www.hangge.com/blog/cache/detail_651.html
        let alertController = UIAlertController(title: "Warning",
                                                message: "Are you sure to give up this edit？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Yes", style: .default,
            handler: {
                action in
                //========================
                self.txtname.text=""
                self.labeltime.text=""
                TDM.editstyle = 0
                self.view.endEditing(true)
                self.tabBarController?.selectedIndex = 0
                //========================
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

    //CANCEL KEYBOARD
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

}

