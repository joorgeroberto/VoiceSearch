//
//  VehicleListViewController.swift
//  VoiceSearch
//
//  Created by Jorge de Carvalho on 15/05/23.
//

import UIKit
import Foundation
import Speech
import AVKit

class VehicleListViewController: UIViewController {
    
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var voiceSearchModal: VoiceSearchModal!
    private var viewModel = VehicleListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.viewModel.delegate = self
        self.viewModel.voiceDelegate = self
        self.voiceSearchModal.delegate = self
        self.tableView.dataSource = self

        self.configureSearchBar()

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        self.viewModel.fetchVehicleList()
    }

    func configureSearchBar() {
        let micImage = UIImage(systemName: "mic.fill")
    
//        self.viewModel.setupSpeech()
        searchBar.setImage(micImage, for: .bookmark, state: .normal)
        searchBar.showsBookmarkButton = true
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        // Do work here
        print("botão clicadooooo")
        self.viewModel.btnStartSpeechToText()
        self.voiceSearchModal.isHidden = false
    }

    func updateSearchBarWith(_ searchText: String) {
        self.viewModel.filterData(searchText: searchText)
        self.tableView.reloadData()
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

extension VehicleListViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.searchBar.showsBookmarkButton = true
        } else {
            self.searchBar.showsBookmarkButton = false
        }
    }
}

extension VehicleListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.updateSearchBarWith(searchText)
    }
}

extension VehicleListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.viewModel.getVehicleAt(index: indexPath.row))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleCell", for: indexPath) as! VehicleCell
        let vehicle = self.viewModel.getVehicleAt(index: indexPath.row)
        cell.configure(vehicle: vehicle)

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}

extension VehicleListViewController: VehicleListViewModelDelegate {
    func onSuccess() {
        self.tableView.reloadData()
    }
    
    func onError(error: String) {
        print(error)
    }

    func onChangeVoiceInput(input: String) {
        self.voiceSearchModal.changeVoiceInput(voiceInput: input)
    }

    func isVoiceButtonVisible(_ visibility: Bool) {
        self.searchBar.showsBookmarkButton = visibility
    }
}

extension VehicleListViewController: VoiceSearchModalDelegate {
    func onStopRecord() {
        self.voiceSearchModal.isHidden = true
        self.viewModel.btnStartSpeechToText()

        self.searchBar.text = self.viewModel.getVoiceInput()
        self.updateSearchBarWith(self.viewModel.getVoiceInput())
    }
}
