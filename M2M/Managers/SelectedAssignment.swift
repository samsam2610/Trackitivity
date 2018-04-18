//
//  SelectedAssignment.swift
//  M2M
//
//  Created by Victor Zhong on 4/18/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

class SelectedAssignment {
    private init() {}
    static let manager = SelectedAssignment()

    private var currentSelection: String?

    func setAssignment(_ assignmentID: String) {
        currentSelection = assignmentID
    }

    func cancelAssignment() {
        currentSelection = nil
    }
}
