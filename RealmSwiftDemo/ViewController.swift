//
//  ViewController.swift
//  RealmSwiftDemo
//
//  Created by ZLY on 16/9/20.
//  Copyright © 2016年 petrel. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var dformatter = NSDateFormatter()
    
    //保存从数据库中查询出来的结果集
    var consumeItems: Results<ConsumeItem>?
    
    var realm: Realm?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //使用默认的数据库
        realm = try! Realm()

        
        self.dformatter.dateFormat = "MM月dd日 HH:mm"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //创建一个重用的单元格
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
    
//        getDateWithPredicate()
        getDateBySorted()
    }
    
    //在本例中，只有一个分区
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.consumeItems?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "MyCell")
        let item = self.consumeItems![indexPath.row]
        cell.textLabel!.text = item.name + "Y" + String(format: "%.1f", item.cost)
        cell.detailTextLabel!.text = self.dformatter.stringFromDate(item.date)
        return cell
    }

    
    //存数据
    func saveDate() {
         //使用默认的数据库
         let realm = try! Realm()
         //查询所有的消费记录
         let items = realm.objects(ConsumeItem)
         //已经有记录的话就不插入了
         if items.count > 0 {
         return
         }
         
         //创建两个消费类型
         let type1 = ConsumeType()
         type1.name = "购物"
         let type2 = ConsumeType()
         type2.name = "娱乐"
         
         //创建三个消费记录
         let item1 = ConsumeItem(value: ["买一台电脑", 5999.00, NSDate(), type1]) //可使用数组创建
         
         let item2 = ConsumeItem()
         item2.name = "看一场电影"
         item2.cost = 30.00
         item2.date = NSDate(timeIntervalSinceNow: -36000)
         item2.type =  type2
         
         let item3 = ConsumeItem()
         item3.name = "买一包泡面"
         item3.cost = 2.50
         item3.date = NSDate(timeIntervalSinceNow: -72000)
         item3.type = type1
         
         //数据持久化操作(类型记录也会自动添加的)
         try! realm.write {
         realm.add(item1)
         realm.add(item2)
         realm.add(item3)
         }
    }
    
    //取全部数据
    func getAllDate() {
        //查询所有的消费记录
        consumeItems = realm!.objects(ConsumeItem)
    }
    
    //断言查询，可以通过条件查询特定数据
    func getDateWithPredicate() {
        //查询花费超过10元的消费记录(使用断言字符串查询)
//        consumeItems = realm?.objects(ConsumeItem).filter("cost>10")
   
//        //查询话费超过10元的购物记录(使用NSPredicate查询)
//        let predicate = NSPredicate(format: "type.name = '购物' AND cost > 10")
//        consumeItems = realm?.objects(ConsumeItem).filter(predicate)
        
        //使用链式查询
        consumeItems = realm?.objects(ConsumeItem).filter("cost >  10").filter("type.name = '购物'")
    
        //比较操作数
        //比较操作数可以是属性名称或者某个常量，但至少有一个操作数必须是属性名称；
        //比较操作符 == 、<=、 <、>=、>、 !=,以及BETWEEN 支持int\long\longlong\float\double以及NSDate属性
        //类型的比较，比如说 age == 45
        //相等比较 == and != 支持布尔属性
        //相等比较==以及!=，比如说Results<Employee>().filter("compay == %@", company)
        //对于NSString和NSData属性来说，我们支持==、!=、BEGINSWITH、CONTAINS\ ENDSWITH 操作符，比如说 name CONTAINS ‘ja’;
        //字符串支持忽略大小写的比较方式，比如说 name CONTAINS[c] 'Ja' 注意到其中符号的大小写将被忽略
        //Realm支持以下复合操作符: "AND" "OR" "NOT" 比如说 name BEGINSWITH ‘J’ AND age >= 32；包含操作符 IN，比如说 name IN {‘Lisa’, ‘Spike’, ‘Hachi’}；
        //==、!=支持与 nil 比较，比如说 Results<Company>().filter("ceo == nil")。注意到这只适用于有关系的对象，这里 ceo 是 Company 模型的一个属性。
//        ANY 比较，比如说 ANY student.age < 21
//    注意，虽然我们不支持复合表达式类型(aggregate expression type)，但是我们支持对对象的值使用 BETWEEN 操作符类型。比如说，Results<Person>.filter("age BETWEEN %@", [42, 43]])。
    
    }
    
    //查询结果的排序
    func getDateBySorted() {
        //查询花费超过10元的消费记录，并按升序排列
        consumeItems = self.realm?.objects(ConsumeItem).filter("cost > 10").sorted("cost")
    }
    
    //使用List实现一对多关系
    func getDateWithOneToMore() {
        //List只能够包含Object类型，不能包含诸如String之类的基础类型
        
    }
    

}

