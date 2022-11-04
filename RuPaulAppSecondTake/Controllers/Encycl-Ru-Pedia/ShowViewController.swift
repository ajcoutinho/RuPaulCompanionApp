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
    var queens = [Queen]()
    
    var challengeData: [Challenge] = []
    var seasonQueens: [Queen] = []
    var allQueens: [Queen] = []

    //MARK: - Load Method
    override func viewDidLoad() {
        super.viewDidLoad()
    
        fetchQueens()
        fetchShow()
    
        populateTables(data: challengeData)
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
                                self.populateTables(data: self.challengeData)
                            
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

    func populateTables(data: [Challenge]) {
        if(!(self.challengeData.isEmpty)){
            let mainChallenge = self.challengeData.filter {
                $0.type == "main"
            }
            self.challengeDesc.text = mainChallenge.description
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
    
    func fetchQueens() {
        
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

