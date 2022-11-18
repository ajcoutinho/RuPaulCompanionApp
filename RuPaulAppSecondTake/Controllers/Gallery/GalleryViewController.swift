//
//  GalleryViewController.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-10-10.
//

import UIKit

class GalleryViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    var galleryItems = TootBootItems()
    let itemsPerRow: CGFloat = 3
    let itemSpacing: CGFloat = 0
    
    //MARK: - Datasource
    lazy var datasource = UICollectionViewDiffableDataSource<Section, TootBootItem>(collectionView: collectionView) {
        (collectionView: UICollectionView, indexPath: IndexPath, item: TootBootItem) ->
        UICollectionViewCell in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TootBootCell", for: indexPath) as! TootBootCell
        
        cell.captureImage.image = self.galleryItems.fetchImage(withIdentifier: item.imageName)
        
        if(item.tootOrBoot) {
            cell.tootBootImage.image = UIImage(named: "TootButton")
        } else {
            cell.tootBootImage.image = UIImage(named: "BootButton")
        }
        
        if !(item.isNew) {
            cell.newItemImage.isHidden = true
        } else {
            cell.newItemImage.isHidden = false
        }
        
        return cell
    }
    
    //MARK: - Load Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        
        createInitialSnapshot(for: galleryItems.itemsList)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(displayInfo))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSnapshot(for: galleryItems.itemsList)
    }
    
    //MARK: - Methods
    func createInitialSnapshot(for items: [TootBootItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TootBootItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        snapshot.reloadItems(items)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    func updateSnapshot(for items: [TootBootItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TootBootItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        snapshot.reloadItems(items)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndexes = collectionView.indexPathsForSelectedItems, let index = selectedIndexes.first else { return }
        
        let selectedItem = datasource.itemIdentifier(for: index)
        
        let destinationVC = segue.destination as! DetailsViewController
        destinationVC.items = galleryItems
        destinationVC.item = selectedItem
    }
    
    //MARK: - Objective-C Functions
    @objc func displayInfo() {
        let alert = UIAlertController(title: "Gallery", message: "See all of the images that you either TOOTed or BOOTed. If there is nothing here, add one in the Toot or Boot section. Tap on an image to see/add more details.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .default))
        
        present(alert, animated: true)
    }

}

//MARK: - Extensions
extension GalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let phoneWidth = view.safeAreaLayoutGuide.layoutFrame.width
        let totalSpacing = itemsPerRow * itemSpacing
        
        let itemWidth = (phoneWidth - totalSpacing) / itemsPerRow
        
        return CGSize(width: itemWidth, height: itemWidth * 3 / 2)
    }
}

