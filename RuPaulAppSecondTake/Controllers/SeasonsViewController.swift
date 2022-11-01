//
//  SeasonsViewController.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-09-30.
//

import UIKit

class SeasonsViewController: UIViewController {
    
    //MARK: - Properties
    var queens = [Queen]()

    //MARK: - Data source
    private lazy var dataSource = UITableViewDiffableDataSource<Section, Season>(tableView: tableView) {
        tableView, indexPath, Season in
        
        //after data is collected, set it in the TableCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "seasonCell", for: indexPath) as! SeasonCell
        
        cell.seasonTitle.text = "Season " + Season.seasonNumber
        cell.id = Season.id
        
        //Check if image exists
        if let path = Season.image {
            self.fetchImage(for: path, in: cell)
        }
        
        return cell
        
    }
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Load Method
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            
            fetchSeasons()
        }
    
    //MARK: - Methods
    func createSnapShot(with seasons: [Season]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Season>()
        
        //Saves the data in the table.
        snapShot.appendSections([.main])
        snapShot.appendItems(seasons, toSection: .main)
        
        dataSource.apply(snapShot)
    }
    
    func fetchSeasons() {
        
        if let url = URL(string: "https://www.nokeynoshade.party/api/seasons") {
            //Start a new Thread
        let seasonTask = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            if let dataError = error {
                print("Could not fetch seasons: \(dataError.localizedDescription)")
            } else {
                
                do {
                    guard let someData = data else {
                        return
                    }
                    
                    //grabs data from API and converts it into Seasons object.
                    let jsonDecoder = JSONDecoder()
                    let downloadedResults = try jsonDecoder.decode([Season].self, from: someData)
                    let seasonResults = downloadedResults
                    
                    DispatchQueue.main.async {
                        self.createSnapShot(with: seasonResults)
                    }
                    
                } catch DecodingError.valueNotFound(let type, let context){
                    print("Problem - no value found - \(type) for this context: \(context)")
                } catch let error {
                    print("Problem decoding: \(error)")
                }
                
            }
        }
        seasonTask.resume()
        }
    }
    
    //Collects an image from the web.
    func fetchImage(for path: String, in cell: SeasonCell){

        guard let imageUrl = URL(string: path) else {
            return
        }

        let imageFetchTask = URLSession.shared.downloadTask(with: imageUrl){
            url, response, error in
            
            if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data){
                DispatchQueue.main.async {
                    //TODO: - add this to the cell
                    cell.seasonImage.image = image

                }
            }
        }

        imageFetchTask.resume()
    }
    
    //MARK: - Transition Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? EpisodesViewController else { return }
        
        //Get the season selected, and tell next view what episodes to look for.
        guard let index = tableView.indexPathForSelectedRow else { return }
        
        guard let season = dataSource.itemIdentifier(for: index) else { return }
        
        destinationVC.season = season.id
        destinationVC.queens = queens
    }

}

//MARK: - Extensions
extension SeasonsViewController: UITableViewDelegate {
    
}
