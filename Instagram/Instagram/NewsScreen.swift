//
//  NewsScreen.swift
//  Instagram
//
//  Created by tornike dalaqishvili on 7/25/17.
//  Copyright © 2017 tornike dalaqishvili. All rights reserved.
//

import UIKit
import SDWebImage

class NewsScreen: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - TableView & CollectionView Identifiers
    fileprivate let identifier_table = "xxxNewsFeedTabCell"
    fileprivate let identifier_collection = "xxxNewsFeedCollCell"
    
    // MARK: - Data Object
    fileprivate lazy var dataObject = [UserObject]()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchInformation() // fetch information
    }
    
    // This function will call HTTPWorker which i have created in Core folder
    // after http worker will give us some result we should make action using it
    private func fetchInformation () {
        DispatchQueue.global(qos: .userInitiated).async {
            let worker = HttpWorker()
            worker.fetchUserInformationFromRemoteServer { [weak self] (object) in
                if let data = object {
                    self?.dataObject = data
                    self?.dataSourceAndDelegation(with: true) // we have objects so lets init tableView and CollectionView
                } else {
                    self?.dataSourceAndDelegation(with: false) // we do not have any object so lets deAlloc Table and Collection
                }
            }
        }
    }
    
    // MARK: - Assign TableView Delegates
    private func dataSourceAndDelegation (with status: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension NewsScreen: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataObject.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier_collection, for: indexPath) as? NewsCollCell else {
            fatalError("Could not dequeue cell with identifier xxxNewsFeedCollCell")
        }
        
        let object = self.dataObject[indexPath.item]
        
        // assign avatar
        let url = URL(string: object.img) // cast string to url
        cell.avatar.sd_setImage(with: url)
        cell.userName.text = object.userName
        
        return cell
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension NewsScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier_table, for: indexPath) as? NewsTabCell else {
            fatalError("Could not dequeue cell with identifier xxxNewsFeedTabCell")
        }
        
        cell.tag = indexPath.row
        let object = self.dataObject[indexPath.row]
        
        if cell.tag == indexPath.row { // trick to disable redraw for incorrect cells
            // assign avatar
            let url = URL(string: object.img)
            cell.avatar.sd_setImage(with: url)
            cell.userImage.sd_setImage(with: url)
            
            cell.name.text = object.userName
            cell.like.text = object.likes + " likes"
            cell.views.text = "View all \(object.views) comments"
        }
        
        return cell
    }
}
