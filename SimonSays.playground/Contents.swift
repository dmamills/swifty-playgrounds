//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    typealias Callback = () -> ()
    let colors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    let SIZE = 150
    let stateLabel = UILabel()
    let START_PATTERN = 2
    
    var squares : [UIView] = []
    
    var patternLength = 2
    var computerPattern : [Int] = []
    var playerPattern : [Int] = []
    var playerTurn : Bool = false
    var gameActive : Bool = true
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        stateLabel.frame = CGRect(x: 50, y: 25, width: 300, height: 50)
        stateLabel.text = "Follow!"
        view.addSubview(stateLabel)
        
        setupSquares(view)
    
        self.view = view
        createAndPlayPattern()
    }
    
    func setupSquares(_ view: UIView) {
        for i in 0...3 {
            let xOffset = (Int(view.frame.width) / 2 ) + (SIZE / 4)
            let x = ((i % 2 == 0) ? 0 : SIZE) + xOffset
            let y = (i > 1) ? SIZE * 2 : SIZE
            
            let frame = CGRect(x: x, y: y, width: SIZE, height: SIZE)
            let squareView = UIView(frame:frame)
            squareView.backgroundColor = colors[i]
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
            
            squareView.tag = i
            squareView.addGestureRecognizer(tapGesture)
            squares.append(squareView)
        }
        
        for s in squares {
            view.addSubview(s)
        }
    }
    
    func delay(_ seconds : Double,_ cb : @escaping Callback) {
        let time = DispatchTime.now() + seconds
        DispatchQueue.main.asyncAfter(deadline: time, execute: cb)
    }
    
    func showPattern() {
        
        stateLabel.text = "Follow!"
        for idx in 0...computerPattern.count - 1 {
            delay(Double(idx), {
                self.animateSquare(self.computerPattern[idx])
            })
        }
        
        delay(Double(computerPattern.count + 1), {
            self.playerTurn = true
            self.stateLabel.text = "Your turn!"
            self.playerPattern = []
        })
    }
    
    func animateSquare(_ idx : Int) {
        
        UIView.animate(withDuration: 0.5, animations: {
            let square = self.squares[idx]
            square.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.view.bringSubview(toFront: square)
            UIView.animate(withDuration: 0.5, animations: {
                square.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
    }
    
    func createAndPlayPattern() {
        computerPattern = []
        
        for _ in 0...patternLength - 1 {
            computerPattern.append(Int(arc4random_uniform(4)))
        }
    
        print("New pattern generated: \(computerPattern)")
        showPattern()
    }

    @objc func tapped(_ sender : UITapGestureRecognizer) {
        
        if !gameActive {
            playerPattern = []
            patternLength = START_PATTERN
            gameActive = true
            playerTurn = false
            delay(1.0, {
                self.createAndPlayPattern()
            })
            return
        }
        
        if playerTurn {
            let v = sender.view!
            let idx = v.tag
            animateSquare(idx)
            playerPattern.append(idx)
            
            if playerPattern.last != computerPattern[playerPattern.count - 1] {
                stateLabel.text = "Wrong! Game over!"
                gameActive = false
            }
            
            if playerPattern.count == computerPattern.count {
                patternLength += 1
                stateLabel.text = "Pattern Complete! Next Level: \(patternLength)"
                
                delay(1.0, {
                    self.playerTurn = false
                    self.playerPattern = []
                    self.createAndPlayPattern()
                })
            }
        }
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
