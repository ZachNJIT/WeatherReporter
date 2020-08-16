//
//  WeatherManager.swift
//  Weather Reporter
//


import Foundation
import CoreLocation

var geocoder = CLGeocoder()
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=84dde353cf2757e657ef9075598771c2&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(addr: String!)
    {
        geocoder.geocodeAddressString(addr) { placemarks, error in
            let placemark = placemarks?.first
            if let location = placemark?.location {
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                //print("\(lat), \(lon)")
                self.fetchWeather(latitude: lat, longitude: lon)
            }
        }
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
            
        }
        
    }
    
    
func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = (decodedData.weather[0].id)
            let temp = decodedData.main.temp
            let name = decodedData.name
            let desc = decodedData.weather[0].description
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, description: desc)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }

    }


