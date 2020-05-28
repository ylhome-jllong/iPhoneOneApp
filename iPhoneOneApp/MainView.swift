//
//  MainView.swift
//  iPhoneOneApp
//
//  Created by 江龙 on 2020/5/28.
//  Copyright © 2020 江龙. All rights reserved.
//

import UIKit

class MainView: UIView {
    
    /// 用于标志红对黑游戏 true 红对黑  false 黑对红
    var  reversal = false
    var game: Game?
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        if(game!.gameState){
            // 显示棋盘
            if let height = game?.checkerboard.boardSize?.height{
                let point = CGPoint(x:0,y:bounds.height/2-height/2)
                game?.checkerboard.boardImage?.draw(at: point)
            }
            
            // 显示棋子
            // 绘制棋子
            for x in 0...8{
                for y in 0...9{
                    let point = toViewPoint(game!.checkerboard.grid[x][y])
                    let rect = CGRect(x: point.x-15 ,y: point.y-15,width: 30,height: 30)
                    game?.checkerboard.pieces[x][y]?.pieceImage?.draw(in: rect)
                }
            }
            // 绘制提起的棋子
            if (game?.raisePiece != nil ){
                // 坐标转换
                let point = toViewPoint(game!.raisePiece!.point)
                let rect = CGRect(x: point.x-15 ,y: point.y-15,width: 30,height: 30)
                game?.raisePiece?.piece?.pieceImage?.draw(in: rect)
            }
        }
    }
    /// 将坐标转换为View坐标
    private func toViewPoint(_ oldPoint: CGPoint)->CGPoint{
        var newPoint = oldPoint
        let height = game!.checkerboard.boardSize!.height
        
        // 棋盘反转
        if(!reversal){
            newPoint.x = abs(newPoint.x - game!.checkerboard.boardSize!.width)
            newPoint.y = abs(newPoint.y - game!.checkerboard.boardSize!.height)
        }
        
        // 坐标转换为View显示坐标
        newPoint.x = newPoint.x + 0
        newPoint.y = newPoint.y + bounds.height/2-height/2
        
        return newPoint
    }
    
    /// 将坐标转换为Board坐标
    func toBoardPoint(_ oldPoint: CGPoint)->CGPoint{
       
        var newPoint = oldPoint
        let height = game!.checkerboard.boardSize!.height
        // 坐标转换回棋盘坐标
        newPoint.x = newPoint.x + 0
        newPoint.y = newPoint.y - (bounds.height/2-height/2)
        
        // 棋盘反转
        if(!reversal){
            newPoint.x = abs(newPoint.x - game!.checkerboard.boardSize!.width)
            newPoint.y = abs(newPoint.y - game!.checkerboard.boardSize!.height)
        }
       
        return newPoint
    }

}
