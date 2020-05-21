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
    @State var lastCardColor = Color.clear; @State var newCardColor = Color.clear
    @State var colors: [Color] = [.red, .blue, .green, .yellow]
    var body: some View {
            HStack {
                Button(action:{
                    //Avoid duplicating the same color twice in a row
                    self.newCardColor = self.allMainColors.randomElement()!
                    while(self.newCardColor == self.lastCardColor) {
                        self.newCardColor = self.allMainColors.randomElement()!
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
                
            .offset(y: (self.locationDragged == i) ? self.offset.height : CGFloat(i) * self.offset.height / 4)
                //                        .offset(y: (30 * CGFloat(i)))
                .offset(y: (self.tapped && self.tappedLocation != i) ? 700 : 0)
                .position(x: reader.size.width / 2, y: (self.tapped && self.tappedLocation == i) ? 150 + 100 : reader.size.height / 2)
                
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
