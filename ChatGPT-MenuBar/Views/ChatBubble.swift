//
//  ChatBubble.swift
//  ios14-demo
//
//  Created by Prafulla Singh on 25/7/20.
//
import SwiftUI

struct ChatBubble<Content>: View where Content: View {
    enum Direction {
        case left
        case right
    }

    let direction: Direction
    let content: () -> Content
    init(direction: Direction, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.direction = direction
    }

    var body: some View {
        HStack {
            if direction == .right {
                Spacer()
                    .frame(minWidth: 100)
            }
            content().clipShape(RoundedRectangle(cornerSize: .init(width: 20, height: 20)))
            if direction == .left {
                Spacer()
                    .frame(minWidth: 100)
            }
        }
    }
}

struct Demo: View {
    var body: some View {
        ScrollView {
            VStack {
                ChatBubble(direction: .left) {
                    Text("Hello!")
                        .padding(.all, 5)
                        .foregroundColor(Color.white)
                        .background(Color.secondary)
                }
                ChatBubble(direction: .right) {
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ut semper quam. Phasellus non mauris sem. Donec sed fermentum eros. Donec pretium nec turpis a semper. ")
                        .padding(.all, 10)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                }
            }
        }
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        Demo()
    }
}
