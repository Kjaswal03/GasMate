//
//  GasStationService.swift
//  GasMate
//
//  Created by Kashev Jaswal on 6/7/24.
//

import Foundation

class GasStationService {
    private static let apiKey = "apify_api_UckYZdhUNNAHT3E9jZZShtHhkOa8Tk0cOuMC"
    private let baseUrl: String
    
    init() {
        self.baseUrl = "https://api.apify.com/v2/acts/natasha.lekh~gas-prices-scraper/run-sync-get-dataset-items?token=\(GasStationService.apiKey)"
    }
    
    func fetchGasStations(area: String, limit: Int=10, completion: @escaping ([GasStation]) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: baseUrl) else {
            print("Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.timeoutInterval = 600
        
        let requestBody: [String: Any] = [
            "location": area,
            "maxCrawledPlacesPerSearch": limit
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Error creating JSON body: \(error)")
            return nil
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                print("Request was cancelled")
                return
            }
            
            if let error = error {
                print("HTTP Request Failed: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let gasStations = try JSONDecoder().decode([GasStation].self, from: data)
                DispatchQueue.main.async {
                    completion(gasStations)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        dataTask.resume() // Start the task
        return dataTask // Return the task so it can be cancelled if needed
    }
}
