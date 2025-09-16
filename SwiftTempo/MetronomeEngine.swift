//
//  MetronomeEngine.swift
//  SwiftTempo
//
//  Created by ongiaf on 2025/8/28.
//

import AVFoundation
import Foundation

final class MetronomeEngine: ObservableObject {
    @Published var bpm: Int = 120
    @Published var signatureLower: Int = 4
    @Published var signatureUpper: Int = 4
    @Published var isRunning: Bool = false

    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()

    private var accentBuffer: AVAudioPCMBuffer!
    private var normalBuffer: AVAudioPCMBuffer!

    private let queue = DispatchQueue(label: "metronome.timer.queue", qos: .userInitiated)
    private var timer: DispatchSourceTimer?

    private var nextBeatTime: Double = 0
    private var beatIndexInBar: Int = 0

    private var unitInterval: Double {
        let beatsPerSecond = Double(bpm) / 60.0
        return 4.0 / (beatsPerSecond * Double(signatureLower))
    }

    init() {
        setupAudio()
    }

    private func setupAudio() {
        engine.attach(player)
        let main = engine.mainMixerNode
        engine.connect(
            player, to: main,
            format: AVAudioFormat(
                standardFormatWithSampleRate: engine.outputNode.outputFormat(forBus: 0).sampleRate,
                channels: 1)!)

        accentBuffer = ClickGenerator.generate(
            frequency: 2200,
            duration: 0.015,
            sampleRate: 44100,
            amplitude: 0.9)
        normalBuffer = ClickGenerator.generate(
            frequency: 1600,
            duration: 0.010,
            sampleRate: 44100,
            amplitude: 0.5)

        do {
            try engine.start()
        } catch {
            print("Audio engine start failed: \(error)")
        }
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true

        beatIndexInBar = 0
        nextBeatTime = CFAbsoluteTimeGetCurrent()

        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now(), repeating: .milliseconds(1), leeway: .milliseconds(0))
        timer.setEventHandler { [weak self] in
            self?.tickLoop()
        }
        self.timer = timer
        timer.resume()
    }

    func stop() {
        guard isRunning else { return }
        isRunning = false
        timer?.cancel()
        timer = nil
    }

    private func tickLoop() {
        let now = CFAbsoluteTimeGetCurrent()
        while now + 0.0005 >= nextBeatTime {
            playOneUnit()
            nextBeatTime += unitInterval
        }
    }

    private func playOneUnit() {
        let isAccent = (beatIndexInBar == 0)
        let buffer = isAccent ? accentBuffer! : normalBuffer!
        player.scheduleBuffer(buffer, at: nil, options: .interruptsAtLoop, completionHandler: nil)
        if !player.isPlaying {
            player.play()
        }
        beatIndexInBar += 1
        if beatIndexInBar >= signatureUpper {
            beatIndexInBar = 0
        }
    }
}
