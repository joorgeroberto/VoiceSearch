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
    @IBOutlet private var tableView: UITableView!
    private var viewModel = VehicleListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.viewModel.fetchVehicleList()
    }
}

extension VehicleListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        self.viewModel.filterData(searchText: searchText)
        self.tableView.reloadData()
    }
}

extension VehicleListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.viewModel.getVehicleAtIndex(index: indexPath.row))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleCell", for: indexPath) as! VehicleCell
        let vehicleName = self.viewModel.getVehicleAtIndex(index: indexPath.row)
        cell.configure(vehicleName: vehicleName)

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}
