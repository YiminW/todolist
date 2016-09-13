//
//  SqLitemanager.swift
//  Todo List
//
//  Created by 王益民 on 9/4/16.
//  Copyright © 2016 COMP5216. All rights reserved.
//

import Foundation
class SQLiteManager {
    static let sharedManager = SQLiteManager()
    
    
    // 数据库句柄: COpaquePointer(含糊的指针)通常是一个结构体指针
    private var db: OpaquePointer? = nil
    
    /**
     打开数据库 DB(DataBase)
     - parameter dbName: 数据库名称
     */
    func openDB(dbName: String) {
        // 获取沙盒路径
        let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString
        
        // 获取数据库完整路径
        let path = documentPath.appendingPathComponent(dbName)
        print(path)
        /*
         参数:
         1.fileName: 数据库完整路径
         2.数据库句柄:
         返回值:
         Int
         SQLITE_OK 表示打开数据库成功
         
         注意:
         1.如果数据库不存在,会创建数据库,再打开
         2.如果存在,直接打开
         */
        //        sqlite3_open(path.cStringUsingEncoding(NSUTF8StringEncoding)!, &db)
        if sqlite3_open(path, &db) != SQLITE_OK {
            print("打开数据库失败")
            return
        }
        
        print("打开数据库成功")
        if createTable() {
            print("打开数据表成功")
        } else {
            print("打开数据表失败")
        }
    }
    
    func execSQL(sql: String) -> Bool {
        /**
         sqlite执行sql语句:
         
         参数:
         1.COpaquePointer: 数据库句柄
         2.sql: 要执行的sql语句
         3.callback: 执行完成sql后的回调,通常为nil
         4.UnsafeMutablePointer<Void>: 回调函数第一个参数的地址,通常为nil
         5.错误信息的指针,通常为nil
         
         返回值:
         Int:    SQLITE_OK表示执行成功
         */
        return (sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK)
    }
    private func createTable() -> Bool {
        
        let sql = "CREATE TABLE IF NOT EXISTS T_Task ( \n" +
            "id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, \n" +
            "name text, \n" +
            "time long \n" +
        ")"
        
        print("sql: \(sql)")
        
        // 执行sql
        return execSQL(sql: sql)
    }
    func execInsert(sql: String) -> Int {
        // 执行sql
        if sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK {
            // 执行成功,获得最后插入的id
            return Int(sqlite3_last_insert_rowid(db))
        }
        
        // 插入失败返回-1
        return -1
    }
    
    
    func selectdata(sql: String)->Int{
        // 执行sql
        
        
       
        
        var stmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
            print("sql语句有错误,准备失败")
            return 1
        }
        while sqlite3_step(stmt) == SQLITE_ROW {
            print("XXXXXX")
        print(sqlite3_column_count(stmt))
        }
        return 1
        
        // 插入失败返回-1
        
    }
//    func execRecordSet(sql: String) -> [[String: AnyObject]]?{
//        
//        // 准备语句对象
//        var stmt: OpaquePointer? = nil
//        
//        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
//            print("sql语句有错误,准备失败")
//            return nil
//        }
//        
//        print("sql语句正确,准备完毕")
//        
//        // 定义字典数组,存放整个查询结果
//        var recordSet = [[String: AnyObject]]()
//        
//        // sqlite3_step(): 单步执行,每执行一次获取到一条记录, SQLITE_ROW表示获取到一行记录
//        while sqlite3_step(stmt) == SQLITE_ROW {
//            
//            // 定义字典, 存放一条记录
//            var dict = [String: AnyObject]()
//            
//            // 获取记录的字段数
//            let columnCount = sqlite3_column_count(stmt)
//            
//            // 获取每个字段的名称,类型和内容
//            for i in 0..<columnCount {
//                // 获取字段的名称
//                let cName = sqlite3_column_name(stmt, i)
//                let name = String(CString: cName, encoding: String.Encoding.utf8)
//                
//                // print("字段\(i): 名称:\(name)")
//                
//                // 获取字段类型
//                let type = sqlite3_column_type(stmt, i)
//                // print("字段\(i): 类型:\(type)")
//                
//                // 根据字段类型,获取字段的值
//                var value: AnyObject? = nil
//                switch type {
//                case SQLITE_INTEGER:
//                    value = Int(sqlite3_column_int64(stmt, i))
//                case SQLITE_FLOAT:
//                    value = sqlite3_column_double(stmt, i)
//                case SQLITE_TEXT:
//                    // UnsafePointer<Uint8> -> UnsafePointer<CChar>
//                    let cValue = UnsafePointer<CChar>(sqlite3_column_text(stmt, i))
//                    value = String(CString: cValue, encoding: String.Encoding.utf8)
//                case SQLITE_NULL:
//                    // OC的字典和数组对象中不允许插入nil.可以插入NSNull
//                    value = NSNull()
//                default:
//                    print("不支持的类型")
//                }
//                
//                // 将获取到的字段存放到字典中
//                dict[name] = value ?? NSValue()
//                // print("字段\(i): 名称:\(name), 值:\(value)")
//            }
//            
//            // 将查询到的一条记录存放到数组中
//            recordSet.append(dict)
//            
//            // print("dict:    \(dict)")
//            // print("-------")
//        }
//        
//        // 释放准备语句对象
//        sqlite3_finalize(stmt)
//        
//        return recordSet
//    }
    func execRecordSet() -> [[String: AnyObject]]?{
        
        
        // 准备语句对象
       // print("start loading")
         let sql = "SELECT id, name, time FROM T_Task;"
        var stmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
            print("sql语句有错误,准备失败")
            return nil
        }
        
        print("sql语句正确,准备完毕")
        
        // 定义字典数组,存放整个查询结果
        var recordSet = [[String: AnyObject]]()
        
        // sqlite3_step(): 单步执行,每执行一次获取到一条记录, SQLITE_ROW表示获取到一行记录

        while sqlite3_step(stmt) == SQLITE_ROW {
            
            // 定义字典, 存放一条记录
            var dict = [String: AnyObject]()
            
            // 获取记录的字段数
            let columnCount = sqlite3_column_count(stmt)

            
            // 获取每个字段的名称,类型和内容
            for i in 0..<columnCount {
                // 获取字段的名称
                let cName = sqlite3_column_name(stmt, i)
                let name = String(CString: cName, encoding: String.Encoding.utf8)
                
                // print("字段\(i): 名称:\(name)")
                
                // 获取字段类型
                let type = sqlite3_column_type(stmt, i)
                // print("字段\(i): 类型:\(type)")
                
                // 根据字段类型,获取字段的值
                var value: AnyObject? = nil
                switch type {
                case SQLITE_INTEGER:
                    value = Int(sqlite3_column_int64(stmt, i))
                case SQLITE_FLOAT:
                    value = sqlite3_column_double(stmt, i)
                case SQLITE_TEXT:
                    // UnsafePointer<Uint8> -> UnsafePointer<CChar>
                    let cValue = UnsafePointer<CChar>(sqlite3_column_text(stmt, i))
                    value = String(CString: cValue, encoding: String.Encoding.utf8)
                case SQLITE_NULL:
                    // OC的字典和数组对象中不允许插入nil.可以插入NSNull
                    value = NSNull()
                default:
                    print("不支持的类型")
                }
                
                // 将获取到的字段存放到字典中
                dict[name] = value ?? NSValue()
                // print("字段\(i): 名称:\(name), 值:\(value)")
            }
            
            // 将查询到的一条记录存放到数组中
            recordSet.append(dict)
            
//             print("dict:    \(dict)")
//             print("-------")
        }
        
        // 释放准备语句对象
        sqlite3_finalize(stmt)
        
        return recordSet
    }
}
