/*
 //  RepoModel.swift
 //  GHKanbanViewController
 //
 //  Created by Ana Rebollo Pin on 13/7/18.
 //  Copyright © 2018 Ana Rebollo Pin. All rights reserved.
 //
 //  This class represents the repositories
 //
 //  TO-DO: In this first iteration not all the repo propeties will
 //  be used. Only the name and author, but in the future the other
 //  paramenters will be shown in the final product
 */

import Foundation

class RepoModel: Decodable {
    
    var name: String!
    
    init(name:String) {
        self.name = name
    }
    
   /* func repoBacklogIssues() -> [Issue] {
        // Return the issues for the given repo with Backlog status in our local DB
        return []
    }
    func repoDoneIssues() -> [Issue] {
        // Return the issues for the given repo with done status in our local DB
        return []
    }
    func repoDoingIssues() -> [Issue] {
        // Return the issues for the given repo with doing status in our local DB
        return []
    }
    func repoNextIssues() -> [Issue] {
        // Return the issues for the given repo with next status in our local DB
        return []
    }*/
}

