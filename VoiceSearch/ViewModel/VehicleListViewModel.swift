//
//  VehicleListViewModel.swift
//  VoiceSearch
//
//  Created by Jorge de Carvalho on 15/05/23.
//

import Foundation
import Speech
import AVKit

protocol VehicleListViewModelDelegate {
    func onSuccess()
    func onError(error: String)
    func onChangeVoiceInput(input: String)
    func isVoiceButtonVisible(_ visibility: Bool)
}

class VehicleListViewModel {
    
    private var vehicleList: [Vehicle] = []
    private var filteredVehicleList: [Vehicle] = []
    private var voiceInput: String = ""
    
    var delegate: VehicleListViewModelDelegate?
    var voiceDelegate: SFSpeechRecognizerDelegate?

    let speechRecognizer        = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask         : SFSpeechRecognitionTask?
    let audioEngine             = AVAudioEngine()
    
    func getNumberOfRows() -> Int {
        return filteredVehicleList.count
    }
    
    func getVehicleAt(index: Int) -> Vehicle {
        return filteredVehicleList[index]
    }

    func getVoiceInput() -> String {
        return voiceInput
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
}

extension VehicleListViewModel {
    // MARK: Voice Recognition Functions

    // MARK: Action Method
    func btnStartSpeechToText() {

        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
//            self.btnStart.isEnabled = false
//            self.btnStart.setTitle("Start Recording", for: .normal)
        } else {
            self.voiceInput = ""
            self.startRecording()
//            self.btnStart.setTitle("Stop Recording", for: .normal)
        }
    }

    func setupSpeech() {

//        self.btnStart.isEnabled = false
        self.delegate?.isVoiceButtonVisible(false)
        self.speechRecognizer?.delegate = voiceDelegate

        SFSpeechRecognizer.requestAuthorization { (authStatus) in

            var isButtonEnabled = false

            switch authStatus {
            case .authorized:
                isButtonEnabled = true

            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")

            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")

            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")

            @unknown default:
                print("Speech recognition not yet authorized")

            }

            OperationQueue.main.addOperation() {
//                self.btnStart.isEnabled = isButtonEnabled
                self.delegate?.isVoiceButtonVisible(isButtonEnabled)
            }
        }
    }

    func startRecording() {

        // Clear all previous session data and cancel task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        // Create instance of audio session to record voice
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionRequest.shouldReportPartialResults = true

        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in

            var isFinal = false

            if result != nil {

//                self.lblText.text = result?.bestTranscription.formattedString
                print(result?.bestTranscription.formattedString ?? "")
                self.voiceInput = result?.bestTranscription.formattedString ?? ""
                self.delegate?.onChangeVoiceInput(input: result?.bestTranscription.formattedString ?? "")

                isFinal = (result?.isFinal)!
                if isFinal {
                    self.delegate?.onChangeVoiceInput(input: result?.bestTranscription.formattedString ?? "")
                    print("Is final result - \(result?.bestTranscription.formattedString ?? "")")
                }
            }

            if error != nil || isFinal {

                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

//                self.btnStart.isEnabled = true
                self.delegate?.isVoiceButtonVisible(true)
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        self.audioEngine.prepare()

        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }

//        self.lblText.text = "Say something, I'm listening!"
        print("Say something, I'm listening!")

    }
}
