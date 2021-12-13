//
//  ContentView.swift
//  BadgeAnimations
//
//  Created by Chris Eidhof on 13.12.21.
//

import SwiftUI

extension View {
    func myAnimation(_ curve: Animation) -> some View {
        transaction { t in
            if !t.disablesAnimations {
                t.animation = curve
            }
        }
    }
}

struct ContentView: View {
    @State var value = 0
    @State var slow = false
    
    var body: some View {
        VStack {
            HStack {
                badge
                    .myAnimation(.default.speed(slow ? 0.1 : 1))
                badge
                    .transaction { print("Inner", $0, value) }
                    .animation(.default.speed(slow ? 0.1 : 1))
                    .transaction { print("Outer", $0, value) }
            }
            Button("Increment") {
                var t = Transaction(animation: .linear(duration: 2))
                t.disablesAnimations = true
                withTransaction(t) {
                    value += 1
                }
            }
            Toggle("Slow", isOn: $slow)
        }
        .padding(50)
    }
    
    @ViewBuilder var badge: some View {
        VStack {
            Text("\(value)")
                .monospacedDigit()
                .fixedSize()
                .padding(.horizontal)
                .background(Capsule().fill(Color.accentColor))
                .drawingGroup()
                .transition(.scale)
                .id(value)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
