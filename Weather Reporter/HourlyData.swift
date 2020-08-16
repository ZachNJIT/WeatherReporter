//  Weather7Data.swift
//  Weather Reporter
//


import Foundation

struct HourlyFData: Codable {
    let lat: Double
    let lon: Double
    let hourly: [HourlyData]
}

struct HourlyCity: Codable {
    let id: Int
    let name: String
}

struct HourlyData: Codable {
    let dt: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let weather: [Weather]
}

