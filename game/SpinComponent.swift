//
//  SpinComponent.swift
//  game
//
//  Created by dongha lee on 2/6/26.
//

import RealityKit

/// A component that spins the entity around a given axis.
struct SpinComponent: Component {
    let spinAxis: SIMD3<Float> = [0, 1, 0]
}
