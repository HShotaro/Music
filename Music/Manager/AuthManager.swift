//
//  AuthManager.swift
//  Music
//
//  Created by Shotaro Hirano on 2021/08/24.
//

import Foundation
import Combine

class AuthManager: ObservableObject {
    struct Constants {
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    static let shared = AuthManager()
    
    private init() {}
    
    var signInURL: URL? {
        
        //            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(SPOTIFY_CLIENT_ID)&scope=\(Constants.scopes)&redirect_uri=\(REDIRECT_URI)"
        return URL(string: string)
    }
    
    @Published private(set) var isSignIn = UserDefaults.standard.string(forKey: "access_token") != nil
    
    private var accsssToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "access_token")
        }
        
        set {
            isSignIn = newValue != nil
        }
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinute: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinute) >= expirationDate
    }
    
    public func exchangeCodeForToken(code: String) {
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: REDIRECT_URI)
        ]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        let basicToken = SPOTIFY_CLIENT_ID+":"+SPOTIFY_CLIENT_SECRET
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.httpBody = components.query?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                self?.isSignIn = true
            } catch {
                
            }
        }
        
        task.resume()
    }
    
    public func withValidToken() -> AnyPublisher<String?, Never> {
        if shouldRefreshToken {
            return self.refreshIfNeeded()
            .flatMap { success -> Future<String?, Never> in
                return Future<String?, Never> { [weak self] promise in
                    if success, let token = self?.accsssToken {
                        promise(.success(token))
                    } else {
                        promise(.success(nil))
                    }
                }
            }.eraseToAnyPublisher()
        } else if let token = accsssToken {
            return Future<String?, Never> { promise in
                promise(.success(token))
            }
            .eraseToAnyPublisher()
        } else {
            return Future<String?, Never> { promise in
                promise(.success(nil))
            }.eraseToAnyPublisher()
        }
    }
    
    public func refreshIfNeeded() -> AnyPublisher<Bool, Never> {
        return Future<Bool, Never> { [weak self] promise in
            guard self?.shouldRefreshToken == true else {
                promise(.success(true))
                return
            }
            guard let refreshToken = self?.refreshToken else {
                return
            }
            
            guard let url = URL(string: Constants.tokenAPIURL) else { return }
            
            var components = URLComponents()
            components.queryItems = [
                URLQueryItem(name: "grant_type", value: "refresh_token"),
                URLQueryItem(name: "refresh_token", value: refreshToken)
            ]
            
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
            let basicToken = SPOTIFY_CLIENT_ID+":"+SPOTIFY_CLIENT_SECRET
            let data = basicToken.data(using: .utf8)
            guard let base64String = data?.base64EncodedString() else {
                promise(.success(false))
                return
            }
            request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
            request.httpBody = components.query?.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    promise(.success(false))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                    self?.cacheToken(result: result)
                    promise(.success(true))
                } catch {
                    promise(.success(false))
                }
            }
            
            task.resume()
            
        }.eraseToAnyPublisher()
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(_:TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
    
    public func signOut(completion: @escaping (Bool) -> Void) {
        UserDefaults.standard.setValue(nil, forKey: "access_token")
        UserDefaults.standard.setValue(nil, forKey: "refresh_token")
        UserDefaults.standard.setValue(nil, forKey: "expirationDate")
        completion(true)
    }
}
