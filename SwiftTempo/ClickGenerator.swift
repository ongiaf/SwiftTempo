//
//  ClickGenerator.swift
//  SwiftTempo
//
//  Created by ongiaf on 2025/8/28.
//

import AVFoundation

enum ClickGenerator {
    static func generate(
        frequency: Double,
        duration: Double,
        sampleRate: Double,
        amplitude: Double
    ) -> AVAudioPCMBuffer {
        let frameCount = AVAudioFrameCount(duration * sampleRate)
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
        buffer.frameLength = frameCount

        let thetaInc = 2.0 * Double.pi * frequency / sampleRate
        var theta = 0.0

        let ptr = buffer.floatChannelData![0]
        for i in 0..<Int(frameCount) {
            let envelope = exp(-8.0 * Double(i) / Double(frameCount))
            let sample = Float(sin(theta) * amplitude * envelope)
            ptr[i] = sample
            theta += thetaInc
        }
        return buffer
    }
}
