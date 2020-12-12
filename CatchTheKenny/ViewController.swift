//
//  ViewController.swift
//  CatchTheKenny
//
//  Created by Kerem Çubuk on 12.12.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var kennyImage: UIImageView!
    
    var time = Timer()
    var hideTimer = Timer()
    var counter = 0
    var score = 0
    var highScore = 0
    var startingPosition = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startingPosition = Int(CGFloat(kennyImage.frame.origin.y))
        counter = 10
        timeLabel.text = "Time: \(counter)"
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(spawnRandomPosition), userInfo: nil, repeats: true)
        scoreLabel.text = "Score: \(score)"
        
        let storedHighScore = UserDefaults.standard.object(forKey: "highScore")
        if let newHighScore = storedHighScore as? Int {
            highScoreLabel.text = "High Score: \(newHighScore)"
            highScore = newHighScore
        } else {
            highScoreLabel.text = "High Score: 0"
        }
        
        kennyImage.isUserInteractionEnabled = true
        let touchKenny = UITapGestureRecognizer(target: self, action: #selector(onTouchKenny))
        kennyImage.addGestureRecognizer(touchKenny)
    }

    @objc func startTimer() {
        timeLabel.text = "Time: \(counter)"
        counter -= 1
        
        if counter == 0 {
            time.invalidate()
            hideTimer.invalidate()
            timeLabel.text = "Time is over!"
            
            let alert = UIAlertController(title: "Time is up!", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) {
                (UIAlerAction) in
                self.score = 0
                self.scoreLabel.text = "Score: \(self.score)"
                self.counter = 10
                self.timeLabel.text = "Time \(self.counter)"
                
                self.time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
                self.hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.spawnRandomPosition), userInfo: nil, repeats: true)
                
            }
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func onTouchKenny() {
        score += 1
        scoreLabel.text = "Score: \(score)"
        
        if score > highScore {
            highScore = score
            highScoreLabel.text = "High Score: \(highScore)"
            UserDefaults.standard.set(highScore, forKey: "highScore")
        }
    }
    
    @objc func spawnRandomPosition() {
        let kenny = kennyImage
        let kennyWidth = kenny!.frame.width
        let kennyHeight = kenny!.frame.height

         // Find the width and height of the enclosing view
        let viewWidth = CGFloat(400)
        let viewHeight = CGFloat(400)

         // Compute width and height of the area to contain the kenny's center
        let xwidth = viewWidth - kennyWidth
        let yheight = viewHeight - kennyHeight

        // Generate a random x and y offset
        let xoffset = CGFloat(arc4random_uniform(UInt32(xwidth)))
        let yoffset = CGFloat(arc4random_uniform(UInt32(yheight)))

        // Offset the button's center by the random offsets.
        kenny!.center.x = xoffset + kennyWidth / 2
        kenny!.center.y = yoffset + CGFloat(startingPosition) + kennyHeight / 2
     }
}

