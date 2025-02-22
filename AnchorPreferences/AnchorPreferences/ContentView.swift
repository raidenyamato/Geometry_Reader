//
//  ContentView.swift
//  PreferenceKey
//
//  Created by Raiden Yamato on 27.03.2024.
//

import SwiftUI

struct MyTextPreferenceKey: PreferenceKey {
    typealias Value = [MyTextPreferenceData]
    
    static var defaultValue: [MyTextPreferenceData] = []
    
    static func reduce(value: inout [MyTextPreferenceData], nextValue: () -> [MyTextPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct MyTextPreferenceData: Equatable {
    let viewIdx: Int
    var topLeading: Anchor<CGPoint>? = nil
    var bottomTrailing: Anchor<CGPoint>? = nil
}

struct MonthView: View {
    @Binding var activeMonth: Int
    let label: String
    let idx: Int
    
    var body: some View {
        Text(label)
            .padding(10)
            .anchorPreference(key: MyTextPreferenceKey.self, value: .topLeading, transform: { [MyTextPreferenceData(viewIdx: self.idx, topLeading: $0)] })
            .transformAnchorPreference(key: MyTextPreferenceKey.self, value: .bottomTrailing, transform: { (value: inout [MyTextPreferenceData], anchor: Anchor<CGPoint>) in
                value[0].bottomTrailing = anchor
            })
            .onTapGesture { self.activeMonth = self.idx }
    }
}


struct ContentView : View {
    
    @State private var activeIdx: Int = 0
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                MonthView(activeMonth: $activeIdx, label: "January", idx: 0)
                MonthView(activeMonth: $activeIdx, label: "February", idx: 1)
                MonthView(activeMonth: $activeIdx, label: "March", idx: 2)
                MonthView(activeMonth: $activeIdx, label: "April", idx: 3)
            }
            
            Spacer()
            
            HStack {
                MonthView(activeMonth: $activeIdx, label: "May", idx: 4)
                MonthView(activeMonth: $activeIdx, label: "June", idx: 5)
                MonthView(activeMonth: $activeIdx, label: "July", idx: 6)
                MonthView(activeMonth: $activeIdx, label: "August", idx: 7)
            }
            
            Spacer()
            
            HStack {
                MonthView(activeMonth: $activeIdx, label: "September", idx: 8)
                MonthView(activeMonth: $activeIdx, label: "October", idx: 9)
                MonthView(activeMonth: $activeIdx, label: "November", idx: 10)
                MonthView(activeMonth: $activeIdx, label: "December", idx: 11)
            }
            
            Spacer()
        }.backgroundPreferenceValue(MyTextPreferenceKey.self) { preferences in
            GeometryReader { geometry in
                self.createBorder(geometry, preferences)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
    }
    
    func createBorder(_ geometry: GeometryProxy, _ preferences: [MyTextPreferenceData]) -> some View {
        let p = preferences.first(where: { $0.viewIdx == self.activeIdx })
        
        let aTopLeading = p?.topLeading
        let aBottomTrailing = p?.bottomTrailing
        
        let topLeading = aTopLeading != nil ? geometry[aTopLeading!] : .zero
        let bottomTrailing = aBottomTrailing != nil ? geometry[aBottomTrailing!] : .zero
        
        
        return RoundedRectangle(cornerRadius: 15)
            .stroke(lineWidth: 3.0)
            .foregroundColor(Color.green)
            .frame(width: bottomTrailing.x - topLeading.x, height: bottomTrailing.y - topLeading.y)
            .fixedSize()
            .offset(x: topLeading.x, y: topLeading.y)
            .animation(.easeInOut(duration: 1.0), value: activeIdx)
    }
}

#Preview("ContentView", traits: .landscapeLeft, body: {
    ContentView()
})
    
       

