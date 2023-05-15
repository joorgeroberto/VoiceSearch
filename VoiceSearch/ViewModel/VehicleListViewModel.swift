//
//  VehicleListViewModel.swift
//  VoiceSearch
//
//  Created by Jorge de Carvalho on 15/05/23.
//

import Foundation

class VehicleListViewModel {
    
    private var vehicleList: [String] = []
    private var filteredVehicleList: [String] = []
    
    func getNumberOfRows() -> Int {
        return filteredVehicleList.count
    }
    
    func getVehicleAtIndex(index: Int) -> String {
        return filteredVehicleList[index]
    }

    func fetchVehicleList() {
        self.vehicleList = ["Aspire 1.3", "Belina L 1.8/ 1.6", "Corcel II L", "Del Rey L 1.8 / 1.6 2p e 4p", "Mustang GT V8"]
        self.filterData(searchText: "")
    }

    func filterData(searchText: String) {
        self.filteredVehicleList = self.vehicleList.filter { element -> Bool in

            if searchText.isEmpty {
                return true
            }

//            let nameExists = element.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            let nameExists = element.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil

            return nameExists
        }
    }
}
