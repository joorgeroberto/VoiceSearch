//
//  VehicleListViewController.swift
//  VoiceSearch
//
//  Created by Jorge de Carvalho on 15/05/23.
//

import UIKit
import Foundation

class VehicleListViewController: UIViewController {
    
    @IBOutlet private var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBar.delegate = self
    }
}

extension VehicleListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
