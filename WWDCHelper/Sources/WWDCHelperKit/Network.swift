//
//  Network.swift
//  WWDCHelperKit
//
//  Created by kingcos on 08/09/2017.
//
//

import Foundation

struct Network {
    
    static let shared = Network()
    
    func fetchContent(of url: String) -> String {
        let request = URLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        
        var result = ""
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error!.localizedDescription)
                return
            }
            result = String(data: data, encoding: .ascii) ?? ""
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        return result
    }
}
