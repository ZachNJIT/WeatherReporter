//
//  WeatherModel.swift
//  Weather Reporter
//


import Foundation


struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let description: String
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String{
        switch conditionId {
        case 200...202:
            return "048-storm-2" //Thunderstorm with rain
        case 210...221:
            return "049-storm-3" //Thunderstorm
        case 230...232:
            return "048-storm-2" //Thunderstorm with drizzle
        case 300...321:
            return "008-drizzle"    //drizzle
        case 500...531:
            return "002-rain"    //rain
        case 600...602:
            return "014-snow"    //Snow
        case 611...616:
            return "026-snowflake-1" //Sleet
        case 620...622:
            return "050-snow-2"  //shower snow
        case 701...721:
            return "025-haze"    //Mist, Smoke, Haze
        case 731:
            return "031-dust"
        case 741:
            return "005-foggy"
        case 751...771:
            return "031-dust"     //Sand Dust Ash Squall Tornado
        case 781:
            return "039-tornado"
        case 800:
            return "034-sun"      //clear sky
        case 801...803:
            return "023-cloudy-1"  //few, borken, scattered clouds
        case 804:
            return "015-cloudy"    //overcast clouds
        default:
            return "001-cloud"
        }
    }
        
}
