//
//  SwiftTempoApp.swift
//  SwiftTempo
//
//  Created by ongiaf on 2025/8/28.
//

import SwiftUI

@main
struct EternalTempoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
