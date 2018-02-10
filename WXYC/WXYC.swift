import Foundation

extension URL {
    static var WXYCPlaylist: URL {
        return URL(string: "http://wxyc.info/playlists/recentEntries?v=2&n=15")!
    }
    
    static var WXYCStream: URL {
        return URL(string: "http://audio-mp3.ibiblio.org:8000/wxyc.mp3")!
    }
}
    
public protocol PlaylistItem: Comparable {
    var id: Int { get }
    var hour: Int { get }
    var chronOrderID: Int { get }
}

public extension PlaylistItem {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.chronOrderID == rhs.chronOrderID
    }
    
    static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.chronOrderID < rhs.chronOrderID
    }
}

public struct Playcut: PlaylistItem, Codable, Equatable {
    public let id: Int
    public let hour: Int
    public let chronOrderID: Int
    public let request: Bool = false
    public let songTitle: String
    public let labelName: String?
    public let artistName: String
    public let releaseTitle: String?
}

extension Playcut {
    func userActivityState() -> NSUserActivity {
        let activity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        let url: String! = "https://www.google.com/search?q=\(artistName)+\(songTitle)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        activity.webpageURL = URL(string: url)
        
        return activity
    }
}

struct Talkset: PlaylistItem, Codable, Equatable {
    let id: Int
    let hour: Int
    let chronOrderID: Int
}

struct Breakpoint: PlaylistItem, Codable, Equatable {
    let id: Int
    let hour: Int
    let chronOrderID: Int
}

struct Playlist: Codable, Equatable {
    static func ==(lhs: Playlist, rhs: Playlist) -> Bool {
        return lhs.playcuts == rhs.playcuts
            && lhs.talksets == rhs.talksets
            && lhs.breakpoints == rhs.breakpoints
    }
    
    let playcuts: [Playcut]
    let talksets: [Talkset]
    let breakpoints: [Breakpoint]
}
