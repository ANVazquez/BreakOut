//
//  ViewController.swift
//  week7 inClass
//
//  Created by Aramis N. Vazquez (Student) on 1/23/19.
//  Copyright © 2019 Aramis N. Vazquez (Student). All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var paddle: UIImageView!
    @IBOutlet weak var ball: UIImageView!
    @IBOutlet weak var start_Outlet: UIButton!
    @IBOutlet weak var life_num: UILabel!
    @IBOutlet weak var win_lose_label: UILabel!
    @IBOutlet weak var score_Count: UILabel!
    
    @IBAction func Start_btn(_ sender: Any) {
        self.startGame()
        self.start_Outlet.alpha = 0
    }
    var score: Int = 0
    var lives: Int = 3
    var ballMovement = CGPoint.zero
    var ball_Position = CGPoint.zero
    var touchOffset: Float = 0.0
    var theTimer: Timer?
    var bricks = [[UIImageView]]()
    var brickTypes = [String](repeating: "", count: 4)
    var BRICKS_WIDTH: Int = 6
    var BRICKS_HEIGHT: Int = 4
    
    //Creates all bricks and places them at the appropriate location on the screen
    func initializeBricks() {
        brickTypes[0] = "bricktype1"
        brickTypes[1] = "bricktype2"
        brickTypes[2] = "bricktype3"
        brickTypes[3] = "bricktype4"
        let screenOffset: Int = (Int(view.bounds.width) - 64 * BRICKS_WIDTH) / 2
        for x in 0..<BRICKS_WIDTH {
            var row = [UIImageView]()
            for y in 0..<BRICKS_HEIGHT {
                let image = UIImageView(image: UIImage(named: brickTypes[(x+y) % 4]))
                var newFrame: CGRect = image.frame
                newFrame.origin = CGPoint(x: CGFloat(x * 64 + screenOffset), y: CGFloat(y * 40 + 50))
                image.frame = newFrame
                row.append(image)
                view.addSubview(image)
            }
            bricks.append(row)
        }
    }
    
    //resets all settings, reloads bricks and starts the timer
    //IBAction
    func startGame() {
        initializeTimer()
        ballMovement = CGPoint(x: 2.0, y: 2.0)
    }
    
    @objc func gameLogic() {
        self.ball.center = CGPoint(x: self.ball.center.x + ballMovement.x, y: self.ball.center.y + ballMovement.y)
        
        //bounce on right side
        if self.ball.center.x > self.view.frame.maxX {
            ballMovement.x = ballMovement.x * -1
        }
        //bounce on left side
        if self.ball.center.x < self.view.frame.minX {
            ballMovement.x = ballMovement.x * -1
        }
        //bounce on top
        if self.ball.frame.minY <= self.view.frame.minY {
            ballMovement.y = ballMovement.y * -1
        }
        //bounce on paddle
        if self.ball.frame.maxY >= self.paddle.frame.minY && self.paddle.frame.minX <= self.ball.frame.maxX && self.paddle.frame.maxX >= self.ball.frame.minX {
            ballMovement.y = ballMovement.y * -1
        }
        //Life lost
        if self.ball.center.y > self.paddle.frame.maxY {
            self.theTimer?.invalidate()
            self.ball.center = self.ball_Position
            self.start_Outlet.alpha = 1
            
            //lose a life
            lives -= 1
            life_num.text = "\(lives)"
        }
        //Lose game
        if lives == 0 {
            lives = 0
            self.theTimer?.invalidate()
            self.start_Outlet.alpha = 0
            win_lose_label.text = "You Lose :["
            
        }
        //score to increase
        
        
        //collisions
        /*
                    //check collision in bottom of brick and top of ball
                    //top of the brick and bottom of the ball
                    //left of brick and right of ball
                    //right of brick and left of ball
         */
        for x in 0..<BRICKS_WIDTH {
            for y in 0..<BRICKS_HEIGHT {
                if self.bricks[x][y].alpha == 1 {
                    if self.bricks[x][y].frame.intersects(self.ball.frame) {
                        self.bricks[x][y].alpha = 0
                        if abs(self.bricks[x][y].frame.maxY - self.ball.frame.minY) < 3  {
                            self.ballMovement.y = self.ballMovement.y * -1
                        }
                        if abs(self.bricks[x][y].frame.minY - self.ball.frame.maxY) < 3  {
                            self.ballMovement.y = self.ballMovement.y * -1
                        }
                        if abs(self.bricks[x][y].frame.minX - self.ball.frame.maxX) < 3  {
                            ballMovement.x = self.ballMovement.x * -1
                        }
                        if abs(self.bricks[x][y].frame.maxX - self.ball.frame.minX) < 3  {
                            self.ballMovement.x = self.ballMovement.x * -1
                        }
                        score += 10
                        score_Count.text = "\(score)"
                    }
                }
            }
        }
        
        //when bricks are all gone
           //display win
           //restart(maybe)
        if score == 240 {
            score = 240
            self.theTimer?.invalidate()
            self.start_Outlet.alpha = 0
            win_lose_label.text = "OMG YOU WON!!!! :]"
        }
    }
    
    func initializeTimer() {
        let interval: Float = 1.0 / 120.0
        
        theTimer = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: #selector(gameLogic), userInfo: nil, repeats: true)
    }
    
    //determine way to "bounce" the ball
    /*func processCollision(brick) {
        
    }*/
    
    //tracks finger movement
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = event!.allTouches?.first
        touchOffset = Float((touch?.location(in: touch?.view).x)!)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = event!.allTouches?.first
        
        let distanceMoved = Float(touch?.location(in: touch?.view).x ?? 0.0) - touchOffset
        var newX: Float = Float(paddle.center.x) + distanceMoved
        if newX < 30 {
            newX = 30
        }
        if newX > Float(view.bounds.width) - 30.0 {
            newX = Float(view.bounds.width) - 30.0
        }
        paddle.center = CGPoint(x: CGFloat(newX), y: paddle.center.y)
        touchOffset += distanceMoved
    }
    
    override func viewDidLoad() {
        self.ball_Position = self.ball.center
        initializeBricks()
    }
}

