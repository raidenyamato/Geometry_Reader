//
//  ContentView.swift
//  GeometryReader to the Rescue
//
//  Created by Raiden Yamato on 28.03.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello There!")
            BlueRectangle()
            RedRectangle()
            
        }
        .frame(width: 150, height: 100)
        .border(Color.black)
    }
}


struct BlueRectangle: View {
    var body: some View {
        Rectangle().fill(Color.blue)
    }
}

struct RedRectangle: View {
    var body: some View {
        GeometryReader{ geometry in
            Rectangle()
                .path(in: CGRect(x: geometry.size.width + 5, y: 0, width: geometry.size.width / 2.0, height:  geometry.size.height / 2.0))
                .fill(Color.red)
        }
    }
}

#Preview {
    ContentView()
}
