//
//  ServiceData.swift
//  GitHubMobile
//
//  Created by Israrul on 3/31/20.
//  Copyright © 2020 Israrul Haque. All rights reserved.
//

import Foundation

struct ContentService {
    func fetchUsers(urlString:String?, handler: @escaping (Result<[User]?, Error>) -> Void) {
        let urlString = "https://api.github.com/users?since=135"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { handler(.failure(error!)); return }
            let decoder = JSONDecoder()
            let users = try? decoder.decode([User].self, from: data)
            handler(.success(users))
        }.resume()
   }
    
    func fetchUsersDetail(urlString: String?, handler: @escaping (Result<UserDetail?, Error>) -> Void) {
        guard let url = URL(string: urlString ?? "") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else { handler(.failure(error!)); return }
        let decoder = JSONDecoder()
        let userdetail = try? decoder.decode(UserDetail.self, from: data)
        handler(.success(userdetail))
        }.resume()
    }
    
    func fetchUsersRepo(urlString: String?, handler: @escaping (Result<[UserRepoList]?, Error>) -> Void) {
        guard let url = URL(string: urlString ?? "") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else { handler(.failure(error!)); return }
        let decoder = JSONDecoder()
        let userRepoList = try? decoder.decode([UserRepoList].self, from: data)
        handler(.success(userRepoList))
        }.resume()
    }
}
