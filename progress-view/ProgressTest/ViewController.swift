//
//  ViewController.swift
//  ProgressTest
//
//  Created by Josh Bassett on 12/12/2014.
//  Copyright (c) 2014 Ferocia. All rights reserved.
//

import UIKit

public extension MyLayer {
  override class func needsDisplayForKey(key: String!) -> Bool {
    switch key {
    case "value":
      return true
    case "color":
      return true
    default:
      return super.needsDisplayForKey(key)
    }
  }

  override func actionForKey(key: String!) -> CAAction! {
    switch key {
    case "value":
      let animation = CABasicAnimation(keyPath: key)
      animation.fromValue = (self.presentationLayer() as CALayer).valueForKey(key)
//      let animation = RBBSpringAnimation(keyPath: key)
//      animation.fromValue = 0
//      animation.toValue = 1
      return animation
    default:
      return super.actionForKey(key)
    }
  }

  override func drawInContext(ctx: CGContext!) {
    super.drawInContext(ctx)

    UIGraphicsPushContext(ctx)
    self.drawProgressView(color: color, size: frame.size, value: value)
    UIGraphicsPopContext()
  }

  func drawProgressView(#color: UIColor, size: CGSize, value: CGFloat) {
    //// Variable Declarations
    let radius: CGFloat = size.height / 2.0
    let innerSize = CGSizeMake(size.width * max(min(value, 1), 0), size.height)
    let innerRadius: CGFloat = innerSize.height / 2.0

    //// Outer Rectangle Drawing
    let outerRectanglePath = UIBezierPath(roundedRect: CGRectMake(2, 2, (size.width - 4), (size.height - 4)), cornerRadius: radius)
    color.setStroke()
    outerRectanglePath.lineWidth = 1
    outerRectanglePath.stroke()


    //// Inner Rectangle Drawing
    let innerRectanglePath = UIBezierPath(roundedRect: CGRectMake(4, 4, (innerSize.width - 8), (innerSize.height - 8)), cornerRadius: innerRadius)
    color.setFill()
    innerRectanglePath.fill()
    color.setStroke()
    innerRectanglePath.lineWidth = 1
    innerRectanglePath.stroke()
  }
}

class ProgressView: UIView {
  required init(coder: NSCoder) {
    super.init(coder: coder)
    progressLayer.needsDisplayOnBoundsChange = true
    progressLayer.contentsScale = UIScreen.mainScreen().scale
    progressLayer.color = tintColor
  }

  var progressLayer: MyLayer {
    get {
      return layer as MyLayer
    }
  }

  var value: CGFloat = 0 {
    didSet {
      progressLayer.value = value
    }
  }

  override class func layerClass() -> AnyClass {
    return MyLayer.self
  }

  class var valueProperty: POPAnimatableProperty {
    get {
      return POPAnimatableProperty.propertyWithName("value", initializer: { (property: POPMutableAnimatableProperty!) in
        property.readBlock = { (view, values) in
          let progressView = view as ProgressView
          values[0] = progressView.value
        }
        property.writeBlock = { (view, values) in
          let progressView = view as ProgressView
          progressView.value = values[0]
        }
        property.threshold = 0.01
      }) as POPAnimatableProperty
    }
  }
}

class ViewController: UIViewController {
  @IBOutlet weak var progressView: ProgressView!

  @IBAction func didTapButton(sender: AnyObject) {
    CATransaction.setAnimationDuration(0.3)
    progressView.value = CGFloat(Float(arc4random()) /  Float(UInt32.max))
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
//    let animation = POPSpringAnimation()
//    animation.property = ProgressView.valueProperty
//    animation.springSpeed = 5
//    animation.springBounciness = 20
//    animation.toValue = 1
//    progressView.pop_addAnimation(animation, forKey: "lol")
  }
}
