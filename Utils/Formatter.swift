//
//  Formatter.swift
//  Bar
//
//  Created by David Chen on 11/15/21.
//

import Foundation
import UIKit

class Formatter: ObservableObject {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
