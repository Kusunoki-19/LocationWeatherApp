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
        VStack() {
            HStack(alignment: .top) {
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
                                .font(.system(.footnote, design: .rounded))
                            Text("longitude")
                                .font(.system(.footnote, design: .rounded))

                        }
                        VStack {
                            Text(String(format: "%.1f..", locationService.currentLatitude != nil ? locationService.currentLatitude! : 0))
                                .font(.system(.footnote, design: .rounded))
                            Text(String(format: "%.1f..", locationService.currentLongitude != nil ? locationService.currentLongitude! : 0))
                                .font(.system(.footnote, design: .rounded))
                        }
                    }
                    Text("(Weathercode based on WMOWeathercode)")
                        .font(.system(.footnote, design: .rounded))
                }
            }.padding()
            
            ChosenWeatherPageView(
                selectedPage: selectedPage,
                currentWeathercode: locationService.currentWeathercodes,
                currentTemparature: locationService.currentTemparature,
                dateOfWeek: locationService.dateOfWeek,
                weathercodeOfWeek: locationService.weathercodeOfWeek,
                maxTemparatureOfWeek: locationService.maxTemparatureOfWeek,
                minTemparatureOfWeek: locationService.minTemparatureOfWeek
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
