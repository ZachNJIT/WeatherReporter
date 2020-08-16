//
//  HourlyForecast.swift
//  Weather Reporter
//


import Foundation
import CoreLocation
import MapKit


protocol HourlyForecastDelegate {
    func didUpdateHourly(_ hourlyForecast: HourlyForecast, weathers: [WeatherFModel])
    func didFailWithError(error: Error)
}


struct HourlyForecast {
let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?"
let appid = "84dde353cf2757e657ef9075598771c2&units=imperial"

var delegate: HourlyForecastDelegate?

func fetchHourly(addr: String!)
{
    geocoder.geocodeAddressString(addr) { placemarks, error in
        let placemark = placemarks?.first
        if let location = placemark?.location {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            self.fetchHourly(latitude: lat, longitude: lon)
        }
    }
}

func fetchHourly(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let urlString = "\(weatherURL)lat=\(latitude)&lon=\(longitude)&appid=\(appid)"
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
                if let weathers = self.parseJSON(safeData) {
                    self.delegate?.didUpdateHourly(self, weathers: weathers)
                }
            }
        }
        
        task.resume()
        
    }
}

func parseJSON(_ hourlyFData: Data) -> [WeatherFModel]?{
    let decoder = JSONDecoder()
    do {
        let decodedData = try decoder.decode(HourlyFData.self, from: hourlyFData)
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: decodedData.lat, longitude: decodedData.lon)
        print(decodedData.lat)
        var cname = "Name Not Found"
        geoCoder.reverseGeocodeLocation(location, completionHandler:
            {
                placemarks, error -> Void in
                // Place details
                guard let placeMark = placemarks?.first else { return }
                // City
                if let city = placeMark.locality {
                    cname = city
                }
        })
        var weatherFModels = [WeatherFModel]()
        for hour in decodedData.hourly{
            let tem = hour.temp
            let dt = hour.dt
            let press = hour.pressure
            let humi = hour.humidity
            let id = (hour.weather[0].id)
            let desc = hour.weather[0].description
            let weather = WeatherModel(conditionId: id, cityName: cname, temperature: tem, description: desc)
            weatherFModels.append(WeatherFModel(dateTime: dt, cityName: cname, pressure: press, humidity: humi, weather: weather))
        }
        return weatherFModels
        
    } catch {
        delegate?.didFailWithError(error: error)
        return nil
    }
    
}

}


