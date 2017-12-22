//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    var touchView = UIView()
    var outerCircle = UIView()
    var innerCircle = UIView()
    
    var recording : Bool = false
    
    let cyanColor = UIColor(red:0.23, green:0.76, blue:0.83, alpha:1.0)
    let outerColor = UIColor(red:0.85, green:0.95, blue:0.96, alpha:1.0)
    let innerColor = UIColor(red:0.73, green:0.91, blue:0.93, alpha:1.0)
    let CIRCLE_HEIGHT = 35
    let CIRCLE_RADIUS : CGFloat = 17.5
    
    override func loadView() {
  
        let voiceImage = UIImage(named: "voice-button.png")
        let imageView = UIImageView(image: voiceImage)
        imageView.frame = CGRect(x: 0, y: 0, width: CIRCLE_HEIGHT, height: CIRCLE_HEIGHT)

        setupCircles()
        
        var tapGenerator = UITapGestureRecognizer(target: self, action: #selector(MyViewController.onTap(_:)))
        
        touchView.backgroundColor = cyanColor
        touchView.isUserInteractionEnabled = true
        touchView.frame = CGRect(x: 175, y: 300, width: CIRCLE_HEIGHT, height: CIRCLE_HEIGHT)
        touchView.layer.cornerRadius = CIRCLE_RADIUS
        touchView.addGestureRecognizer(tapGenerator)
        touchView.addSubview(imageView)
        touchView.bringSubview(toFront: imageView)
        
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(innerCircle)
        view.addSubview(outerCircle)
        view.addSubview(touchView)
        
        self.view = view
    }
    
    @objc
    func onTap(_ sender : UITapGestureRecognizer) {
        if(!recording) {
            runAnimation(1.5, 2)
        } else {
            runAnimation(1,1)
        }
        recording = !recording
    }
    
    private func runAnimation(_ scaleInner : CGFloat, _ scaleOuter : CGFloat) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.scaleCircles(scaleInner, scaleOuter)
        }, completion: nil)
    }
    
    private func scaleCircles(_ scaleInner : CGFloat, _ scaleOuter : CGFloat) {
        self.outerCircle.transform = CGAffineTransform.init(scaleX: scaleOuter, y: scaleOuter)
        self.view.bringSubview(toFront: self.innerCircle)
        self.innerCircle.transform = CGAffineTransform.init(scaleX: scaleInner, y: scaleInner)
        self.view.bringSubview(toFront: self.touchView)
        self.view.layoutSubviews()
    }
    
    private func setupCircles() {
        
        outerCircle.frame = CGRect(x: 175, y: 300, width: CIRCLE_HEIGHT, height: CIRCLE_HEIGHT)
        outerCircle.backgroundColor = outerColor
        outerCircle.layer.cornerRadius = CIRCLE_RADIUS
        
        innerCircle.frame = CGRect(x: 175, y: 300, width: CIRCLE_HEIGHT, height: CIRCLE_HEIGHT)
        innerCircle.backgroundColor = innerColor
        innerCircle.layer.cornerRadius = CIRCLE_RADIUS
    }
   
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
