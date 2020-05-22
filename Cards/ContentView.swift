//
//  ContentView.swift
//  Cards
//
//  Created by Isaac Raval on 5/19/20.
//  Copyright © 2020 Isaac Raval. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var allMainColors:[Color] = [.red, .blue, .black, .orange, .yellow, .green, .purple, .gray, .white]
    @State var hexColors: [Color] = [
        Color(hex: 0xB0E0E6),
        Color(hex: 0xADD8E6),
        Color(hex: 0x87CEFA),
        Color(hex: 0x87CEEB),
        Color(hex: 0x00BFFF),
        Color(hex: 0xB0C4DE),
        Color(hex: 0x1E90FF),
        Color(hex: 0x6495ED),
        Color(hex: 0x4682B4),
        Color(hex: 0x4169E1),
        Color(hex: 0x0000FF),
        Color(hex: 0x0000CD),
        Color(hex: 0x00008B),
        Color(hex: 0x000080),
        Color(hex: 0x191970),
        Color(hex: 0x7B68EE),
        Color(hex: 0x6A5ACD),
        Color(hex: 0x483D8B)
    ]
    @State var lastCardColor = Color.clear; @State var newCardColor = Color.clear
    @State var colors: [Color] = [.red, .blue, .green, .yellow]
    var body: some View {
        HStack {
            Button(action:{
                //Avoid duplicating the same color twice in a row
                self.newCardColor = self.hexColors.randomElement()!
                while(self.newCardColor == self.lastCardColor) {
                    self.newCardColor = self.hexColors.randomElement()!
                };self.lastCardColor = self.newCardColor
                
                self.colors.append(self.newCardColor) //insert at front
                /* self.colors.insert(self.newCardColor.randomElement()!, at: 0) //insert at back */
            }) {
                Text("+")
            }.offset(x: 730, y: -260)
            VStack {
                CardView(colors: self.$colors)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .position(x: 370, y: 300)
    }
}

struct CardView: View {
    @State var offset = CGSize.zero
    @State var dragging:Bool = false
    @State var tapped:Bool = false
    @State var tappedLocation:Int = -1
    @Binding var colors: [Color]
    @State var locationDragged:Int = -1
    var body: some View {
        GeometryReader { reader in
            ZStack {
                ForEach(0..<self.colors.count, id: \.self) { i in
                    ColorCard(reader:reader, i:i, colors: self.$colors, offset: self.$offset, tappedLocation: self.$tappedLocation, locationDragged:self.$locationDragged, tapped: self.$tapped, dragging: self.$dragging)
                }
            }
        }
        .animation(.spring())
        
    }
}

struct ColorCard: View {
    var reader: GeometryProxy
    var i:Int
    @Binding var colors: [Color]
    @Binding var offset: CGSize
    @Binding var tappedLocation:Int
    @Binding var locationDragged:Int
    @Binding var tapped:Bool
    @Binding var dragging:Bool
    var body: some View {
        VStack {
            VStack {
                self.colors[i]
            }
            .frame(width: reader.size.width - 80 - 100, height: 300).cornerRadius(20).shadow(radius: 20)
            .offset(y: (self.locationDragged == i) ? CGFloat(i) * self.offset.height / 4 : CGFloat(i) * self.offset.height / 4)
            .offset(y: (self.tapped && self.tappedLocation != i) ? 700 : 0)
            .position(x: reader.size.width / 2, y: (self.tapped && self.tappedLocation == i) ? -(30 * CGFloat(i)) + 300 : reader.size.height / 2)
                
                .onTapGesture() { //Show the card
                    self.tapped.toggle()
                    self.tappedLocation = self.i
            }
                
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.locationDragged = self.i
                        //                        print(self.i)
                        self.offset = gesture.translation
                        self.dragging = true
                }
                .onEnded { _ in
                    self.locationDragged = -1 //Reset
                    self.offset = .zero
                    self.dragging = false
                    self.tapped = false //enable drag to dismiss
                }
            )
        }.offset(y: (30 * CGFloat(i)))
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//Hex support
extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}
