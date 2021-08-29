//
//  MusicPlayerViewModel.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import Foundation
import Combine

class MusicPlayerViewModel: ObservableObject {
    private var cancellable: AnyCancellable?
    @Published var currentTrack: AudioTrackModel?
    var audioTracks = [AudioTrackModel]() {
        didSet {
            currentTrack = audioTracks.first
        }
    }
    
}
