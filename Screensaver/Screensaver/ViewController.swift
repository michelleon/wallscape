//
//  ViewController.swift
//  Screensaver
//
//  Created by Michelle Leon on 11/26/15.
//  Copyright © 2015 Michelle Leon. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var tempDisplay: UILabel!
    @IBOutlet weak var cityDisplay: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    var timer = NSTimer()
    var brain = ScreensaverBrain()
    let locationManager = CLLocationManager()
    let weatherKey = "30b27f2565d58ab08511efd9652d8500"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayTime()
        changeImage()
        
        //Initializing location services
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
        
        // Getting weather data
        displayWeather(37.8717, lon: -122.2728) //TODO: remember to convert to double
        
        // recurring timer calls
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
            target: self,
            selector: Selector("displayTime"),
            userInfo: nil,
            repeats: true)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(120.0, target: self, selector: Selector("changeImage"), userInfo: nil, repeats: true)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3600.0, target: self, selector: Selector("displayWeather"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeImage() {
        let imgNum = Int(arc4random_uniform(40))
        print("chose \(imgNum)")
        background.image = UIImage(named: "wallpaper\(imgNum).jpeg");
    }
    
    func displayTime() {
        let curr_date = NSDate()
        //        let formatter = NSDateFormatter()
        //        formatter.timeStyle = .ShortStyle
        //        time.text! = formatter.stringFromDate(date)
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Month, .Day, .Year], fromDate: curr_date)
        var hour = components.hour
        let minutes = components.minute
        let month = monthByNum[components.month]
        let day = components.day
        let year = components.year
        
        if hour > 12 {
            hour = hour - 12
        }
        if minutes < 10 {
            time.text! = "\(hour):0\(minutes)"
        } else {
            time.text! = "\(hour):\(minutes)"
        }
        date.text! = "\(month!) \(day), \(year)"
        
        
    }
    
    private var monthByNum: [Int:String] = [
        1 : "January",
        2 : "February",
        3 : "March",
        4 : "April",
        5 : "May",
        6 : "June",
        7 : "July",
        8 : "August",
        9 : "September",
        10 : "October",
        11 : "November",
        12 : "December"
    ]
    
    private var iconByNum: [String:String] = [
        "01d" : "sun.png",
        "01n" : "moon.png",
        "02d" : "partly_cloudy.png",
        "02n" : "cloudy_night.png",
        "03d" : "clouds.png",
        "03n" : "clouds.png",
        "04d" : "clouds.png",
        "04n" : "clouds.png",
        "09d" : "rain.png",
        "09n" : "rain.png",
        "10d" : "rain.png",
        "10n" : "rain.png",
        "11d" : "lightning.png",
        "11n" : "lightning.png",
        "13d" : "rain_and_snow.png",
        "13n" : "rain_and_snow.png",
        "50d" : "clouds.png",
        "50n" : "clouds.png"
    ]

    private func getLabels(weatherData: NSData) {
        //        var jsonError: NSError?
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(weatherData, options: .AllowFragments)
            if let weather = json["weather"] as? [[String: AnyObject]] {
                //                if let id = weather["id"] as? Int {
                //                    var isWindy = false
                //                    if case 956...962 = id {
                //                        isWindy = true
                //                    }
                //                    if id == 905 {
                //                        isWindy = true
                //                    }
                //                }
                if let icon = weather[0]["icon"] as? String {
                    let icon_filename = iconByNum[icon]
                    weatherIcon.image = UIImage(named: icon_filename!);
                    print(icon_filename!) //Remove
                }
            }
            if let partial = json["main"] as? [String: AnyObject]
            {
                if let temp = partial["temp"] as? Double
                {
                    tempDisplay.text = String(format:"%.0f℉", temp) //TODO: Option to switch b/t celcius and fare
//                    print("\(temp)")
                }
            }
            if let city = json["name"] as? String {
                cityDisplay.text = city
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
        
    }
    
    func getWeatherData(urlString: String) {
        let url = NSURL(string: urlString)
//        print(urlString)
        print("\(url)")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) {
            (data, response, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), { self.getLabels(data!) })
            } else {
                print("error with NSURLSession")
            }
        }
        task.resume()
    }
    
    func displayWeather(lat:Double, lon:Double) {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=imperial&appid=\(weatherKey)"
        getWeatherData(urlString)
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        let lat = Int(locValue.latitude)
//        let lon = Int(locValue.longitude)
        let lat = Double(locValue.latitude)
        let lon = Double(locValue.longitude)
        displayWeather(lat, lon: lon)
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    

}

