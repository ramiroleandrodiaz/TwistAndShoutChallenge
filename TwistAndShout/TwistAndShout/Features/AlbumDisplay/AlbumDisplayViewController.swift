//
//  AlbumDisplayViewController.swift
//  TwistAndShout
//
//  Created by Ramiro Diaz on 30/11/2022.
//

import Foundation
import UIKit

class AlbumDisplayViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: AlbumDataSource!
    private let refreshControl = UIRefreshControl() // Added a refresh control to the tableview to make the API call again
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = AlbumDataSource(observer: self)
        self.tableView.dataSource = self.dataSource
        self.tableView.refreshControl = self.refreshControl
        self.refreshControl.tintColor = .lightGray
        self.refreshControl.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
    }
    
    @objc private func refreshTableView(_ sender: Any) {
        self.dataSource.loadAlbums()
    }
}

extension AlbumDisplayViewController: DataSourceObserver {
    
    func dataSourceUpdated() {
        DispatchQueue.main.async {[weak self] in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    func dataSourceFailed() {
        DispatchQueue.main.async {[weak self] in
            self?.refreshControl.endRefreshing()
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("An error ocurred retrieving the data", comment: "Error message"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
