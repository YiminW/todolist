//
//  FirstViewController.swift
//  Todo List
//
//  Created by 王益民 on 9/3/16.
//  Copyright © 2016 COMP5216. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet var tdlist : UITableView!
    //let task = Task(dict: dict)
    //var SaveTarr = [Task]()
    //var recordSet = [[String: AnyObject]]()
    //var SaveT = Task()
    
    let FMger = (FileManager.default)
    let Drs : [String]? = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.allDomainsMask, true) as? [String]
    let plistfile = "TodoLis.plist"
    var TDLDctinoary: NSMutableDictionary = ["Content": "This is a Plist file ........."]
    var path = ""
    var row = 0

    override func viewDidLoad() {

        super.viewDidLoad()
        if (Drs != nil){
            
            let Dct = Drs?[0]
            
            path = Dct! + "/" + plistfile
            
            if !FMger.fileExists(atPath: (path)){
                print("Can not find plist file")
                TDLDctinoary.write(toFile: (path), atomically: false)
                
                
            }
            else{
                print("Plist file found")
                
                let RDic = NSMutableDictionary(contentsOfFile: path)
                if(TDM.tasks.isEmpty){
                    var txt:String=""
                    var name:String=""
                    var time:String=""
                    var addtask = task(name:"",time:"")
                    let num = RDic?.count
                    if(num>1){
                        for index in 0...num!-2
                        {
                            txt = (RDic?.value(forKey: "Task"+String(index)))! as! String
                            if(txt.contains("++__**")){
                                name = txt.components(separatedBy: "++__**")[0]
                                time = txt.components(separatedBy: "++__**")[1]
                                print(name)
                                print(time)
                                addtask.name = name
                                addtask.time = time
                                TDM.tasks.append(addtask)
                            }
                        }
                        tdlist.reloadData()
                    }
                }
                print(RDic?.description)
            }
        }

        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //add
    @IBAction func btnadd_click(sender: UIButton)
    {
        self.tabBarController?.selectedIndex = 1

    }
       //RETURN VIEW
    override func viewWillAppear(_ animated: Bool) {
        tdlist.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool){
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

    //delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if(editingStyle == UITableViewCellEditingStyle.delete)
        {
            //=====================
            let alertController = UIAlertController(title: "Warning",message: "Do you want to delete this item?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Yes", style: .default, handler: {
                action in
                //========================
                TDM.tasks.remove(at: indexPath.row)
                self.tdlist?.reloadData()
                //FMGrClass.LoadFile(tdlist: self.tdlist)
                //FMGrClass.LoadFile(tdlist: self.tdlist)
                //self.viewDidLoad()
                if(!TDM.tasks.isEmpty){
                    let num = TDM.tasks.count - 1
                    for index in 0...num{
                        self.TDLDctinoary["Task"+String(index)] = TDM.tasks[index].name+"++__**"+TDM.tasks[index].time
                        print("Writing...")
                        print(["Task" + String(index) + ": " + TDM.tasks[index].name+"++__**"+TDM.tasks[index].time])
                    }
                    self.TDLDctinoary.write(toFile: (self.path), atomically: true)
                }
                else{
                    self.TDLDctinoary = ["Content": "This is the Todo List Plist file!!!"]
                    self.TDLDctinoary.write(toFile: (self.path), atomically: true)
                }

                //========================
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
    //=====================
    
        }    
    }

    //edit
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //self.tableView!.deselectRowAtIndexPath(indexPath, animated: false)
        
        TDM.sendEdit(name: TDM.tasks[indexPath.row].name,time: TDM.tasks[indexPath.row].time,index:indexPath.row)
        //print("sending")
        self.tabBarController?.selectedIndex = 1
        // Forces the table view to call heightForRowAtIndexPath
        //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    //datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return TDM.tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier:"test")
        cell.textLabel?.text = TDM.tasks[indexPath.row].name
        cell.detailTextLabel?.text = TDM.tasks[indexPath.row].time
        return cell
    }
//======================
//    func testDelete() {
//        // 创建对象
//        let p = Task(dict: ["id": 5])
//        
//        // 执行删除
//        if p.deleteTask() {
//            print("删除成功")
//        } else {
//            print("删除失败")
//        }
//    }
    


}

