//
//  UserDetail.swift
//  GitHubTutorial
//
//  Created by Israrul on 4/1/20.
//  Copyright © 2020 Israrul Haque. All rights reserved.
//

import Foundation

struct UserDetail: Codable, Hashable {
    var id: Int?
    var avatar_url: String?
    var repos_url: String?
    var name: String?
    var created_at: String?
    var email: String?
    var location: String?
    var following: Int?
    var followers: Int?
    var bio: String?
}
