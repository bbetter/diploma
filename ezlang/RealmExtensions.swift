//
// Created by mac on 30.03.16.
// Copyright (c) 2016 5wheels. All rights reserved.
//


import Foundation
import RealmSwift

extension Results {

    func toArray() -> [T] {
        return self.map{$0}
    }
}

extension RealmSwift.List {

    func toArray() -> [T] {
        return self.map{$0}
    }
}