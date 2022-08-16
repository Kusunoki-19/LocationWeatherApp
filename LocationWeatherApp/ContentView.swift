//
//  ContentView.swift
//  LocationWeatherApp
//
//  Created by tomoki kusunoki on 2022/08/13.
//

import SwiftUI

// ページ一覧.
enum Pages : String , CaseIterable , Identifiable {
    case TodaysWeather   = "Today's Weather"
    case WeeklyWeather   = "Weekly Weather"
    
    var id: Self { self }
}


struct ContentView: View {
    // 選択中ページ.
    @State private var selectedPage : Pages = Pages.TodaysWeather
    
    @ObservedObject private var locationService : LocationService = LocationService()
    
    init() {
        return
    }
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ChosenWeatherPageView(
                selectedPage: selectedPage,
                currentWeathercode: locationService.currentWeathercodes,
                currentTemparature: locationService.currentTemparature,
                weathercodeOfWeek: locationService.weathercodeOfWeek,
                maxTemparatureOfWeek: locationService.maxTemparatureOfWeek,
                minTemparatureOfWeek: locationService.minTemparatureOfWeek
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            VStack {
                Button("Get Location \(Image(systemName: "location.square.fill"))",action: locationService.requestUpdateLocation).padding()
                HStack {
                    VStack {
                        Text("緯度")
                        Text("経度")
                        Text("直近気温")
                        Text("直近天気")
                    }
                    VStack {
                        Text(String(format: "%.5f", locationService.currentLatitude != nil ? locationService.currentLatitude! : 0))
                        Text(String(format: "%.5f", locationService.currentLongitude != nil ? locationService.currentLongitude! : 0))
                        Text(String(format: "%f", locationService.currentTemparature))
                        Text(String(format: "%d", locationService.currentWeathercodes))
                   }
                }
            }
            ,alignment: .topTrailing)
        .overlay(
            Picker("Page", selection: $selectedPage) {
                ForEach(Pages.allCases) { page in
                    Text(page.rawValue)
                }
            }.pickerStyle(.segmented)
            ,alignment: .bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
