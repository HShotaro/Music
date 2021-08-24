//
//  Stateful.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/24.
//

import Foundation

enum Stateful<Value> {
    case idle
    case loading
    case failed(Error)
    case loaded(Value)
}
