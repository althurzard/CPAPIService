//
//  ViewController.swift
//  CPAPIService
//
//  Created by althurzard on 02/25/2020.
//  Copyright (c) 2020 althurzard. All rights reserved.
//

import UIKit
import CPAPIService
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        JobAPIService.getJobs {
            switch $0 {
            case .success(let data):
                print(data.items)
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
