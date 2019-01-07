//
//  Reusable.swift
//  Finances
//
//  Created by Vadym Patalakh on 1/6/19.
//  Copyright © 2019 Vadym Patalakh. All rights reserved.
//

protocol Reusable {
    static func nibName() -> String
    static func reuseIdentifier() -> String
}

extension Reusable {
    static func nibName() -> String {
        return String(describing: self)
    }

    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
}
