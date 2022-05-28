//
//  Emmiter.swift
//  MOBT-8-Animations
//
//  Created by Mykyta Babanin on 28.05.2022.
//

import UIKit

class Emitter {
    private enum Consts {
        static let cellBirthRate: Float = 1
        static let cellLifetime: Float = 50
        static let cellVelocity: CGFloat = 25
        static let cellEmissionLongtitude = CGFloat(180 * (CGFloat.pi / 180))
        static let cellEmissionRange: CGFloat = (45 * (CGFloat.pi / 180))
        static let cellScale: CGFloat = 0.8
        static let cellScaleRange: CGFloat = 0.4
    }
    
    static func get(with image: UIImage) -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitter.emitterCells = generateEmitterCells(with: image)
        return emitter
    }
    
    static func generateEmitterCells(with image: UIImage) -> [CAEmitterCell] {
        var cells = [CAEmitterCell]()
        let cell = CAEmitterCell()
        cell.contents = image.cgImage
        cell.birthRate = Consts.cellBirthRate
        cell.lifetime = Consts.cellLifetime
        cell.velocity = Consts.cellVelocity
        cell.emissionLongitude = Consts.cellEmissionLongtitude
        cell.emissionRange = Consts.cellEmissionRange
        cell.scale = Consts.cellScale
        cell.scaleRange = Consts.cellScaleRange
        
        cells.append(cell)
        
        return cells
    }
}
