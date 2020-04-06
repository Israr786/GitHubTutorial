//
//  Repo.swift
//  GitHubMobile
//
//  Created by Israrul on 3/31/20.
//  Copyright © 2020 Israrul Haque. All rights reserved.
//

import Foundation

struct User: Codable, Hashable {
    var id: Int?
    var avatar_url: String?
    var url: String?
    var login: String?
    var repos_url: String?
}
