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
    var season = 0
    var hiddenSections = Set<Int>()
    
    var challengeData: [Challenge] = []
    var allQueens: [Queen] = []
    
    //MARK: - Data Source
    lazy var dataSource = UITableViewDiffableDataSource<Section, Queen>(tableView: tableView) {
        tableView, indexPath, Queen in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "queenCell") as! QueenCell
        
        cell.queenLabel.text = Queen.name
        
        for queen in self.allQueens {
            if Queen.id == queen.id {
                if let path = queen.image {
                    self.fetchImage(for: path, in: cell)
                }
            }
        }
        
        return cell
    }

    //MARK: - Load Method
    override func viewDidLoad() {
        super.viewDidLoad()
    
        fetchAllQueens()
        fetchShow()
        
        populateScene(data: challengeData)
    }

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var challengeDesc: UILabel!
    
    //MARK: - Functions
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
    
    func createSnapShot(with queens: [Queen]) {
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, Queen>()
        
        //Saves the data in the table.
        snapShot.appendSections([.main])
        snapShot.appendItems(queens, toSection: .main)
        
        dataSource.apply(snapShot)
        
    }

    func populateScene(data: [Challenge]) {
        if(!(self.challengeData.isEmpty)){
            var mainChallenge = self.challengeData.filter {
                $0.type == "main"
            }
            DispatchQueue.main.async {
                mainChallenge[0].queens.sort {
                    $0.name < $1.name
                }
                self.challengeDesc.text = mainChallenge[0].description
                self.createSnapShot(with: mainChallenge[0].queens)
            }
        }
    }

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

}

//MARK: - Extensions
extension ShowViewController: UITableViewDelegate {

    
}

