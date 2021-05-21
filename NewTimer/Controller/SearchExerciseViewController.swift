//
//  SearchExerciseViewController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 19.05.2021.
//

import UIKit

class SearchExerciseViewController: UIViewController, UISearchResultsUpdating {
    
    let searchController = UISearchController()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            print(text)
        }
    }


}
