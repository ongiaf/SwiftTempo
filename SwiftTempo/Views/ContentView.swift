//
//  ContentView.swift
//  SwiftTempo
//
//  Created by ongiaf on 2025/8/28.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var engine = MetronomeEngine()
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("BPM").font(.headline).frame(width: 50, alignment: .leading)
                Spacer()
                TextField("BPM", value: $engine.bpm, format: .number)
                    .monospacedDigit()
                    .frame(width: 50, alignment: .trailing)
            }.frame(width: 220)

            HStack {
                Text("Signature").font(.headline)
                Spacer()
                TextField("SignatureUpper", value: $engine.signatureUpper, format: .number)
                    .monospacedDigit()
                    .frame(width: 25, alignment: .trailing)
                Text("/")
                TextField("SignatureLower", value: $engine.signatureLower, format: .number)
                    .monospacedDigit()
                    .frame(width: 25, alignment: .trailing)
            }.frame(width: 220)

            Button(engine.isRunning ? "Stop" : "Start") {
                engine.isRunning ? engine.stop() : engine.start()
            }
            .keyboardShortcut(.space, modifiers: [])
            .frame(width: 220)
        }
        .padding(16)
    }
}
