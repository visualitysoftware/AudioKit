//
//  AKFaderAudioUnit.swift
//  AudioKit
//
//  Created by Ryan Francesconi, revision history on Github.
//  Copyright © 2019 AudioKit. All rights reserved.
//

import AVFoundation

public class AKFaderAudioUnit: AKAudioUnitBase {
    var taper: Double = 1.0 {
        didSet { setParameter(.taper, value: taper) }
    }

    var skew: Double = 0.0 {
        didSet { setParameter(.skew, value: skew) }
    }

    var offset: Double = 0.0 {
        didSet { setParameter(.offset, value: offset) }
    }

    var leftGain: Double = 1.0 {
        didSet { setParameter(.leftGain, value: leftGain) }
    }

    var rightGain: Double = 1.0 {
        didSet { setParameter(.rightGain, value: rightGain) }
    }

    public override var canProcessInPlace: Bool { return true }

    public override func initDSP(
        withSampleRate sampleRate: Double,
        channelCount count: AVAudioChannelCount
    ) -> AKDSPRef {
        return createFaderDSP(Int32(count), sampleRate)
    }

    public override init(
        componentDescription: AudioComponentDescription,
        options: AudioComponentInstantiationOptions = []
    ) throws {
        try super.init(componentDescription: componentDescription, options: options)

        let leftGain = AUParameter(
            identifier: "leftGain",
            name: "Left Gain",
            address: 0,
            range: 0.0 ... 2.0,
            unit: .linearGain,
            flags: .default
        )

        let rightGain = AUParameter(
            identifier: "rightGain",
            name: "Right Gain",
            address: 1,
            range: 0.0 ... 2.0,
            unit: .linearGain,
            flags: .default
        )

        let taper = AUParameter(
            identifier: "taper",
            name: "Taper",
            address: 2,
            range: 0.1 ... 10.0,
            unit: .generic,
            flags: .default
        )

        let skew = AUParameter(
            identifier: "skew",
            name: "Skew",
            address: 3,
            range: 0.0 ... 1.0,
            unit: .generic,
            flags: .default
        )

        let offset = AUParameter(
            identifier: "offset",
            name: "Offset",
            address: 4,
            range: 0.0 ... 1000000000.0,
            unit: .generic,
            flags: .default
        )

        setParameterTree(AUParameterTree(children: [leftGain, rightGain, taper, skew, offset]))
        leftGain.value = 1.0
        rightGain.value = 1.0
        taper.value = 1.0
        skew.value = 0.0
        offset.value = 0.0
    }

    func setParameter(_ address: AKFaderParameter, value: Double) {
        setParameterWithAddress(address.rawValue, value: Float(value))
    }

    func setParameterImmediately(_ address: AKFaderParameter, value: Double) {
        setParameterImmediatelyWithAddress(address.rawValue, value: Float(value))
    }
}
