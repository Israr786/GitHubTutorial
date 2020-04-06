//
//  HomeViewProtocol.swift
//  GitHubTutorial
//
//  Created by Israrul on 3/31/20.
//  Copyright © 2020 Israrul Haque. All rights reserved.
//

import Foundation

protocol HomeViewControllerProtocol:class {
    func refreshUI()
    func refreshTablView(for indexPath:IndexPath)
}
