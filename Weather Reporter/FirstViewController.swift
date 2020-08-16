//
//  FirstViewController.swift
//  Weather Reporter
//


import UIKit
import CoreLocation

class FirstViewController: UIViewController {

  
        @IBOutlet weak var conditionImageView: UIImageView!
        @IBOutlet weak var temperatureLabel: UILabel!
        @IBOutlet weak var cityLabel: UILabel!
        @IBOutlet weak var searchTextField: UITextField!
        @IBOutlet weak var descriptionLabel: UILabel!
    
        var weatherManager = WeatherManager()
        let locationManager = CLLocationManager()
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            weatherManager.delegate = self
            searchTextField.delegate = self
        }

        @IBAction func locationPressed(_ sender: UIButton) {
            locationManager.requestLocation()
        }
        

 
    
    }

    //MARK: - UITextFieldDelegate
    extension FirstViewController: UITextFieldDelegate {

        @IBAction func searchedPressed(_ sender: UIButton) {
             searchTextField.endEditing(true)
             print(searchTextField.text!)
         }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchTextField.endEditing(true)
            print(searchTextField.text!)
            return true
        }
        
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if textField.text != "" {
                return true
            }
            else {
                textField.placeholder = "Type something"
                return false
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            
            if let addr = searchTextField.text {
                weatherManager.fetchWeather(addr: addr)
            }
            
            searchTextField.text = ""
        }
    }

    extension FirstViewController: WeatherManagerDelegate {
        func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
            
            DispatchQueue.main.async { // Correct
                self.temperatureLabel.text = weather.temperatureString
                self.descriptionLabel.text = weather.description.capitalized
                //self.conditionImageView.image = UIImage(systemName: weather.conditionName)
                self.conditionImageView.image = UIImage(named: weather.conditionName)
                self.cityLabel.text = weather.cityName
            }
            
            
        }
        
        func didFailWithError(error: Error) {
            print(error)
        }

    }


    extension FirstViewController: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                locationManager.stopUpdatingLocation()
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                weatherManager.fetchWeather(latitude: lat, longitude: lon)
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }
}

