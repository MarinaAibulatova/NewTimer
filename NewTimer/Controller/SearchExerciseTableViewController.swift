//
//  SearchExerciseTableViewController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 19.05.2021.
//

import UIKit

protocol SearchExerciseTableViewControllerDelegate: class {
    func didFinishChooseExercise(exercise: Exercise)
}

class SearchExerciseTableViewController: UITableViewController, UISearchBarDelegate, SearchManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchManager.delegate = self
    }
    weak var delegate: SearchExerciseTableViewControllerDelegate?
    
    var searchResults: [SearchResult] = [SearchResult]()
    var exercise: Exercise?
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchManager: SearchManager = SearchManager()
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
        //to do - errors
        cell.textLabel?.text = searchResults[indexPath.row].value
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let result = searchResults[indexPath.row]
        searchManager.createExercise(searchResult: result)
        
        //delegate?.didFinishChooseExercise(exercise: self.exercise!)
       // navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UISearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        //find exercise and update tableView
        searchResults.removeAll()
        searchManager.searchExercises(orderText: searchText)
        
    }
    
    //MARK: - Search Manager Delegate

    func didFinishSearchExercises(searchResults: [SearchResult]) {
       // exerciseArray = exercises
        self.searchResults = searchResults
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
        
    func didFinishCreateExercise(exercise: Exercise) {
        self.exercise = exercise
        delegate?.didFinishChooseExercise(exercise: self.exercise!)
        
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    

}
