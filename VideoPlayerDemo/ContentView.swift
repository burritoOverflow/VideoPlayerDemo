//
//  ContentView.swift
//  VideoPlayerDemo
//
//  Created by Standard on 7/12/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PickerView()
    }
}

struct PickerView: View {
    @State var currentVideoName = "MacroSeedling"
    // set each section for the title of the videos
    var flowerVideos = ["MacroSeedling"]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.purple,.black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack {
                Spacer()
                VStack {
                    
                    Text("Watch Videos")
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .padding(.init(top: 35, leading: 0, bottom: 5, trailing: 0))
                    
                    // add a vstack per section
                    VStack {
                        SetPlayer(video: currentVideoName)
                    }
                    
                    Text("Choose a video")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Picker(selection: $currentVideoName, label: Text("")) {
                        
                        ForEach(self.flowerVideos, id: \.self) { name in
                            SummerSymbol(name: name)
                        }
                        
                    }.pickerStyle(WheelPickerStyle())
                    .offset(x: 15)
                    .frame(width: 300, height: 150)
                    .background(Color.red.colorMultiply(.blue))
                    .foregroundColor(Color.purple)
                    .cornerRadius(15)
                    .shadow(color: .white, radius: 5, x: 0, y: 0)
                    .padding()
                }
            } // end vstack
        }.edgesIgnoringSafeArea(.all) // end zstack; overlay the gradient over the entire screen
    } // end body
    
}

struct SetPlayer: View{
    @State var video: String = String()
    
    var body: some View {
        VStack {
            Text("Playing \(self.video)")
                .font(.caption2)
                .foregroundColor(.white)
                .bold()
            
            PlayerAndControlsView(url: URL(fileURLWithPath: Bundle.main.path(forResource: video, ofType: ".mp4")!))
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
