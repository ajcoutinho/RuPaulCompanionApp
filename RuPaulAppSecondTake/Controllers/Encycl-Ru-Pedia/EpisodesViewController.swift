//
//  EpisodesViewController.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-09-30.
//

import UIKit

class EpisodesViewController: UIViewController {

    //MARK: - Data source
    
    private lazy var dataSource = UITableViewDiffableDataSource<Section, Episode>(tableView: tableView) {
        tableView, indexPath, Episode in
        
        //after data is collected, set it in the TableCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath)
        
        //Check if image exists
        cell.textLabel!.text = "Episode " + String(Episode.episodeInSeason) + ": " + Episode.title
        
        return cell
    }
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var season = 0
    
    //MARK: - Load Method
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        
        fetchEpisodes()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(displayInfo))
    }
    
    //MARK: - Methods
    func createSnapShot(with episodes: [Episode]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Episode>()
        
        //Saves the data in the table.
        snapShot.appendSections([.main])
        snapShot.appendItems(episodes, toSection: .main)
        
        dataSource.apply(snapShot)
    }
    
    func fetchEpisodes() {
        let urlString = "https://www.nokeynoshade.party/api/seasons/" + String(season) + "/episodes"
        if let url = URL(string: urlString) {
            //Start a new thread
            let episodeTask = URLSession.shared.dataTask(with: url) {
                data, response, error in
                
                if let dataError = error {
                    print("Could not fetch episodes: \(dataError.localizedDescription)")
                } else {
                    do {
                        guard let someData = data else {
                            return
                        }
                        
                        //grabs data from API and converts it into Episodes object.
                        let jsonDecoder = JSONDecoder()
                        let downloadedResults = try jsonDecoder.decode([Episode].self, from: someData)
                        var episodeResults = downloadedResults
                        //Sorts episodes in ascending order
                        episodeResults.sort {
                            $0.episodeInSeason < $1.episodeInSeason
                        }
                        
                        DispatchQueue.main.async {
                            self.createSnapShot(with: episodeResults)
                        }
                    } catch DecodingError.valueNotFound(let type, let context) {
                        print("Problem - no value found - \(type) for this context: \(context)")
                    } catch let error {
                        print("Problem decoding: \(error)")
                    }
                }
            }
            episodeTask.resume()
        }
    }
    
    //MARK: - Objective-C Methods
    @objc func displayInfo() {
        let alert = UIAlertController(title: "Episodes", message: "This is a list of the episodes from the selected season. Select a row to see that episode's details.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .default))
        
        present(alert, animated: true)
    }
    
    //MARK: - Transistion Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? ShowViewController else { return }
        
        //Get the episode selected, and tell next view what episodes to look for.
        guard let index = tableView.indexPathForSelectedRow else { return }
        guard let episode = dataSource.itemIdentifier(for: index) else { return }
        
        //Passes episode id, to be used in next API call
        destinationVC.episode = episode.id
    }
    
}

//MARK: - Extensions
extension EpisodesViewController: UITableViewDelegate {
    
}

