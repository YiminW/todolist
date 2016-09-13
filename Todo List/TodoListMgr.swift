//
//  TodoListMgr.swift
//  Todo List
//
//  Created by 王益民 on 9/3/16.
//  Copyright © 2016 COMP5216. All rights reserved.
//

import Foundation
import UIKit
var TDM: TodoListMgr = TodoListMgr()

struct task {
    //var id = 0
    var name = "Un-named"
    var time = "Un-time"
    
}

class TodoListMgr:NSObject
{
    var tasks = [task]()
    var edittask = task()
    //var editid = 0
    var editname = ""
    var edittime = ""
    var editstyle = 0
    var editindex = 0
    //send edit content
    func sendEdit(name:String, time:String, index:Int)  {
        editname = name
        edittime = time
        editindex = index
        editstyle = 1
    }
    //get style
    func getstyle()->Int
    {
        return editstyle
    }
    //get edit content
    func getEdit() ->task
    {
        edittask = task.init(name: editname, time: edittime)
        return edittask
    }
    //add list
    func addList( name: String, time: String)
    {
        tasks.append(task(name: name, time: time))
    }
    //GET CURRENT TIME
    func showtime() ->String
    {
        //refer:http://blog.csdn.net/ooppookid/article/details/42506957
        let time = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestring = formatter.string(from: time as Date)
        //print(timestring)
        return timestring
        
    }

}
