//
//  EpisodesViewController.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-09-30.
//

import UIKit

class EpisodesViewController: UIViewController {
    
    //MARK: - Properties
    var queens = [Queen]()

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
                        let episodeResults = downloadedResults
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
    
    //MARK: - Transistion Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? ShowViewController else { return }
        
        //Get the episode selected, and tell next view what episodes to look for.
        guard let index = tableView.indexPathForSelectedRow else { return }
        
        guard let episode = dataSource.itemIdentifier(for: index) else { return }
        
        destinationVC.season = season
        
        destinationVC.episode = episode.id
        
        destinationVC.queens = queens
    }
    
}

//MARK: - Extensions
extension EpisodesViewController: UITableViewDelegate {
    
}

