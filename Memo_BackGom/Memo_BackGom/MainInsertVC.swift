//
//  MainInsertVC.swift
//  Memo_BackGom
//
//  Created by Hoony on 2022/10/04.
//

import UIKit

class MainInsertVC: UIViewController {

    @IBOutlet weak var IconImage: UIImageView!
    
    @IBOutlet weak var IconImageLine: UIView!
    
    @IBOutlet weak var InsertButton: UIButton!
    
    @IBOutlet weak var CancleButton: UIButton!
    
    
    
    //메인컬러 1 (cccccc)
    let color_1 = UIColor(named: "MainColor_1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetting()
        
        let ImageLine_Click = UITapGestureRecognizer(target: self, action: #selector(ImageLine_Click))
        IconImageLine.addGestureRecognizer(ImageLine_Click)
        
    }
    
    @objc func ImageLine_Click(sender : UITapGestureRecognizer) {
        
    }
    
    

    func UISetting(){
        
        IconImage.tintColor = UIColor(named: "MainColor_1")
        
        InsertButton.layer.borderWidth = 2
        InsertButton.layer.borderColor = color_1?.cgColor
        InsertButton.layer.backgroundColor = color_1?.cgColor
        InsertButton.tintColor = .black
        
        CancleButton.layer.borderWidth = 2
        CancleButton.layer.borderColor = color_1?.cgColor
        CancleButton.layer.backgroundColor = UIColor.white.cgColor
        CancleButton.tintColor = .black
        
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color_1?.cgColor
        borderLayer.lineDashPattern = [2, 2]
        borderLayer.frame = IconImageLine.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: IconImageLine.bounds, cornerRadius: 10).cgPath
        
        IconImageLine.layer.addSublayer(borderLayer)
    }
    
}
