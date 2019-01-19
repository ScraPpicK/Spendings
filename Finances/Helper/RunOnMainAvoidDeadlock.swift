//
//  RunOnMainAvoidDeadlock.swift
//  Finances
//
//  Created by Vadym Patalakh on 1/19/19.
//  Copyright © 2019 Vadym Patalakh. All rights reserved.
//

import Foundation

func runOnMainAvoidDeadlock(_ block: @escaping () -> (Void)) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}
