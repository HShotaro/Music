//
//  MusicPlayerManager.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/29.
//

import UIKit
import Combine
import AVFoundation

class MusicPlayerManager: ObservableObject {
    static let shared = MusicPlayerManager()
    init() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch  {
            fatalError("音楽再生モード設定失敗")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidPlayToEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    
    @objc private func itemDidPlayToEnd() {
        if playerQueue != nil, let currentTrack = currentTrack {
            guard let index = (audioTracks.firstIndex { $0.id == currentTrack.id}),
                  index + 1 < audioTracks.count else {
                startPlayback()
                return
            }
            playerQueue?.advanceToNextItem()
            self.currentTrack = audioTracks[index+1]
        }
        
    }
    
    @Published var currentTrack: AudioTrackModel?
    @Published var onPlaying = false
    
    var audioTracks = [AudioTrackModel]() {
        didSet {
            guard !audioTracks.isSameOf(oldValue) else {
                return
            }
            startPlayback()
        }
    }
    
    private var playerQueue: AVQueuePlayer?
    private func startPlayback() {
        self.audioTracks = self.audioTracks.shuffled()
        playerQueue = nil
        let items: [AVPlayerItem] = self.audioTracks.compactMap {
            guard let url = $0.previewURL else { return nil }
            return AVPlayerItem(url: url)
        }
        self.playerQueue = AVQueuePlayer(items: items)
        self.playerQueue?.play()
        self.onPlaying = true
        self.currentTrack = self.audioTracks.first
    }
    
    func backButtonSelected() {
        if let currentItem = playerQueue?.currentItem, let currentTrack = currentTrack {
            guard let url = currentTrack.previewURL
            else { return }
            playerQueue?.insert(AVPlayerItem(url: url), after: currentItem)
            
            playerQueue?.remove(currentItem)
        }
    }
    
    func playButtonSelected() {
        if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
                self.onPlaying = false
            } else if player.timeControlStatus == .paused {
                player.play()
                self.onPlaying = true
            }
        }
    }
    
    func nextButtonSelected() {
        if playerQueue != nil, let currentTrack = currentTrack {
            guard let index = (audioTracks.firstIndex { $0.id == currentTrack.id}),
                  index + 1 < audioTracks.count else {
                startPlayback()
                return
            }
            playerQueue?.advanceToNextItem()
            self.currentTrack = audioTracks[index+1]
        }
    }
}
