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
        guard queuePlayer != nil else { return }
        // 最後の曲の場合に呼ばれる
        guard let index = (audioTracks.firstIndex { $0.id == _currentTrackStrage?.id}),
              index + 1 < audioTracks.count else {
            startPlayback()
            return
        }
        queuePlayer?.advanceToNextItem()
        updateCurrentTrack()
    }
    
    private func updateCurrentTrack() {
        self.currentTrack = _currentTrackStrage
    }
    
    private var _currentTrackStrage: AudioTrackModel? {
        get {
            guard let queuePlayer = queuePlayer else { return nil }
            guard let currentAssetUrl = (queuePlayer.currentItem?.asset as? AVURLAsset)?.url else { return nil }
            return audioTracks.first { $0.previewURL == currentAssetUrl }
        }
    }
    
    @Published var currentTrack: AudioTrackModel?
    @Published var onPlaying = false
    @Published var expanding = false
    
    var audioTracks = [AudioTrackModel]() {
        didSet {
            guard !audioTracks.isSameOf(oldValue) else {
                return
            }
            startPlayback()
        }
    }
    
    var isFirstTrack: Bool {
        return currentTrack == audioTracks.first
    }
    
    private var queuePlayer: AVQueuePlayer?
    
    func showMusicPlayer(tracks: [AudioTrackModel]) {
        DispatchQueue.global().async { [weak self] in
            self?.audioTracks = tracks
        }
        expanding = true
    }
    private func startPlayback() {
        self.audioTracks = self.audioTracks.shuffled()
        DispatchQueue.main.async { [weak self] in
            self?.onPlaying = true
            self?.currentTrack = self?.audioTracks.first
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.queuePlayer = nil
            let items: [AVPlayerItem] = (self?.audioTracks ?? []).compactMap {
                guard let url = $0.previewURL else { return nil }
                return AVPlayerItem(url: url)
            }
            self?.queuePlayer = AVQueuePlayer(items: items)
            self?.queuePlayer?.play()
        }
    }
    
    func backButtonSelected() {
        if !isFirstTrack {
            guard let index = (audioTracks.firstIndex { $0.id == _currentTrackStrage?.id}),
                  index-1 >= 0 else {
                return
            }
            guard let prevUrl = audioTracks[index-1].previewURL,
                  let currentUrl = audioTracks[index].previewURL
            else { return }
            let prevItem = AVPlayerItem(url: prevUrl)
            queuePlayer?.insert(prevItem, after: queuePlayer?.currentItem)
            queuePlayer?.insert(AVPlayerItem(url: currentUrl), after: prevItem)
            if let currentItem = queuePlayer?.currentItem {
                queuePlayer?.remove(currentItem)
            }
            self.updateCurrentTrack()
        }
    }
    
    func playButtonSelected() {
        DispatchQueue.global().async { [weak self] in
            if let player = self?.queuePlayer {
                if player.timeControlStatus == .playing {
                    player.pause()
                    DispatchQueue.main.async {
                        self?.onPlaying = false
                    }
                } else if player.timeControlStatus == .paused {
                    player.play()
                    DispatchQueue.main.async {
                        self?.onPlaying = true
                    }
                }
            }
        }
    }
    
    func nextButtonSelected() {
        guard queuePlayer != nil else { return }
        // 最後の曲の場合に呼ばれる
        guard let index = (audioTracks.firstIndex { $0.id == _currentTrackStrage?.id}),
              index + 1 < audioTracks.count else {
            startPlayback()
            return
        }
        queuePlayer?.advanceToNextItem()
        updateCurrentTrack()
    }
    
    func willSignOut() {
        queuePlayer = nil
        currentTrack = nil
        onPlaying = false
        expanding = false
        audioTracks = []
    }
}
