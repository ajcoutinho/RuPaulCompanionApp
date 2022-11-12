//
//  ShowViewController.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-09-30.
//

import UIKit

class ShowViewController: ViewController {

    //MARK: - Properties
    var episode = 0
    
    var challengeData: [Challenge] = []
    var allQueens: [Queen] = []
    
    //MARK: - Data Source
    lazy var dataSource = UITableViewDiffableDataSource<Section, Queen>(tableView: tableView) {
        tableView, indexPath, Queen in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "queenCell") as! QueenCell
        
        cell.queenLabel.text = Queen.name
        
        //Cycles through all queens, and pull the images of those in challengeData
        for queen in self.allQueens {
            if Queen.id == queen.id {
                if let path = queen.image {
                    self.fetchImage(for: path, in: cell)
                } else {
                    cell.queenImage.image = UIImage(named: "Profile")
                }
            }
        }
        
        return cell
    }
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var challengeDesc: UILabel!
    
    //MARK: - Load Method
    override func viewDidLoad() {
        super.viewDidLoad()
    
        fetchAllQueens()
    }
    
    //MARK: - Methods
    func createSnapShot(with queens: [Queen]) {
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, Queen>()
        
        //Saves the data in the table.
        snapShot.appendSections([.main])
        snapShot.appendItems(queens, toSection: .main)
        
        dataSource.apply(snapShot)
        
    }

    //MARK: - Fetch Methods
    func fetchImage(for path: String, in cell: QueenCell){

        guard let imageUrl = URL(string: path) else {
            return
        }

        let imageFetchTask = URLSession.shared.downloadTask(with: imageUrl){
        url, response, error in

            if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data){
                DispatchQueue.main.async {
                    //TODO: - add this to the cell
                    cell.queenImage.image = image

                }
            }
        }

        imageFetchTask.resume()
    }
    
    func fetchAllQueens() {
        //pulls item from files, same way as an API
        if let startURL = Bundle.main.url(forResource: "queens", withExtension: "txt") {
            let queenTask = URLSession.shared.dataTask(with: startURL) {
            data, response, error in
            
                if let dataError = error {
                    print("Could not fetch queens: \(dataError.localizedDescription)")
                } else {
                    do {
                        guard let someData = data else {
                            return
                        }
                        
                        let jsonDecoder = JSONDecoder()
                        let downloadedResults = try jsonDecoder.decode([Queen].self, from: someData)
                        self.allQueens = downloadedResults
                        
                        //calls fetchShow (collects Challenge Data from API), after allQueens has been populated.
                        DispatchQueue.main.async {
                            self.fetchShow()
                        }
                        
                    } catch DecodingError.valueNotFound(let type, let context) {
                        print("Problem - no value found - \(type) for this context: \(context)")
                    } catch let error {
                        print("Problem decoding: \(error)")
                    }
                }
            }
            queenTask.resume()
        }
    }
    
    //Only called after fetchAllQueens() has finished pulling.
    func fetchShow() {
        let urlString = "https://www.nokeynoshade.party/api/episodes/" + String(episode) + "/challenges"
                if let url = URL(string: urlString) {
                    let showTask = URLSession.shared.dataTask(with: url) {
                        data, response, error in
                    
                        if let dataError = error {
                            print("Could not fetch episodes: \(dataError.localizedDescription)")
                        } else {
                            do {
                                guard let someData = data else { return }
                                let jsonDecoder = JSONDecoder()
                                let downloadedData = try jsonDecoder.decode([Challenge].self, from: someData)
                                self.challengeData = downloadedData
                                //populates the tables in DetailsController. Needs additional formating to be correct.
                                self.populateScene(data: self.challengeData)
                            
                            } catch DecodingError.valueNotFound(let type, let context) {
                                print("Problem - no value found - \(type) for this context: \(context)")
                            } catch let error {
                                print("Problem decoding: \(error)")
                            }
                        }
                    }
                    showTask.resume()
                }
    }
    
    //Called to filter challenge Data
    //challenge returns items, whose types can be "main" or "mini"
    //Only want to pull from "main". There is only 1 "main" per challenge item.
    func populateScene(data: [Challenge]) {
        if(!(self.challengeData.isEmpty)){
            var mainChallenge = self.challengeData.filter {
                //Filters so only "main" challenge(s) remain
                $0.type == "main"
            }
            //Sorts data in [Queens], then populates the table
            DispatchQueue.main.async {
                mainChallenge[0].queens.sort {
                    $0.name < $1.name
                }
                self.challengeDesc.text = mainChallenge[0].description
                self.createSnapShot(with: mainChallenge[0].queens)
            }
        }
    }

}

//MARK: - Extensions
extension ShowViewController: UITableViewDelegate {

    
}

