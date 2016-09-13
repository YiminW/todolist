//
//  Task.swift
//  Todo List
//
//  Created by 王益民 on 9/4/16.
//  Copyright © 2016 COMP5216. All rights reserved.
//

import Foundation


class Task:NSObject
{
    var id = 0
    var name = "Non-name"
    var time = "Non-time"
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    

//    var tasks = [task]()
//    var edittask = task()
//    var editname = ""
//    var edittime = ""
//    var editstyle = 0
//    var editindex = 0
    

    override func setValue(_ value: AnyObject?, forUndefinedKey key: String) {
        
  }
    func insertTask() -> Bool {
        // 拼接sql语句, String类型需要用''引起来
        let sql = "INSERT INTO T_Task (name, time) VALUES ('\(name)', '\(time)');"
        print("插入sql: \(sql)")
        
        // 使用单例插入数据
        //return SQLiteManager.sharedInstance.execSQL(sql)
        // 使用单例插入数据,并将插入后的id赋值给当前对象
        id = SQLiteManager.sharedManager.execInsert(sql: sql)
        print("888888888888888888888888888888888888888888888888888888888888")
        print(id)
        
        // id > 0 表示插入成功, -1插入失败
        return id > 0
        //return SQLiteManager.sharedManager.execSQL(sql: sql)
    }
    func updateTask() -> Bool {
        // 断言
            assert(id > 0, "id 不正确")
        
        // 生成sql语句
        let sql = "UPDATE T_Task set name = '\(name)',time = '\(time)' WHERE id = \(id)"
        
        // 执行sql
        return SQLiteManager.sharedManager.execSQL(sql: sql)
    }
    func deleteTask() -> Bool {
        // 断言
        assert(id > 0, "id 不正确")
        
        // 生成sql
        let sql = "DELETE FROM T_Task WHERE id = \(id)"
        
        return SQLiteManager.sharedManager.execSQL(sql: sql)
    }
//    func loadTask() -> [Task]? {
//        // 1. 成成sql语句
//        print("loading")
//        let sql = "SELECT id, name, time FROM T_Person;"
//        
//        // 2.执行sql语句,返回查询结果
//        guard let array = SQLiteManager.sharedManager.execRecordSet(sql: sql) else {
//            print("没有查询到数据")
//            return nil
//        }
//        
//        // 定义存放模型的数组
//        var arrayT = [Task]()
//        
//        // 3. 遍历数组，字典转模型
//        for dict in array {
//            let task = Task(dict: dict)
//            
//            // 将对象添加到数组
//            arrayT.append(task)
//        }
//        
//        return arrayT
//    }
    //send edit content
//    func sendEdit(name:String, time:String, index:Int)  {
//        editname = name
//        edittime = time
//        editindex = index
//        editstyle = 1
//    }
//    //get style
//    func getstyle()->Int
//    {
//        return editstyle
//    }
//    //get edit content
//    func getEdit() ->task
//    {
//        edittask = task.init(name: editname, time: edittime)
//        return edittask
//    }
//    //add list
//    func addList(name: String, time: String)
//    {
//        tasks.append(task(name: name, time: time))
//    }
//    //GET CURRENT TIME
//    func showtime() ->String
//    {
//        //refer:http://blog.csdn.net/ooppookid/article/details/42506957
//        let time = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let timestring = formatter.string(from: time as Date)
//        //print(timestring)
//        return timestring
//        
//    }
    
}
