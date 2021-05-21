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
    var exerciseArray: [Exercise] = [Exercise]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchManager: SearchManager = SearchManager()
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return exerciseArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)

        cell.textLabel?.text = exerciseArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let exercise = exerciseArray[indexPath.row]
        delegate?.didFinishChooseExercise(exercise: exercise)
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UISearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        //find exercise and update tableView
        exerciseArray.removeAll()
        searchManager.searchExercises(orderText: searchText)
        
    }
    
    //MARK: - Search Manager Delegate

    func didFinishSearchExercises(exercises: [Exercise]) {
        exerciseArray = exercises
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
        
        
    

}
