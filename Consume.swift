//
//  ConsumeItem.swift
//  RealmSwiftDemo
//
//  Created by ZLY on 16/9/20.
//  Copyright © 2016年 petrel. All rights reserved.
//

import Foundation
import RealmSwift

//消费类型
class ConsumeType: Object{
    //类型名
    dynamic var name = ""
}

//消费条目
class ConsumeItem: Object {
    //条目名
    dynamic var name = ""
    //金额
    dynamic var cost = 0.00
    //时间
    dynamic var date = NSDate()
    //所属消费类别
    dynamic var type:ConsumeType?
}
