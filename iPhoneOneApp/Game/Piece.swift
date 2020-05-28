//
//  Piece.swift
//  MacOneApp
//
//  Created by 江龙 on 2020/5/14.
//  Copyright © 2020 江龙. All rights reserved.
//

import UIKit

/// 棋子类
class Piece: NSObject {
    
    /// 种类
    enum PieceType {
        case 車;case 馬;case 炮;case 将;case 士;case 象;case 兵;case 空;
    }
    /// 红方黑方
    enum TeamType{
        case red;case black;
    }
    
    /// 棋子图
    var pieceImage: UIImage?
    /// 棋子ID号
    var nID = -1
    /// 棋子类型
    var type = PieceType.空
    /// 棋子位置
    var position = (x:-1,y:-1)
    /// 对战方
    var team = TeamType.black
    /// 棋子的大小
    private(set) var size = CGSize()
    
    
    /// nID 棋子ID号，type:棋子的种类，position:棋子位置，team: 棋子颜色，size:棋子大小
    init(nID: Int,type: PieceType,position: (Int,Int),team: TeamType,size: CGSize){
        self.nID = nID
        self.type = type
        self.position = position
        self.team = team
        super.init()
        // 初始化图像
        initImage(size:size)
    }
    
    
    /// 初始化棋子图像
    func initImage(size: CGSize) {
        self.size = size
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        switch self.team{
        case .red:UIColor.red.setStroke()
        case .black:UIColor.black.setStroke()
        }
        
        
        let aRect = CGRect(x:1, y: 1,width: size.width-2, height: size.height-2)
        let path = UIBezierPath(ovalIn: aRect)
        path.lineWidth = 2
        UIColor.white.setFill()
    
        path.fill()
        path.stroke()
        
        // 绘制文字
        let content = self.getDrawSrt()
        let str = NSMutableAttributedString(string: content)
        let selectedRange = NSRange(location: 0, length: content.count)
        // 设置文字字体
        let font = UIFont(name: "Copperplate", size:33);
        // 设置文字颜色
        var color: UIColor
        switch self.team{
        case .red:color = UIColor.red
        case .black:color = UIColor.black
        }
        str.addAttribute(.foregroundColor, value: color, range: selectedRange)
        str.addAttribute(.font, value:font!, range: selectedRange)
        // 绘制
        str.draw(at: CGPoint(x: 9,y: 10))
        
        self.pieceImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
            
    }
    
    /// 获得棋子的文字
    private func getDrawSrt() -> String {
        var str: String=""
        switch type {
        case .兵:if (team == .red){str = "兵"} else{str = "卒"}
        case .車:str = "車"
        case .馬:str = "馬"
        case .炮:if (team == .red){str = "炮"} else{str = "砲"}
        case .将:if (team == .red){str = "帅"}else{str = "将"}
        case .象:if (team == .red){str = "相"}else{str = "象"}
        case .士:if (team == .red){str = "仕"}else{str = "士"}
        default:
            break
        }
        return str
        
        
    }
    

    
    
}
