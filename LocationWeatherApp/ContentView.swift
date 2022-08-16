//
//  ContentView.swift
//  LocationWeatherApp
//
//  Created by tomoki kusunoki on 2022/08/13.
//

import SwiftUI

// ページ一覧.
enum Pages : String , CaseIterable , Identifiable {
    case TodaysWeather   = "Today"
    case WeeklyWeather   = "Week"
    
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
        
        // main content.
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
        
        // Top overlay.
        .overlay(
            HStack {
                Picker("Page", selection: $selectedPage) {
                    ForEach(Pages.allCases) { page in
                        Text(page.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 150)
                
                Spacer()
                
                VStack {
                    HStack {
                        Button("\(Image(systemName: "arrow.clockwise"))",action: locationService.requestUpdateLocation).padding()
                        VStack {
                            Text("latitude")
                            Text("longitude")
                        }
                        VStack {
                            Text(String(format: "%.2f", locationService.currentLatitude != nil ? locationService.currentLatitude! : 0))
                            Text(String(format: "%.2f", locationService.currentLongitude != nil ? locationService.currentLongitude! : 0))
                        }
                    }
                }
            }.padding()
            ,alignment: .top
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
