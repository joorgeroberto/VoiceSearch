//
//  VoiceSearchModal.swift
//  VoiceSearch
//
//  Created by Jorge de Carvalho on 16/05/23.
//

import UIKit
import Foundation

protocol VoiceSearchModalDelegate {
    func onStopRecord()
}

class VoiceSearchModal: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var voiceInputLabel: UILabel!
    var delegate: VoiceSearchModalDelegate?
    
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

        self.voiceInputLabel.textColor = UIColor(white: 100, alpha: 0.5)
    }

    func changeVoiceInput(voiceInput: String) {
        self.voiceInputLabel.text = voiceInput
        self.voiceInputLabel.textColor = UIColor(white: 255, alpha: 1.0)
    }

    @IBAction private func StopRecordButtonPressed(_ sender: UIButton) {
        self.delegate?.onStopRecord()
    }
    
}
