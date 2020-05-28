//
//  ViewController.swift
//  iPhoneOneApp
//
//  Created by 江龙 on 2020/5/28.
//  Copyright © 2020 江龙. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var game: Game?
    /// 鼠标按下时收集的数据
    struct MouseData {
        /// 标志是否提起
        var downFlag = false
        // 存储相对位置差
        var dpoint = CGPoint(x: 0,y: 0)
    }
    var mouesData = MouseData()
    
    @IBOutlet var mainView: MainView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let size = CGSize(width: self.view.bounds.width, height: self.view.bounds.width)
        game = Game(viewSize: size)
        mainView.game = game
        
    }
    
    // 触控按下
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         // 游戏没有开始跳出
         if(!game!.gameState){return}
               
         // 坐标转换
        let point = mainView.toBoardPoint(touches.first!.location(in: self.view))
        if (!mouesData.downFlag){
             // 提起棋子
            mouesData.downFlag = game!.raise(point)
         
             // 计算鼠标与棋子中心的距离（提升流畅度）
            if(mouesData.downFlag){
                 mouesData.dpoint.x = game!.raisePiece!.point.x - point.x
                 mouesData.dpoint.y = game!.raisePiece!.point.y - point.y
            }
            mainView.setNeedsDisplay()
         }
    }
    
    // 触控移动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 游戏没有开始跳出
        if(!game!.gameState){return}
        
        if(mouesData.downFlag){
            // 坐标转换
            let point = mainView.toBoardPoint(touches.first!.location(in: self.view))
            // 计算棋子中心位置提升流畅度
            var _point = point
            _point.x += mouesData.dpoint.x
            _point.y += mouesData.dpoint.y
            // 移动棋子
            game?.move(_point)
            mainView.setNeedsDisplay()
        }
    }
    
    // 触控台起
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 游戏没有开始跳出
        if(!game!.gameState){return}
        
        if mouesData.downFlag {
            //let point = mainView.toBoardPoint(touches.first!.location(in: self.view))
            // 放下棋子
            game?.lay()
            mouesData.downFlag = false
            mainView.setNeedsDisplay()
        }
    }

    /// 关联按钮 红对黑
    @IBAction func OnNew(_ sender: Any) {
        game?.playGame()
        mainView.reversal = false 
        mainView.setNeedsDisplay()
    }
    /// 关联按钮 黑对红
    @IBAction func OnNewPlus(_ sender: Any) {
        game?.playGame()
        mainView.reversal = true
        mainView.setNeedsDisplay()
    }
    
    
}

