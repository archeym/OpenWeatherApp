//
//  WeatherViewController.swift
//  OpenWeatherApp
//
//  Created by Arkadijs Makarenko on 28/04/2023.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var openWeather: OpenWeather?
    let openWeatherModel = OpenWeatherModel()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            print("long: \(location.coordinate.longitude), lat: \(location.coordinate.latitude)")
            
            let long = String(location.coordinate.longitude)
            let lat = String(location.coordinate.latitude)
            
            let params: [String: String] = ["lat": lat, "lon": long, "appid": openWeatherModel.apiId]
            getWeatherData(url: openWeatherModel.apiUrl, params: params)
        }
    }
    

    func getWeatherData(url: String, params: [String: String] ){
        AF.request(url, method: .get, parameters: params).responseData { response in
            if response.value != nil {
                do {
                    let jsonData = try JSONDecoder().decode(OpenWeather.self, from: response.value!)
                    self.openWeather = jsonData
                    self.updateWeather(data: self.openWeather!)
                } catch {
                    print("err::::", error)
                }
            }else{
                self.cityLabel.text = "Weather Unavailible 😢"
            }
        }
    }//getWeatherData
    
    func updateWeather(data: OpenWeather){
        if let result = data.main?.temp {
            cityLabel.text = "\(data.name ?? "")" + ", \(data.sys?.country ?? "")"
            tempLabel.text = "\(Int(result - 273)) º"
            data.weather?.forEach({ weath in
                weatherIcon.image = UIImage(named: openWeatherModel.updateWeatherIcon(condition: weath.id ?? 0))
            })
        }else{
            self.cityLabel.text = "Weather Unavailible 😢"
        }
    }//updateWeather
    
    
    func userEnterCityName(city: String) {
        print(city)
        let params: [String: String] = ["q": city, "appid": openWeatherModel.apiId]
        
        getWeatherData(url: openWeatherModel.apiUrl, params: params)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "city" {
            let vc = segue.destination as! ChangeCityViewController
            vc.delegate = self
        }
    }

}

