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
        displayWeather(35, lon: 139)
        
        // recurring timer calls
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
            target: self,
            selector: Selector("displayTime"),
            userInfo: nil,
            repeats: true)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(120.0, target: self, selector: Selector("changeImage"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeImage() {
        let imgNum = Int(arc4random_uniform(30))
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

    func getLabels(weatherData: NSData) {
        //        var jsonError: NSError?
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(weatherData, options: .AllowFragments)
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
            if let weather = json["weather"] as? [String: AnyObject] {
                if let icon = weather["icon"] as? String {
                    switch icon {
                        case "01d":
                            weatherIcon.image = UIImage(named: "wallpaper\(imgNum).png");
                        case "01n":
                        case "02d":
                        case "02n":
                        case "03d":
                        case "03n":
                        case "04d":
                        case "04n":
                        case "09d":
                        case "09n":
                        case "10d":
                        case "10n":
                        case "11d":
                        case "11n":
                        case "13d":
                        case "13n":
                        case "50d":
                        case "50n":
                        
                    }
                    
                }
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
    
    func displayWeather(lat:Int, lon:Int) {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=imperial&appid=\(weatherKey)"
        getWeatherData(urlString)
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let lat = Int(locValue.latitude)
        let lon = Int(locValue.longitude)
        displayWeather(lat, lon: lon)
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    

}

