//
//  Page.swift
//  Music
//
//  Created by Shotaro Hirano on 2022/10/22.
//

import Foundation

enum SMPageDestination: Hashable {
    case mypage
    case albumDetail(album: AlbumModel)
    case playlistDetail(playlistID: String, isOwner: Bool)
    case artistDetail(artistID: String)
    case authView
    
}
