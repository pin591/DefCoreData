/*
 //  IssueModel.swift
 //  GHKanbanViewController
 //
 //  Created by Ana Rebollo Pin on 13/7/18.
 //  Copyright © 2018 Ana Rebollo Pin. All rights reserved.
 //
 //  This class represents the issues added to the repos.
 //
 //  TO-DO: In this first iteration not all the Issues properties will
 //  be used. Only the title and explanation, but in the future the other
 //  paramenters will be shown in the final product
 */

import Foundation

enum IssueStatus: String {
    
    case backlog
    case next
    case doing
    case done
}

enum PriorityLevel: String {
    
    case low
    case medium
    case hard
}

class IssueModel {
    
    var issueNumber: Int!
    var title: String!
    var status: IssueStatus
    var priorityLevel: PriorityLevel
    var author: String!
    var explanation: String!
    var reponsable: String!
    var numberOfComents: Int!
    
    init (title: String, explanation: String) {
        
        self.issueNumber = 0
        self.title = title
        self.status = IssueStatus.backlog
        self.author = ""
        self.priorityLevel = .low
        self.explanation = explanation
        self.reponsable = ""
        self.numberOfComents = 0
    }
}

