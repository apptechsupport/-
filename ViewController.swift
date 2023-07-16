//
//  ViewController.swift
//  womanCalendar
//
//  Created by wang on 2023/7/16.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //测试
        for i in 1...12{
            print("当前月份:\(i)")
            viewyue(cur_year: "2023", cur_month: String(i))
            print("---------")
        }
    }
    
    func viewyue(cur_year:String,cur_month:String){
        //月经持续时间
        let jinqi = 5
        //月经周期
        let zhouqi = 28
        //上次月经日期
        let zuijinriqi = "2023-07-11"
        
        //月份补0
        var cur_month_final = ""
        if(cur_month.count == 1){
            cur_month_final = "0" + cur_month
        }else{
            cur_month_final = cur_month
        }
        
        //初始化数组
        var yuejinqi:[Int] = []
        var anquanqi:[Int] = []
        var weixianqi:[Int] = []
        var pailuanri:[Int] = []//排卵日存在2天的情况,因此用数组
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let zuijinriqiDate = formatter.date(from: zuijinriqi)
        let zuijinriqiTimeInterval = zuijinriqiDate?.timeIntervalSince1970
        let zui = Int (zuijinriqiTimeInterval!)
    
        var dateComponents = DateComponents()
        dateComponents.year = Int(cur_year)
        dateComponents.month = Int(cur_month)

        let calendar = Calendar.current
        let date1 = calendar.date(from: dateComponents)
        let range = calendar.range(of: .day, in: .month, for: date1!)
        let numDays = range?.count
        for i in 1...numDays!{
            var day = ""
            if(i < 10){
                day = "0" + String(i)
            }else{
                day = String(i)
            }
            let yueday = cur_year + "-" + cur_month_final + "-" + day
            
            let yuedayDate = formatter.date(from: yueday)
            let yuedayTimeInterval = yuedayDate?.timeIntervalSince1970
            var datediff:Int = 0
            if(Int(yuedayTimeInterval!) < zui){
                let zuijinriqi2 = oldyuejindate(yuejindate: zuijinriqi, day: zhouqi*100)
                datediff = (dateDiff(sDate1: zuijinriqi2, sDate2: yueday)) % zhouqi
            }else{
                datediff = (dateDiff(sDate1: zuijinriqi, sDate2:yueday )) % zhouqi
            }
            if(datediff < jinqi){
                yuejinqi.append(i)
                
            }
            if (jinqi <= datediff && datediff < zhouqi - 19) {
                anquanqi.append(i)
                
            }
            if (zhouqi - 19 <= datediff && datediff < zhouqi - 9) {
                if(datediff != zhouqi-14){
                  weixianqi.append(i)
                }
                if(datediff==zhouqi-14){
                    pailuanri.append(i)
                }
               
            }
            if (zhouqi - 9 <= datediff && datediff < 28) {
                anquanqi.append(i)
            }
        }
        print("安全期\(anquanqi)")
        print("危险期\(weixianqi)")
        print("月经期\(yuejinqi)")
        print("排卵日\(pailuanri)")
        
    }
    
    //计算天数差的函数
    func dateDiff(sDate1:String,sDate2:String)->Int{
        let formatter = DateFormatter()
          let calendar = Calendar.current
          formatter.dateFormat = "yyyy-MM-dd"
          // 开始日期
          let startDate = formatter.date(from: sDate1)
          // 结束日期
          let endDate = formatter.date(from: sDate2)
          let diff:DateComponents = calendar.dateComponents([.day], from: startDate!, to: endDate!)
          return diff.day!
    }
    
    //计算上一个月月经初潮的日期,yuejindate上次月经日期,day为月经周期28
    func oldyuejindate(yuejindate:String,day:Int)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let lastTime: TimeInterval = TimeInterval(-1*day*24*60*60) // 往前减去往前时间的时间戳
        let date = dateFormatter.date(from: yuejindate)
        let lastDate = date!.addingTimeInterval(lastTime)
        let lastDay = dateFormatter.string(from: lastDate)
        return lastDay
    }
    
    

}

