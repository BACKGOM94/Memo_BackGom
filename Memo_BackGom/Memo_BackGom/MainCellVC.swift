//
//  MainCellVC.swift
//  Memo_BackGom
//
//  Created by Hoony on 2022/10/04.
//

import UIKit

class MainCellVC: UICollectionViewCell {
    
    //메인컬러 1 (cccccc)
    let color_1 = UIColor(named: "MainColor_1")
    
    @IBOutlet weak var MainCellImage: UIImageView!
    
    @IBOutlet weak var MainCellTitle: UILabel!
    
    func setLineDot(){
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color_1?.cgColor
        borderLayer.lineDashPattern = [2, 2]
        borderLayer.frame = self.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10).cgPath
        
        self.layer.addSublayer(borderLayer)
    }
    
}
