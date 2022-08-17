//
//  LocationWeatherAppService.swift
//  LocationWeatherApp
//
//  Created by tomoki kusunoki on 2022/08/16.
//

import SwiftUI
import CoreLocation
import Foundation


struct OpenMeteoReturnJson : Codable{
    //    var latitude                             :Float
    //    var longitude                            :Float
    //    var generationtime_ms                    :Float
    //    var utc_offset_seconds                   :Int
    //    var timezone                             :String
    //    var timezone_abbreviation                :String
    //    var elevation                            :Float
    var current_weather                      :CurrentWeather
//    var daily_units                          :DailyUnits
    var daily                                :Daily
}
struct CurrentWeather : Codable {
    var temperature                      :Float
    //    var windspeed                        :Float
    //    var winddirection                    :Float
    var weathercode                      :Int
//    var time                             :String
    
}

//struct DailyUnits : Codable{
//    var time                             :String
//    var weathercode                      :[Int]
//    var temperature_2m_max               :[Float]
//    var temperature_2m_min               :[Float]
//
//}

struct Daily : Codable {
    var time                : [String]
    var weathercode         : [Int]
    var temperature_2m_max  : [Float]
    var temperature_2m_min  : [Float]
}

// 位置情報取得用クラス.
class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate{
    // アプリへの位置情報関連のイベントの配信を開始および停止するために使用するオブジェクト.
    var locationManager : CLLocationManager?
    // 直近の緯度.
    @Published var currentLatitude : CLLocationDegrees?
    // 直近の軽度.
    @Published var currentLongitude : CLLocationDegrees?
    
    // WebAPIリクエスト結果.
    // TODO: 初期値をnilに変更
    @Published var currentWeathercodes  : Int = 0
    @Published var currentTemparature   : Float = 0
    
    @Published var dateOfWeek           : Array<String> = []
    @Published var weathercodeOfWeek    : Array<Int> = []
    @Published var maxTemparatureOfWeek : Array<Float> = []
    @Published var minTemparatureOfWeek : Array<Float> = []
    
    override init() {
        print("\(#function)")
        // NSObject初期化.
        super.init()
        
        locationManager = CLLocationManager()
        
        // CLLocationManagerの通知対象に自インスタンスを設定.
        locationManager!.delegate = self
        
        locationManager!.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            //精度３km（かなり低め に設定している）
            locationManager!.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager!.distanceFilter = 10
            
            requestUpdateLocation()
        }
        return
    }
    
    // 位置情報更新リクエスト.
    public func requestUpdateLocation() {
        print("\(#function)")
        currentLatitude = nil
        currentLongitude = nil
        locationManager!.requestLocation() // notify to func locationManager.
    }
    
    // エラー対応.
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    // 状態変化通知.
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager!.requestLocation()
        }
    }
    
    //位置情報に変化があった場合の処理（今回は単純に緯度と軽度を出力する）
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("\(#function)")
        
        guard let newLocation = locations.last else {
            return
        }
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        print("緯度: \(location.latitude), 経度: \(location.longitude)")
        currentLatitude = location.latitude
        currentLongitude = location.longitude
        
        getLocationWeatherApp(latitude: location.latitude, longitude: location.longitude)
    }
    
    
    private func createWeatherInfoRequestUrl(latitude : Double, longitude : Double) -> String {
        let requestUrl = "https://api.open-meteo.com/v1/forecast?latitude=\(String(format:"%f", latitude))&longitude=\(String(format:"%f", longitude))&daily=weathercode,temperature_2m_max,temperature_2m_min&current_weather=true&timezone=Asia%2FTokyo"
        print (requestUrl)
        return requestUrl
    }
    
    private func getLocationWeatherApp(latitude : Double, longitude : Double) {
        let requestUrl = URL(string: createWeatherInfoRequestUrl(latitude: latitude, longitude: longitude))
        // TODO: nilチェック.
        let request = URLRequest(url: requestUrl!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // print("--------response---------")
            // print("data:")
            // print(data)
            // print("response:")
            // print(response)
            // print("error:")
            // print(error)
            // print("-------------------------")
            self.updateWeatherInfomationByRawJson(data!)
        }.resume()
    }
    
    // TODO: エラー返却.
    // TODO: 値返却.(Not member write)
    private func updateWeatherInfomationByRawJson(_ rawJsonData : Data) {
        let str = String(data: rawJsonData, encoding: .utf8)
        print(str)
        do {
            let openMeteoReturnJson = try JSONDecoder().decode(OpenMeteoReturnJson.self, from:rawJsonData)
            self.currentTemparature = openMeteoReturnJson.current_weather.temperature
            self.currentWeathercodes = openMeteoReturnJson.current_weather.weathercode
            self.maxTemparatureOfWeek = openMeteoReturnJson.daily.temperature_2m_max
            self.minTemparatureOfWeek = openMeteoReturnJson.daily.temperature_2m_min
            self.weathercodeOfWeek = openMeteoReturnJson.daily.weathercode
            self.dateOfWeek = openMeteoReturnJson.daily.time
            
        }
        catch {
            // TODO: エラー対応.
            print("invalid json convert")
            print(error)
            print(error.localizedDescription)
            return
        }
        
    }
}

