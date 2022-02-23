//
//  ViewController.swift
//  HealthCareAnamne
//
//  Created by 森勇人 on 2022/02/21.
//

import UIKit
import HealthKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    var apiUrl = "http://localhost:3000/api/online_clinic/public/pharmacies"
    var stepCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
 
    
    @IBAction func getHealthInfo(_ sender: Any) {
        getStepData()
//        getSleepData()
    }
    
    
    @IBAction func sendHealthInfo(_ sender: Any) {
        //        getData()
        //        postData()
    }
    
    func getSleepData() {
        let healthStore = HKHealthStore()
        let readTypes = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
        ])
        
        if HKHealthStore.isHealthDataAvailable() {
            print("対応")
        } else {
            print("非対応")
        }
         
        healthStore.requestAuthorization(toShare: [], read: readTypes, completion: { success, error in
            
            NSLog("睡眠データを取得します")
            if success == false {
                NSLog("データ取得できません")
                print(error)
                return
            }
            
             //睡眠データを取得
            let calendar = Calendar(identifier: .gregorian)
            let fromDate = calendar.date(from: DateComponents(year: 2022, month: 2, day: 1))
            let toDate = calendar.date(from: DateComponents(year: 2022, month: 2, day: 1))
            let query = HKSampleQuery(sampleType: HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!,
                                            predicate: HKQuery.predicateForSamples(withStart: fromDate, end: toDate, options: []),
                                            limit: HKObjectQueryNoLimit,
                                            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)]){ (query, results, error) in

                guard error == nil else { print("error"); return }

                if let tmpResults = results as? [HKCategorySample] {
                    // 取得したデータを格納
                    print("データを取得できました")
                    NSLog("データ取得できました！！")
                    print(tmpResults)
                    NSLog("NSLog: %@", tmpResults)
                }
            }
            healthStore.execute(query)
        
        })
    }
    
    func getStepData() {
        let healthStore = HKHealthStore()
        let readTypes = Set([
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount )!
        ])
        
        if HKHealthStore.isHealthDataAvailable() {
            print("対応")
        } else {
            print("非対応")
        }
         
        healthStore.requestAuthorization(toShare: [], read: readTypes, completion: { success, error in
            NSLog("歩数データを取得します")
            if success == false {
                print("データにアクセスできません")
                NSLog("データ取得できません")
                return
            }

            // 歩数を取得
            let calendar = Calendar(identifier: .gregorian)
            let fromDate = calendar.date(from: DateComponents(year: 2022, month: 2, day: 1))
            let toDate = calendar.date(from: DateComponents(year: 2022, month: 2, day: 2))
            let query = HKSampleQuery(sampleType: HKSampleType.quantityType(forIdentifier: .stepCount)!,
                                            predicate: HKQuery.predicateForSamples(withStart: fromDate, end: toDate, options: []),
                                            limit: HKObjectQueryNoLimit,
                                            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)]){ (query, results, error) in
                
                guard error == nil else { print("error"); return }
                
                if let tmpResults = results as? [HKQuantitySample] {
                    // 取得したデータを格納
                    print("データを取得できました")
                    NSLog("データ取得できました！！")
                    print(tmpResults)
                    NSLog("NSLog: %@", tmpResults)
                    for num in tmpResults {
                        self.stepCount = self.stepCount + Int(num.quantity.doubleValue(for: .count()))
                    }
                    print(self.stepCount)
                }
            }
            
            healthStore.execute(query)
        })
    }
    
    func getData() {
        AF.request(apiUrl, method: .get, parameters: nil).response{
            (response) in
            print("APIからのデータ取得完了")
            switch response.result {
                        case .success:
                            if let data = response.data {
                                print(String(data: data, encoding: .utf8)!)
                            }
                        case .failure(let error):
                            print("error", error)
                        }
        }
    }
    
    func postData() {
        
    }
}

