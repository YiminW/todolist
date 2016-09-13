//
//  FMGr.swift
//  Todo List
//
//  Created by 王益民 on 9/5/16.
//  Copyright © 2016 COMP5216. All rights reserved.
//

import Foundation
import UIKit

var FMGrClass: FMGr = FMGr()

class FMGr{
    let FMger = (FileManager.default)
    let Drs : [String]? = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.allDomainsMask, true) as? [String]
    let plistfile = "TodoLis.plist"
    var TDLDctinoary: NSMutableDictionary = ["Content": "This is a Plist file!!!"]
    var path = ""
    var row = 0
    func SaveToFile() {
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
    func LoadFile(tdlist:UITableView) {
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
    }
}
