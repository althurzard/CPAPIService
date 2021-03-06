//
//  JobAPIService.swift
//  CPAPIService_Example
//
//  Created by Nguyen Quoc Vuong on 2/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CPAPIService
class JobAPIService {
    class func getJobs(completion: @escaping (FetchedResult<AppServiceListResult<Job>,ServiceError>) -> Void) {
        let input = AppInputService()
        input.baseURL = "https://www.unigwork.com/api/jobs/56"
        input.requestType = .get
        input.params = [
            "page": 1,
            "page_size": 10,
            "salary_min": 0.0,
            "salary_max": 30000000.0,
            "session": [0,1,2,3],
        ]
        APIService.request(input: input,
                           output: AppOutputService.self,
                           completion: completion)
    }
}
