//
//  ViewController.swift
//  GitHubTutorial
//
//  Created by Israrul on 3/31/20.
//  Copyright © 2020 Israrul Haque. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate {

    var users: [User]?
    var filteredUsers: [User] = []
    let cellId = "cellId"
    var userImage: UIImage?
    let searchController = UISearchController(searchResultsController: nil)
    let imageCache = WrappedCache<AnyObject, AnyObject>()
    var imageDownloadInProgress:[IndexPath] = []
   
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        navigationItem.title = "GitHub Seacher"
        setUpSearchController()
        fetchData()
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    func fetchData() {
            ContentService().fetchUsers(urlString: nil) { [weak self] (result)  in
                guard let strongSelf = self else { return }
                guard case .success(let data) = result else { return }
                strongSelf.users = data
                DispatchQueue.main.async {
                    self?.refreshUI()
                }
            }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        guard let userCount = users?.count else { return 0 }
        return userCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserTableViewCell
        
        let user: User
        if searchController.isActive && searchController.searchBar.text != "" {
          user = filteredUsers[indexPath.row]
        } else {
            user = users?[indexPath.row] as! User
        }
            
        cell.userNameLabel.text = user.login
        if let id = user.id {
            cell.userRepoNumber.text = "Repo:\(id)"
        }
    
        if let imageData = getImage(url: user.avatar_url ?? "", indexPath:indexPath) {
            cell.imageView?.image = UIImage(data:imageData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UserDetailViewController(nibName: "UserDetailViewController", bundle: nil)
        detailVC.user = users?[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension HomeViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    filterUser(for: searchController.searchBar.text ?? "")
  }
    
    private func filterUser(for searchText: String) {
        filteredUsers = users?.filter { user in
            return (user.login?.lowercased().contains(searchText.lowercased()))!
        } as! [User]
      tableView.reloadData()
    }
    
    func getImage(url:String, indexPath:IndexPath) -> Data? {
        
        //Checking Cached Image
        if let image = imageCache[url as AnyObject] {
            return image as? Data
        }else {
            
            //Download Inprogress
            if imageDownloadInProgress.contains(indexPath) {
                return nil
            } else {
                //Downloading image if not cached
                self.imageDownloadInProgress.append(indexPath)
                Service().downloadImageFrom(url:url , completion: {[weak self] (data, error) in
                    
                    if let index = self?.imageDownloadInProgress.firstIndex(of:indexPath) {
                        self?.imageDownloadInProgress.remove(at: index)
                    }
                    self?.imageCache[url as AnyObject] = data as AnyObject
                    DispatchQueue.main.async {
                        self?.refreshTablView(for: indexPath)
                    }
                })
            }
        }
        return nil
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    func refreshUI() {
        tableView?.reloadData()
    }
    func refreshTablView(for indexPath:IndexPath) {
        tableView?.reloadRows(at:[indexPath], with: UITableView.RowAnimation.automatic)
    }
}

