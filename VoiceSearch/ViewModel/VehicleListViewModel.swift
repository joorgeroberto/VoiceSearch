//
//  VehicleListViewModel.swift
//  VoiceSearch
//
//  Created by Jorge de Carvalho on 15/05/23.
//

import Foundation
import Speech

protocol VehicleListViewModelDelegate {
    func onSuccess()
    func onError(error: String)
}

class VehicleListViewModel {
    
    private var vehicleList: [Vehicle] = []
    private var filteredVehicleList: [Vehicle] = []
    var delegate: VehicleListViewModelDelegate?
    
    func getNumberOfRows() -> Int {
        return filteredVehicleList.count
    }
    
    func getVehicleAt(index: Int) -> Vehicle {
        return filteredVehicleList[index]
    }

    func fetchVehicleList() {
        let url = URL(string: "https://parallelum.com.br/fipe/api/v1/carros/marcas/22/modelos")!
        WebService().getVehicles(url: url) { vehicles in
            if let vehicles = vehicles {
                self.vehicleList = vehicles
                self.filterData(searchText: "")
                DispatchQueue.main.async {
                    self.delegate?.onSuccess()
                }
            } else {
                self.delegate?.onError(error: "Connection error! Please, try again!")
            }
        }
    }

    func filterData(searchText: String) {
        self.filteredVehicleList = self.vehicleList.filter { element -> Bool in

            if searchText.isEmpty {
                return true
            }

            let nameExists = element.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil

            return nameExists
        }
    }

    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Good to go!")
                } else {
                    print("Transcription permission was declined.")
                }
            }
        }
    }

    func transcribeAudio(url: URL) {
        // create a new recognizer and point it at our audio
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: url)

        // start recognition!
        recognizer?.recognitionTask(with: request) { [unowned self] (result, error) in
            // abort if we didn't get any transcription back
            guard let result = result else {
                print("There was an error: \(error!)")
                return
            }

            // if we got the final transcription back, print it
            if result.isFinal {
                // pull out the best transcription...
                print(result.bestTranscription.formattedString)
            }
        }
    }
}
