//
//  TodayWeatherView.swift
//  LocationWeatherApp
//
//  Created by tomoki kusunoki on 2022/08/13.
//

import SwiftUI


struct ChosenWeatherPageView: View {
    var selectedPage : Pages = .TodaysWeather
    var lantitude : Double = 0
    var longitude : Double = 0
    
    var currentWeathercode  : Int = 0
    var currentTemparature   : Float = 0
    var dateOfWeek   : Array<String> = []
    var weathercodeOfWeek   : Array<Int> = []
    var maxTemparatureOfWeek : Array<Float> = []
    var minTemparatureOfWeek : Array<Float> = []
    
    var body: some View {
        switch selectedPage {
        case .TodaysWeather:
            TodayWeatherView(
                currentWeathercode: currentWeathercode,
                currentTemparature: currentTemparature,
                todayWeathercode: weathercodeOfWeek.first,
                todayMinTemparature: minTemparatureOfWeek.first,
                todayMaxTemparature: maxTemparatureOfWeek.first
            )
        case .WeeklyWeather:
            WeeklyWeatherView(dateOfWeek: dateOfWeek, weathercodeOfWeek: weathercodeOfWeek, maxTemparatureOfWeek: maxTemparatureOfWeek, minTemparatureOfWeek: minTemparatureOfWeek)
        }
    }
}

struct ChosenWeatherPageView_Previews: PreviewProvider {
    static var previews: some View {
        ChosenWeatherPageView()
    }
}

struct TodayWeatherView: View {
    var currentWeathercode : Int?
    var currentTemparature : Float?
    var todayWeathercode : Int?
    var todayMinTemparature : Float?
    var todayMaxTemparature : Float?
    
    var body: some View {
        ScrollView {
            VStack {
                if currentWeathercode != nil && currentTemparature != nil && todayWeathercode != nil && todayMinTemparature != nil && todayMaxTemparature != nil {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height:1)
                    
                    HStack {
                        Text("Present")
                            .font(.system(.largeTitle, design: .rounded))
                        Spacer()
                        Text(String(format: "%.1f??", currentTemparature!))
                            .font(.system(.largeTitle, design: .rounded))
                    }.padding()
                    
                    VStack {
                        HStack {
                            Text("Weathercode")
                                .frame(width: 120)
                            Text("Description")
                            Spacer()
                        }
                        HStack {
                            Text(String(format: "%d", currentWeathercode!))
                                .frame(width: 120)
                            Text(descriptorByWeathercode[currentWeathercode!]!)
                            Spacer()
                        }
                    }.padding()
                    
                    
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height:1)
                    
                    
                    
                    HStack {
                        Text("Today")
                            .font(.system(.largeTitle, design: .rounded))
                        Spacer()
                        Text(String(format: "Max: %.1f??", todayMaxTemparature!))
                        Text(String(format: "Min: %.1f??", todayMinTemparature!))
                    }.padding()
                    
                    VStack {
                        HStack {
                            Text("Weathercode")
                                .frame(width: 120)
                            Text("Description")
                            Spacer()
                        }
                        HStack {
                            Text(String(format: "%d", todayWeathercode!))
                                .frame(width: 120)
                            Text(descriptorByWeathercode[todayWeathercode!]!)
                            Spacer()
                        }
                    }.padding()
                    
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height:1)
                    
                    Spacer()
                }
            }
        }
        .padding()
    }
}

struct TodayWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        TodayWeatherView(currentWeathercode: 0, currentTemparature: 0.0)
    }
}

struct WeeklyWeatherView: View {
    var dateOfWeek   : Array<String>
    var weathercodeOfWeek   : Array<Int>
    var maxTemparatureOfWeek : Array<Float>
    var minTemparatureOfWeek : Array<Float>
    

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                // 10??, 20??, 30?? ???????????????.
                ForEach(1...3 , id:\.self) { i in
                    LineGraph( plotsX:[0, 1],
                               plotsY:[Float(i*10),Float(i*10)],
                               graphXMax: 0 ,
                               graphXMin: 1 ,
                               graphYMax: (maxTemparatureOfWeek.max() == nil ? 0 : maxTemparatureOfWeek.max()!) + 5,
                               graphYMin: (minTemparatureOfWeek.min() == nil ? 0 : minTemparatureOfWeek.min()!) - 5,
                               graphColor: Color.gray
                    )
                }
                let xDataLabels : Array<String> = dateOfWeek.map{
                    $0.components(separatedBy: "-").count == 3 ? ($0.components(separatedBy: "-")[1] + "/" + $0.components(separatedBy: "-")[2]) : ""
                }
                // ?????????????????????????????????.
                LineGraph( plotsX:Array(stride(from: 0.0, through: Float(minTemparatureOfWeek.count-1), by: 1.0)),
                           plotsY:minTemparatureOfWeek,
                           graphXMax: -0.5 ,
                           graphXMin: Float(minTemparatureOfWeek.count-1)+0.5,
                           graphYMax: (maxTemparatureOfWeek.max() == nil ? 0 : maxTemparatureOfWeek.max()!) + 5,
                           graphYMin: (minTemparatureOfWeek.min() == nil ? 0 : minTemparatureOfWeek.min()!) - 5,
                           graphColor: Color.blue,
                           lineWidth: 2,
                           hasPlotDot: true,
                           xDataLabels: xDataLabels
                )
                // ?????????????????????????????????.
                LineGraph( plotsX:Array(stride(from: 0.0, through: Float(maxTemparatureOfWeek.count-1), by: 1.0)),
                           plotsY:maxTemparatureOfWeek,
                           graphXMax: -0.5 ,
                           graphXMin: Float(minTemparatureOfWeek.count-1)+0.5,
                           graphYMax: (maxTemparatureOfWeek.max() == nil ? 0 : maxTemparatureOfWeek.max()!) + 5,
                           graphYMin: (minTemparatureOfWeek.min() == nil ? 0 : minTemparatureOfWeek.min()!) - 5,
                           graphColor: Color.red,
                           lineWidth: 2,
                           hasPlotDot: true

                )
                
                Rectangle()
                    .fill(Color.clear)
                    .border(Color.black, width: 1)
            }
            .clipped()
            .frame(height: 100)
            
            ScrollView {
                VStack{
                    HStack {
                        Text("Date")
                            .frame(width: 50)
                        Text("Weather description")
                        Spacer()
                        Text("Max[??]")
                            .frame(width: 60)
                        Text("Min[??]")
                            .frame(width: 60)
                    }
                    
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height:1)
                    
                    if dateOfWeek.count > 0 && weathercodeOfWeek.count == dateOfWeek.count && maxTemparatureOfWeek.count == dateOfWeek.count && minTemparatureOfWeek.count == dateOfWeek.count  {
                        ForEach(0...(weathercodeOfWeek.count-1) , id:\.self) { i in
                            HStack {
                                Text(dateOfWeek[i])
                                    .frame(width: 50)
                                Text(descriptorByWeathercode[weathercodeOfWeek[i]]!)
                                    .lineLimit(10)
                                Spacer()
                                Text(String(format: "%.1f", maxTemparatureOfWeek[i]))
                                    .frame(width: 60)
                                Text(String(format: "%.1f", minTemparatureOfWeek[i]))
                                    .frame(width: 60)
                            }
                            Rectangle()
                                .fill(Color.gray)
                                .frame(height:1)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct WeeklyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyWeatherView(dateOfWeek: ["8/11","8/12","8/13","8/14","8/15","8/16","8/17"], weathercodeOfWeek: [0,0,0,0,0,0,0,], maxTemparatureOfWeek: [1,2,3,4,5,6,7], minTemparatureOfWeek: [1,2,3,4,5,6,7])
    }
}

struct LineGraph: View {
    var plotsX : Array<Float>
    var plotsY : Array<Float>
    var graphXMax : Float
    var graphXMin : Float
    var graphYMax : Float
    var graphYMin : Float
    var graphColor : Color = Color.black
    var lineWidth : CGFloat = 1.0
    var hasPlotDot : Bool = false
    // ????????????x?????????????????????????????????????????????????????????. (???????????????????????????????????????)
    var xDataLabels : Array<String> = []
    
    // preMap????????????mapped?????????????????????.
    private func mappedValue(_ preMapValue: Float, _ preMapMin: Float, _ preMapMax: Float, _ mappedMax: Float, _ mappedMin: Float) -> Float{
        return (preMapValue - preMapMin)/(preMapMax - preMapMin) * (mappedMax - mappedMin) + mappedMin
    }
    
    // min - max ????????????????????????????????????????????????)??????????????????.
    private func symmetryValueBetweenMinMax(_ value: Float, _ min: Float, _ max: Float) -> Float{
        return max - (value - min)
    }
    
    // ???????????????X?????????????????????X???????????????.
    private func graphXToViewX(_ graphX: Float, _ graphXMin : Float, _ graphXMax : Float, _ viewXSize : Float) -> Float {
        return mappedValue(graphX, graphXMin, graphXMax, 0, viewXSize)
    }
    
    // ???????????????Y?????????????????????Y???????????????.
    private func graphYToViewY(_ graphY: Float, _ graphYMin : Float, _ graphYMax : Float, _ viewYSize : Float) -> Float {
        //        return symmetryValueBetweenMinMax(
        //            mappedValue(graphY, graphYMin, graphYMax, 0, viewYSize),
        //            0, viewYSize)
        return mappedValue(graphY, graphYMin, graphYMax, 0, viewYSize)
    }
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                if plotsX.count != plotsY.count { return }
                let viewXSize = Float(geometry.size.width)
                let viewYSize = Float(geometry.size.height)
                
                // ????????????XY??????????????????????????????Path??????
                for i in 0..<plotsY.count {
                    let xPoint = Int(round(graphXToViewX(
                        plotsX[i], graphXMin, graphXMax, viewXSize
                    )))
                    let yPoint = Int(round(graphYToViewY(
                        plotsY[i], graphYMin, graphYMax, viewYSize
                    )))
                    let point = CGPoint(x:xPoint, y:yPoint)
                    
                    if i == 0 {
                        path.move(to: point)
                    } else {
                        path.addLine(to: point)
                    }
                }
            }
            .stroke(graphColor, lineWidth:lineWidth)
            .frame(width: CGFloat(geometry.size.width), height: CGFloat(geometry.size.height))
            
            if hasPlotDot && plotsY.count > 0 && plotsX.count == plotsY.count {
                let viewXSize = Float(geometry.size.width)
                let viewYSize = Float(geometry.size.height)
                let dotSize = Float(lineWidth+4.0)
                ForEach (0...(plotsY.count-1), id:\.self) { i in
                    // ????????????XY??????????????????.
                    let xPoint = graphXToViewX(
                        plotsX[i], graphXMin, graphXMax, viewXSize
                    )
                    let yPoint = graphYToViewY(
                        plotsY[i], graphYMin, graphYMax, viewYSize
                    )
                    
                    
                    Rectangle ()
                        .fill(graphColor)
                        .frame(width: CGFloat(dotSize), height: CGFloat(dotSize))
                        .position(
                            x: CGFloat(xPoint),
                            y: CGFloat(yPoint)
                        )
                }
            }
            if xDataLabels.count > 0 {
                let labelNum = xDataLabels.count < plotsX.count ? xDataLabels.count : plotsX.count
                let viewXSize = Float(geometry.size.width)
                
                ForEach (0...(labelNum-1), id:\.self) { i in
                    let xPoint = graphXToViewX(
                        plotsX[i], graphXMin, graphXMax, viewXSize
                    )
                    Text(xDataLabels[i])
                        .font(.system(.footnote, design: .rounded))
                        .position(x: CGFloat(xPoint), y:geometry.size.height - 8)
                }
            }
        }
    }
}

// From WMO Weathercodes.
let descriptorByWeathercode : [Int: String] = [
    00 : "Cloud development not observed or not observable *",
    01 : "Clouds generally dissolving or becoming less developed *",
    02 : "State of sky on the whole unchanged *",
    03 : "Clouds generally forming or developing *",
    04 : "Visibility reduced by smoke, e.g. veldt or forest fires, industrial smoke or volcanic ashes",
    05 : "Haze",
    06 : "Widespread dust in suspension in the air, not raised by wind at or near the station at the time of observation",
    07 : "Dust or sand raised by wind at or near the station at the time of observation, but no well developed dust whirl(s) or sand whirl(s), and no duststorm or sandstorm seen",
    08 : "Well developed dust whirl(s) or sand whirl(s) seen at or near the station during the preceding hour or at the time ot observation, but no duststorm or sandstorm",
    09 : "Duststorm or sandstorm within sight at the time of observation, or at the station during the preceding hour",
    10 : "Mist",
    11 : "Patches of shallow fog or ice fog at the station, whether on land or sea, not deeper than about 2 metres on land or 10 metres at sea",
    12 : "More or less continuous shallow fog or ice fog at the station, whether on land or sea, not deeper than about 2 metres on land or 10 metres at sea",
    13 : "Lightning visible, no thunder heard",
    14 : "Precipitation within sight, not reaching the ground or the surface of the sea",
    15 : "Precipitation within sight, reaching the ground or the surface of the sea, but distant (i.e. estimated to be more than 5 km) from the station",
    16 : "Precipitation within sight, reaching the ground or the surface of the sea, near to, but not at the station",
    17 : "Thunderstorm, but no precipitation at the time of observation",
    18 : "Squalls at or within sight of the station during the preceding hour or at the time of observation",
    19 : "Funnel cloud(s)** at or within sight of the station during the preceding hour or at the time of observation",
    20 : "Drizzle (not freezing) or snow grains not falling as shower(s)",
    21 : "Rain (not freezing) not falling as shower(s)",
    22 : "Snow not falling as shower(s)",
    23 : "Rain and snow or ice pellets, type (a) not falling as shower(s)",
    24 : "Freezing drizzle or freezing rain not falling as shower(s)",
    25 : "Shower(s) of rain",
    26 : "Shower(s) of snow, or of rain and snow",
    27 : "Shower(s) of hail*, or of rain and hail*",
    28 : "Fog or ice fog",
    29 : "Thunderstorm (with or without precipitation)",
    30 : "Slight or moderate duststorm or sandstorm - has decreased during the preceding hour",
    31 : "Slight or moderate duststorm or sandstorm - no appreciable change during the preceding hour",
    32 : "Slight or moderate duststorm or sandstorm - has begun or has increased during the preceding hour",
    33 : "Severe duststorm or sandstorm - has decreased during the preceding hour",
    34 : "Severe duststorm or sandstorm - no appreciable change during the preceding hour",
    35 : "Severe duststorm or sandstorm - has begun or has increased during the preceding hour",
    36 : "Slight or moderate blowing snow generally low (below eye level)",
    37 : "Heavy drifting snow generally low (below eye level)",
    38 : "Slight or moderate blowing snow generally high (above eye level)",
    39 : "Heavy drifting snow generally high (above eye level)",
    40 : "Fog or ice fog at a distance at the time of observation, but not at the station during the preceding hour, the fog or ice fog extending to a level above that of the observer",
    41 : "Fog or ice fog in patches",
    42 : "Fog or ice fog, sky visible has become thinner during the preceding hour",
    43 : "Fog or ice fog, sky invisible has become thinner during the preceding hour",
    44 : "Fog or ice fog, sky visible no appreciable change during the preceding hour",
    45 : "Fog or ice fog, sky invisible no appreciable change during the preceding hour",
    46 : "Fog or ice fog, sky visible has begun or has become thicker during the preceding hour",
    47 : "Fog or ice fog, sky invisible has begun or has become thicker during the preceding hour",
    48 : "Fog, depositing rime, sky visible",
    49 : "Fog, depositing rime, sky invisible",
    50 : "Drizzle, not freezing, intermittent slight at time of observation",
    51 : "Drizzle, not freezing, continuous slight at time of observation",
    52 : "Drizzle, not freezing, intermittent moderate at time of observation",
    53 : "Drizzle, not freezing, continuous moderate at time of observation",
    54 : "Drizzle, not freezing, intermittent heavy (dence) at time of observation",
    55 : "Drizzle, not freezing, continuous heavy (dence) at time of observation",
    56 : "Drizzle, freezing, slight",
    57 : "Drizzle, freezing, moderate or heavy (dence)",
    58 : "Drizzle and rain, slight",
    59 : "Drizzle and rain, moderate or heavy",
    60 : "Rain, not freezing, intermittent slight at time of observation",
    61 : "Rain, not freezing, continuous slight at time of observation",
    62 : "Rain, not freezing, intermittent moderate at time of observation",
    63 : "Rain, not freezing, continuous moderate at time of observation",
    64 : "Rain, not freezing, intermittent heavy at time of observation",
    65 : "Rain, not freezing, continuous heavy at time of observation",
    66 : "Rain, freezing, slight",
    67 : "Rain, freezing, moderate or heavy",
    68 : "Rain, or drizzle and snow, slight",
    69 : "Rain, or drizzle and snow, moderate or heavy",
    70 : "Intermittent fall of snow flakes slight at time of observation",
    71 : "Continuous fall of snow flakes slight at time of observation",
    72 : "Intermittent fall of snow flakes moderate at time of observation",
    73 : "Continuous fall of snow flakes moderate at time of observation",
    74 : "Intermittent fall of snow flakes heavy at time of observation",
    75 : "Continuous fall of snow flakes heavy at time of observation",
    76 : "Ice prisms (with or without fog)",
    77 : "Snow grains (with or without fog)",
    78 : "Isolated starlike snow crystals (with or without fog)",
    79 : "Ice pellets, type (a)",
    80 : "Rain shower(s), slight",
    81 : "Rain shower(s), moderate or heavy",
    82 : "Rain shower(s), violent",
    83 : "Shower(s) of rain and snow mixed, slight",
    84 : "Shower(s) of rain and snow mixed, moderate or heavy",
    85 : "Snow shower(s), slight",
    86 : "Snow shower(s), moderate or heavy",
    87 : "Shower(s) of snow pellets or ice pellets, type (b), with or without rain or rain and snow mixed - slight",
    88 : "Shower(s) of snow pellets or ice pellets, type (b), with or without rain or rain and snow mixed - moderate or heavy",
    89 : "Shower(s) of hail*, with or without rain or rain and snow mixed, not associated with thunder - slight",
    90 : "Shower(s) of hail*, with or without rain or rain and snow mixed, not associated with thunder - moderate or heavy",
    91 : "Slight rain at time of observation - thunderstorm during the preceding hour but not at time of observation",
    92 : "Moderate or heavy rain at time of observation - thunderstorm during the preceding hour but not at time of observation",
    93 : "Slight snow, or rain and snow mixed or hail** at time of observation - thunderstorm during the preceding hour but not at time of observation",
    94 : "Moderate or heavy snow, or rain and snow mixed or hail** at time of observation - thunderstorm during the preceding hour but not at time of observation",
    95 : "Thunderstorm, slight or moderate, without hail**, but with rain and/or snow at time of observation - thunderstorm at time of observation",
    96 : "Thunderstorm, slight or moderate, with hail** at time of observation - thunderstorm at time of observation",
    97 : "Thunderstorm, heavy, without hail**, but with rain and/or snow at time of observation - thunderstorm at time of observation",
    98 : "Thunderstorm combined with duststorm or sandstorm at time of observation - thunderstorm at time of observation",
    99 : "Thunderstorm, heavy, with hail** at time of observation - thunderstorm at time of observation"
]
