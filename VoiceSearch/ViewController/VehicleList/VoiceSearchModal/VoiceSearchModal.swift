//
//  VoiceSearchModal.swift
//  VoiceSearch
//
//  Created by Jorge de Carvalho on 16/05/23.
//

import UIKit
import Foundation

class VoiceSearchModal: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stopButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("VoiceSearchModal", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        self.configureView()
    }

    private func configureView() {
        self.stopButton.layer.cornerRadius = 50
        self.stopButton.layer.masksToBounds = true
    }
    
}
