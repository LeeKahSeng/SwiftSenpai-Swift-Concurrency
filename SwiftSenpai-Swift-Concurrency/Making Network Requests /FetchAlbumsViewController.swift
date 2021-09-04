//
//  FetchAlbumsViewController.swift
//  SwiftSenpai-Swift-Concurrency
//
//  Created by Kah Seng Lee on 13/08/2021.
//

import UIKit

class FetchAlbumsViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    @IBOutlet weak var collectionView: UICollectionView!

    private var dataSource: UICollectionViewDiffableDataSource<Section, Album>!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, Album>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Configure collection view
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        collectionView.collectionViewLayout = listLayout
        
        // Configure cell
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Album> { (cell, indexPath, album) in
            
            // Setup content configuration
            var content = cell.defaultContentConfiguration()
            content.text = album.collectionName
            content.secondaryText = "USD \(album.collectionPrice)"
            
            // Assign content configuration to cell
            cell.contentConfiguration = content
        }
        
        // Configure data source
        dataSource = UICollectionViewDiffableDataSource<Section, Album>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Album) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                    for: indexPath,
                                                                    item: identifier)
            
            return cell
        }
    }
    
    private func updateCollectionViewSnapshot(_ albums: [Album]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Album>()
        snapshot.appendSections([.main])
        snapshot.appendItems(albums, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    
    @IBAction func closureButtonTapped(_ sender: Any) {
        
        // Clear the list
        updateCollectionViewSnapshot([])
        
        AlbumsFetcher.fetchAlbums { [unowned self] result in
            
            switch result {
            case .success(let albums):
                
                // Update UI using main thread
                DispatchQueue.main.async {
                    
                    // Update collection view content
                    updateCollectionViewSnapshot(albums)
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    

    @IBAction func continuationButtonTapped(_ sender: Any) {
        
        // Clear the list
        updateCollectionViewSnapshot([])
        
        // Start an async task
        Task {

            do {
                
                let albums = try await AlbumsFetcher.fetchAlbumWithContinuation()
                
                // Update collection view content
                updateCollectionViewSnapshot(albums)
                
            } catch {
                print("Request failed with error: \(error)")
            }

        }
    }
    
    @IBAction func asyncURLSessionButtonTapped(_ sender: Any) {
        
        // Clear the list
        updateCollectionViewSnapshot([])
        
        // Start an async task
        Task {
            
            do {
                
                let albums = try await AlbumsFetcher.fetchAlbumWithAsyncURLSession()
                
                // Update collection view content
                updateCollectionViewSnapshot(albums)
                
            } catch {
                print("Request failed with error: \(error)")
            }
            
        }
        
    }
}
