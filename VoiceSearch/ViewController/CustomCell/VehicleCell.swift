//
//  VehicleCell.swift
//  VoiceSearch
//
//  Created by Jorge de Carvalho on 15/05/23.
//

import UIKit
import Foundation

class VehicleCell: UITableViewCell {
    @IBOutlet weak var vehicleNameLabel: UILabel!

    func configure(vehicleName: String) {
        self.vehicleNameLabel.text = vehicleName
    }
}
