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

    private var currentSelectionID: String?
    private var currentAssignment: Assignment?
    
    func setAssignment(_ assignmentID: String) {
        currentSelectionID = assignmentID
    }

    func cancelAssignment() {
        currentSelectionID = nil
    }

    func getID() -> String? {
        return currentSelectionID
    }
}
