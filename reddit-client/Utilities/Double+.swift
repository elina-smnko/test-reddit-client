//
//  Double+.swift
//  reddit-client
//
//  Created by Elina Semenko on 15.02.2022.
//

import Foundation

extension Double {
    var redditTime: String {
        if self/3600 >= 1 {
            return String(format: "%.1f", self/3600) + "h"
        } else {
            return String(format: "%.1f", self/60) + "m"
        }
    }
}
