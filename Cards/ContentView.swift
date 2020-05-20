////
////  ContentView.swift
////  Cards
////
////  Created by Isaac Raval on 5/19/20.
////  Copyright © 2020 Isaac Raval. All rights reserved.
////

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            VStack {
                CardView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CardView: View {
    @State var offset = CGSize.zero
    @State var dragging:Bool = false
    @State var tapped:Bool = false
    @State var tappedLocation:Int = -1
    @State var colors: [Color] = [.red, .blue, .green, .yellow, .orange, .pink, .white]
    @State var locationDragged:Int = -1
    var body: some View {
        GeometryReader { reader in
            ZStack {
                ForEach(0..<4) {i in
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
            .frame(width: reader.size.width - 80, height: 300).cornerRadius(20).shadow(radius: 20)
                
            .offset(y: (self.locationDragged == i) ? self.offset.height : CGFloat(i) * self.offset.height / 4)
                //                        .offset(y: (30 * CGFloat(i)))
                .offset(y: (self.tapped && self.tappedLocation != i) ? 700 : 0)
                .position(x: reader.size.width / 2, y: (self.tapped && self.tappedLocation == i) ? 150 : reader.size.height / 2)
                
                .onTapGesture() {
                    //show card
                    self.tapped.toggle()
                    self.tappedLocation = self.i
            }
                
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.locationDragged = self.i
                        print(self.i)
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
