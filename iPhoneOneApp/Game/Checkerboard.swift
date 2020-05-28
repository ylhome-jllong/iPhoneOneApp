//
//  Checkerboard.swift
//  MacOneApp
//
//  Created by 江龙 on 2020/5/13.
//  Copyright © 2020 江龙. All rights reserved.
//

import UIKit
/// 棋盘类
class Checkerboard: NSObject {
    /// 棋盘图
    var boardImage: UIImage?
    /// 棋盘大小
    var boardSize: CGSize?
    /// 棋盘网格大小
    var lattice: CGSize?
    /// 棋盘点位 [x][y]
    var grid = [[CGPoint]]()  //数组的定义方式
    /// 旗子容器
    var pieces: [[Piece?]]!   // 可选型数组
    /// 棋子的大小
    private(set) var pieceSize = CGSize()
    
    /// 棋子容器初始化
    func initPieces() {
        pieces = [[Piece?]]()
        for _ in 1...9{//X轴
            var t_Pieces = [Piece?]()
            for _ in 1...10{// Y轴
                t_Pieces.append(nil)
            }
            pieces?.append(t_Pieces)
        }
    }
    
    
    /// 初始化棋盘
    func initBoard(boardSize: CGSize){
        self.boardSize = boardSize
        
        // 设置棋子的大小
        self.pieceSize = CGSize(width: 50, height: 50)
        
        // 计算间隔
        let jianGe_y = boardSize.height/11
        let jianGe_x = boardSize.width/10
        
        // 初始化网格
        for x in 1...9{
            var y_point = [CGPoint]()
            for y in 1...10{
                y_point.append(CGPoint(x: CGFloat(x)*jianGe_x, y: CGFloat(y)*jianGe_y))
            }
            grid.append(y_point)
        }
       
        // 获得绘图上下文
        UIGraphicsBeginImageContextWithOptions(boardSize, false, 0)
        
        // 画底板
        var rect = CGRect(x: 0, y: 0, width: boardSize.width, height: boardSize.height)
        var path = UIBezierPath(rect: rect)
        UIColor.white.setFill()
        path.fill()
        
        path = UIBezierPath()
        path.lineWidth = 1
        for i in 1...10{
            path.move(to: CGPoint(x: jianGe_x,y: CGFloat(i)*jianGe_y))
            path.addLine(to: CGPoint(x: boardSize.width-jianGe_x, y: CGFloat(i)*jianGe_y))
            path.stroke()
        }
        for i in 1...9{
            path.move(to: CGPoint(x:CGFloat(i)*jianGe_x,y: jianGe_y))
            path.addLine(to: CGPoint(x:CGFloat(i)*jianGe_x, y:boardSize.height-jianGe_y))
            path.stroke()
        }
        // 画特殊标志
        SmallScaleS(x: 1, y: 2, width: 3, path: path)
        SmallScaleS(x: 7, y: 2, width: 3, path: path)
        SmallScaleS(x: 1, y: 7, width: 3, path: path)
        SmallScaleS(x: 7, y: 7, width: 3, path: path)
        SmallScaleS(x: 0, y: 3, width: 3, path: path)
        SmallScaleS(x: 2, y: 3, width: 3, path: path)
        SmallScaleS(x: 4, y: 3, width: 3, path: path)
        SmallScaleS(x: 6, y: 3, width: 3, path: path)
        SmallScaleS(x: 8, y: 3, width: 3, path: path)
        SmallScaleS(x: 0, y: 6, width: 3, path: path)
        SmallScaleS(x: 2, y: 6, width: 3, path: path)
        SmallScaleS(x: 4, y: 6, width: 3, path: path)
        SmallScaleS(x: 6, y: 6, width: 3, path: path)
        SmallScaleS(x: 8, y: 6, width: 3, path: path)
        
        path.move(to: grid[3][0])
        path.addLine(to: grid[5][2])
        path.move(to: grid[3][2])
        path.addLine(to: grid[5][0])
        
        path.move(to: grid[3][9])
        path.addLine(to: grid[5][7])
        path.move(to: grid[3][7])
        path.addLine(to: grid[5][9])
        
        path.stroke()
        
        
        
        // 画楚河汉界
        rect = CGRect(x: grid[0][4].x+1,y:grid[0][4].y+1,width: 8*jianGe_x-2,height: jianGe_y-2)
        path = UIBezierPath(rect: rect)
        UIColor.white.setFill()

        path.fill()
        // 绘制文字
        let content = "              楚河       汉界"
        let str = NSMutableAttributedString(string: content)
        let selectedRange = NSRange(location: 0, length: content.count)
        // 设置文字字体
        let font=UIFont(name: "Copperplate", size:20);
        // 设置文字颜色
        let color = UIColor.gray
        str.addAttribute(.foregroundColor, value: color, range: selectedRange)
        str.addAttribute(.font, value:font!, range: selectedRange)
        // 绘制
        str.draw(at: CGPoint(x: grid[0][4].x,y: grid[0][4].y+10))
       
        boardImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    
    
    
    
    /// 获得点击位置的棋子
    func getPiece(_ point: CGPoint ) -> Piece?{
        var piece:Piece?
        let r = pieceSize.width/2
        // 寻找可能的棋子
        for x in 0...8{
            for y in 0...9{
                if(point.x < grid[x][y].x + r && point.x > grid[x][y].x - r &&
                    point.y < grid[x][y].y + r && point.y > grid[x][y].y - r)
                {
                    piece = pieces[x][y]
                }
            }
        }
        return piece
        
    }
    
    
    /// 获得可放棋子的位置  没有找到返回-1
    func getPosition(_ point: CGPoint) -> (x: Int,y: Int){
        let r = pieceSize.width/2
        
        // 寻找附近可以放置棋子的位置
        for x in 0...8{
            for y in 0...9{
                if(point.x < grid[x][y].x + r && point.x > grid[x][y].x - r &&
                    point.y < grid[x][y].y + r && point.y > grid[x][y].y - r)
                {
                     return (x,y)
                }
            }
        }
        
        return(-1,-1)
    }

    
    
//========== 私有方法 ===================================================================
    /// 绘制棋盘小标志  要在上下文锁定的前提下使用 width 为离主线的距离
    private func SmallScaleS(x: Int , y: Int, width: CGFloat,path: UIBezierPath){
        
        let point = grid[x][y]
         // 小横线
        if (x != 0){
            path.move(to: CGPoint(x: point.x-(width+10),y: point.y+width))
            path.addLine(to: CGPoint(x: point.x-width,y: point.y+width))
            
            path.move(to: CGPoint(x: point.x-(width+10),y: point.y-width))
            path.addLine(to: CGPoint(x: point.x-width,y: point.y-width))
        }
        if (x != 8){
            path.move(to: CGPoint(x: point.x+(width+10),y: point.y+width))
            path.addLine(to: CGPoint(x: point.x+width,y: point.y+width))

            path.move(to: CGPoint(x: point.x+(width+10),y: point.y-width))
            path.addLine(to: CGPoint(x: point.x+width,y: point.y-width))
        }
         
         // 小竖线
        if(x != 0 ){
            path.move(to: CGPoint(x: point.x-width,y: point.y+(width+10)))
            path.addLine(to: CGPoint(x: point.x-width,y: point.y+width))
            
            path.move(to: CGPoint(x: point.x-width,y: point.y-(width+10)))
            path.addLine(to: CGPoint(x: point.x-width,y: point.y-width))
        }
        if (x != 8 ){
            path.move(to: CGPoint(x: point.x+width,y: point.y+(width+10)))
            path.addLine(to: CGPoint(x: point.x+width,y: point.y+width))

            path.move(to: CGPoint(x: point.x+width,y: point.y-(width+10)))
            path.addLine(to: CGPoint(x: point.x+width,y: point.y-width))
            
        }
        
         path.stroke()
    }
}
