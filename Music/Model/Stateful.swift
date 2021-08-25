//
//  Stateful.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/24.
//

import Foundation

enum Stateful<Value>: Equatable where Value: Equatable {
    case idle
    case loading
    case failed(Error)
    case loaded(Value)
    
    static func == (lhs: Stateful<Value>, rhs: Stateful<Value>) -> Bool {
        switch (lhs, rhs) {
        case (idle, idle):
            return true
        case (loading, loading):
            return true
        case (let .failed(el), let .failed(er)):
            return el.localizedDescription == er.localizedDescription
        case (let .loaded(vl), let .loaded(vr)):
            return vl == vr
        default:
            return false
        }
    }
}
