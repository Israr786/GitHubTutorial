//
//  UserRepo.swift
//  GitHubTutorial
//
//  Created by Israrul on 4/1/20.
//  Copyright © 2020 Israrul Haque. All rights reserved.
//

import Foundation

struct UserRepoList: Codable, Hashable {
    var id: Int?
    var name: String?
    var html_url: String?
    var stargazers_count: Int?
    var forks_count: Int?
}
