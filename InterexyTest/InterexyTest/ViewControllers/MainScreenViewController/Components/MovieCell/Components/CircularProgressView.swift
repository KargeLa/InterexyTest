//
//  CircularProgressView.swift
//  InterexyTest
//
//  Created by Алексей Смоляк on 15.01.23.
//

import UIKit

final class CircularProgressView: UIView {
    
    /*
     MARK: -
     */
    
    private lazy var circleLayer : CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.fillColor = UIColor.clear.cgColor
        shape.lineCap = .round
        shape.lineWidth = 3.0
        shape.strokeColor = UIColor(named: "Color_2")?.cgColor
        return shape
        
    }()
    
    
    
    private lazy var progressLayer : CAShapeLayer = {
        let progress = CAShapeLayer()
        progress.fillColor = UIColor.clear.cgColor
        progress.lineCap = .round
        progress.lineWidth = 3.0
        progress.strokeEnd = 0
        progress.strokeColor = UIColor(named: "Color_1")?.cgColor
        return progress
    }()
    
    /*
     MARK: -
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    
    
    
    override func layoutSubviews() {
        updatePath()
    }
    
    /*
     MARK: -
     */
    
    private func createCircularPath() {
        updatePath()
        
        
        
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
    }
    
    
    
    private func updatePath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
                                        radius: 18,
                                        startAngle: -.pi / 2,
                                        endAngle: 3 * .pi / 2,
                                        clockwise: true)
        
        circleLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
    }
}

/*
 MARK: -
 */

extension CircularProgressView {
    func progressAnimation(_ percentage: Int) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = 1
        circularProgressAnimation.toValue = Float(Float(percentage) / 100)
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
        progressLayer.strokeColor = getColors(for: percentage).0.cgColor
        circleLayer.strokeColor = getColors(for: percentage).1.cgColor
    }
    
    private func getColors(for progress: Int) -> (UIColor, UIColor) {
        var colors: (_ : UIColor, _ : UIColor)
        if progress <= 20 {
            colors = (UIColor(named: "Color_5")!, UIColor(named: "Color_6")!)
        } else if progress > 20 && progress < 70 {
            colors = (UIColor(named: "Color_3")!, UIColor(named: "Color_4")!)
        } else {
            colors = (UIColor(named: "Color_1")!, UIColor(named: "Color_2")!)
        }
        return colors
    }
}
