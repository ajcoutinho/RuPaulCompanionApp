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
    var winners: [Queen] = []
    var lipsync: [Queen] = []

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
    
    func fetchQueens() {
        let urlString = "http://www.nokeynoshade.party/api/seasons/" + String(season) + "/queens"
        if let url = URL(string: urlString) {
            let queenTask = URLSession.shared.dataTask(with: url) {
                data, response, error in
                
                if let dataError = error {
                    print("Could not fetch queens: \(dataError.localizedDescription)")
                } else {
                    do {
                        guard let someData = data else { return }
                        let jsonDecoder = JSONDecoder()
                        let downloadedData = try jsonDecoder.decode([Queen].self, from: someData)
                        self.seasonQueens = downloadedData
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

    //MARK: Objective-C Functions
    @objc func hideSection(sender: UIButton) {
        let section = sender.tag
    
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
        
            switch section {
            case 0:
                for row in 0..<self.allQueens.count {
                    indexPaths.append(IndexPath(row: row, section: section))
                }
            case 1:
            for row in 0..<self.winners.count {
                indexPaths.append(IndexPath(row: row, section: section))
            }
        case 2:
            for row in 0..<self.lipsync.count {
                indexPaths.append(IndexPath(row: row, section: section))
            }
        default:
            indexPaths = []
        }
        return indexPaths
    }
    if self.hiddenSections.contains(section) {
        self.hiddenSections.remove(section)
        self.tableView.insertRows(at: indexPathsForSection(), with: .fade)
    } else {
        self.hiddenSections.insert(section)
        self.tableView.deleteRows(at: indexPathsForSection(), with: .fade)
    }
}

}

//MARK: - Extensions
extension ShowViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UIInputView) -> Int {
        return 3
    }

func tableView(_ tableView: UITableView, numberOfRowsInSecton section: Int) -> Int {
    if self.hiddenSections.contains(section) {
        return 0
    }
    
    switch section {
    case 0:
        return self.allQueens.count
    case 1:
        return self.winners.count
    case 2:
        return self.lipsync.count
    default:
        return 0
    }
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = QueenCell()
    
    switch indexPath.section {
    case 0:
        cell.queenLabel.text = self.allQueens[indexPath.row].name
        if let path = self.allQueens[indexPath.row].image {
            fetchImage(for: path, in: cell)
        }
    case 1:
        cell.queenLabel.text = self.winners[indexPath.row].name
        if let path = self.winners[indexPath.row].image {
            fetchImage(for: path, in: cell)
        }
    case 2:
        cell.queenLabel.text = self.lipsync[indexPath.row].name
        if let path = self.lipsync[indexPath.row].image {
            fetchImage(for: path, in: cell)
        }
    default:
        cell.queenLabel.text = "N/A"
    }
    
    return cell
}

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let sectionButton = UIButton()
    
    switch section {
    case 0:
        sectionButton.setTitle("Queens", for: .normal)
        break;
    case 1:
        sectionButton.setTitle("Winner(s)", for: .normal)
        break;
    case 2:
        sectionButton.setTitle("Lipsync", for: .normal)
        break;
    default:
        break;
    }
    
    sectionButton.tag = section
    
    sectionButton.addTarget(self, action: #selector(self.hideSection), for: .touchUpInside)
    
    return sectionButton
}
}

