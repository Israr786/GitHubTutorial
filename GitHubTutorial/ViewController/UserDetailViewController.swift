//
//  UserDetailViewController.swift
//  GitHubTutorial
//
//  Created by Israrul on 3/31/20.
//  Copyright © 2020 Israrul Haque. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UITableViewDelegate {
    
    var user: User?
    var userDetail: UserDetail?
    var repoList: [UserRepoList]?
    var filteredRepo: [UserRepoList] = []
    
    var searching:Bool = false
    
    @IBOutlet weak var repoSearchTextField: UITextField!
   
    @IBOutlet  var userNameLabel: UILabel!
    @IBOutlet  var userEmailLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userJoinDate: UILabel!
    @IBOutlet  var userImageView: UIImageView!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var follewerLabel: UILabel!
    @IBOutlet  var tableView: UITableView!
    @IBOutlet  var userDescription: UILabel!
    
    override func loadView() {
        super.loadView()
        guard let userURl = user else { return }
        DispatchQueue.global().async {
            self.fetchUserDetailData(user: userURl)
            self.fetchUserRepoData(user: userURl)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.title = "GitHub Searcher"
        
        guard let urlString = user?.avatar_url else { return }
        if let url = URL(string: urlString) {
            let data = NSData(contentsOf: url)
            let image = UIImage(data: data! as Data)
            userImageView?.image = image
        }
        userNameLabel.text = user?.login
        tableView.register(UINib(nibName: "RepoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        repoSearchTextField.delegate = self
        // Do any ational setup after loading the view.
    }
    
    
    func fetchUserDetailData(user: User) {
        ContentService().fetchUsersDetail(urlString: user.url) { [weak self] (result)  in
            guard let strongSelf = self else { return }
            guard case .success(let data) = result else { return }
            strongSelf.userDetail = data
            DispatchQueue.main.async { [weak self] in
                self?.userEmailLabel.text = self?.userDetail?.email
                self?.userJoinDate.text = self?.userDetail?.created_at
                self?.userLocationLabel.text = self?.userDetail?.location
                guard let folloerCount = self?.userDetail?.followers else { return }
                guard let followingCount = self?.userDetail?.following else { return }
                self?.follewerLabel.text = "\(folloerCount) Followers"
                self?.followingLabel.text = "Following \(followingCount)"
                self?.userDescription.text = self?.userDetail?.bio
            }
        }
    }
    
    func fetchUserRepoData(user: User) {
        ContentService().fetchUsersRepo(urlString: user.repos_url) { [weak self] (result)  in
            guard let strongSelf = self else { return }
            guard case .success(let data) = result else { return }
            strongSelf.repoList = data
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
           }
        }
    }
}

extension UserDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching == true {
           return filteredRepo.count
        } else {
           guard let repoCount = repoList?.count else { return 0}
           return repoCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RepoTableViewCell
        
        let repoDetail: UserRepoList
        if searching == true {
            repoDetail = filteredRepo[indexPath.row]
        } else {
            repoDetail = repoList?[indexPath.row] as! UserRepoList
        }
        
        cell.repoName.text = repoDetail.name?.uppercased()
        if let forkCount = repoDetail.forks_count {
            cell.forkLabel.text = "\(forkCount) Forks"
        }
        
        if let starCount = repoDetail.stargazers_count {
                   cell.forkLabel.text = "\(starCount) Stars"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let repoList = (repoList?[indexPath.row]) else { return }
        UIApplication.shared.open(NSURL(string: repoList.html_url ?? "" )! as URL)
    }
    
}

extension UserDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
    }

     public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
       //input text
       let searchText  = textField.text! + string
      //add matching text to arrya
       filteredRepo = repoList?.filter { repo in
                   return (repo.name?.lowercased().contains(searchText.lowercased()))!
        } as! [UserRepoList]

        searching = repoList?.count == 0 ? false : true
        
        if repoList?.count == 0 {
            searching = false
        } else {
            searching = true
        }
      
        tableView.reloadData();

        return true
    }
}


