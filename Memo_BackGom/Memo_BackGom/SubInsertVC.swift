//
//  SubInsertVC.swift
//  Memo_BackGom
//
//  Created by Hoony on 2022/10/07.
//

import UIKit
import CoreData

class SubInsertVC: UIViewController {

    var mainData: MainCellTable?
    var subData: SubCellTable?
    
    //메인컬러 1 (cccccc)
    let color_1 = UIColor(named: "MainColor_1")
    var Flag = ""
    @IBOutlet weak var MainTitle: UILabel!
    @IBOutlet weak var SubTitle: UITextField!
    @IBOutlet weak var InsertButton: UIButton!
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet weak var CancleButton: UIButton!
    @IBOutlet weak var SubContext: UITextView!
    
    var now_star = 0
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){view.endEditing(true)}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIsetting()
        DataSetting()
    }
    
    @IBAction func cancleButtonPress(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteButtonPress(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard let hasData = subData else { return }
        
        guard let hasUUID = hasData.subID else { return }
        
        let fetchRequest : NSFetchRequest<SubCellTable> = SubCellTable.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "subID = %@", hasUUID)
        
                do {
                    let loadedData = try context.fetch(fetchRequest)
                    
                    if let loadFirstData = loadedData.first {
                        context.delete(loadFirstData)
                        
                    }
                    
                } catch {
                    print(error)
                }
        navigationController?.popViewController(animated: true)
    }
    @IBAction func insertButtonPress(_ sender: Any) {
        if SubTitle.text != "" {
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            if Flag == "new" {
                let SubCellTable = NSEntityDescription.insertNewObject(forEntityName: "SubCellTable", into: context) as! SubCellTable
                
                
                SubCellTable.mainID = mainData?.mainID
                SubCellTable.subID = UUID().uuidString
                SubCellTable.subTitle = SubTitle.text
                SubCellTable.subContent = SubContext.text
                SubCellTable.subRating = Int16(now_star)
                
                do{
                    try context.save()
                    
                    navigationController?.popViewController(animated: true)
                } catch let error {
                    print(error.localizedDescription)
                }
            } else if Flag == "update" {
                
                guard let hasData = subData else { return }
                
                guard let hasUUID = hasData.subID else { return }

                let fetchRequest : NSFetchRequest<SubCellTable> = SubCellTable.fetchRequest()

                fetchRequest.predicate = NSPredicate(format: "subID = %@", hasUUID)

                do{
                    let loadData = try context.fetch(fetchRequest)

                    loadData.first?.subTitle = SubTitle.text
                    loadData.first?.subContent = SubContext.text
                    loadData.first?.subRating = Int16(now_star)
                    
                    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)

                    appDelegate.saveContext()
                    
                    navigationController?.popViewController(animated: true)
                }catch{
                    print(error)
                }
            
            }
        }else {
            let alert = UIAlertController(title: "제목은 필수 입력 사항입니다.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func starClick(_ sender: UIButton) {
        if let star_name = sender.restorationIdentifier?.last {
            
            let star_no = Int(String(star_name))!
            
            let befor_star = now_star
            
            now_star = star_no
            
            if now_star == befor_star {
                now_star -= 1
            }
            
            starSetting()
            
        }else{
            return
        }
        
    }
    
    func starSetting() {
        
        let white_star = UIImage(systemName: "star")
        let black_star = UIImage(systemName: "star.fill")
        
        switch now_star {
        case 0:
            star1.setImage(white_star, for: .normal)
            star2.setImage(white_star, for: .normal)
            star3.setImage(white_star, for: .normal)
            star4.setImage(white_star, for: .normal)
            star5.setImage(white_star, for: .normal)
        case 1:
            star1.setImage(black_star, for: .normal)
            star2.setImage(white_star, for: .normal)
            star3.setImage(white_star, for: .normal)
            star4.setImage(white_star, for: .normal)
            star5.setImage(white_star, for: .normal)
        case 2:
            star1.setImage(black_star, for: .normal)
            star2.setImage(black_star, for: .normal)
            star3.setImage(white_star, for: .normal)
            star4.setImage(white_star, for: .normal)
            star5.setImage(white_star, for: .normal)
        case 3:
            star1.setImage(black_star, for: .normal)
            star2.setImage(black_star, for: .normal)
            star3.setImage(black_star, for: .normal)
            star4.setImage(white_star, for: .normal)
            star5.setImage(white_star, for: .normal)
        case 4:
            star1.setImage(black_star, for: .normal)
            star2.setImage(black_star, for: .normal)
            star3.setImage(black_star, for: .normal)
            star4.setImage(black_star, for: .normal)
            star5.setImage(white_star, for: .normal)
        case 5:
            star1.setImage(black_star, for: .normal)
            star2.setImage(black_star, for: .normal)
            star3.setImage(black_star, for: .normal)
            star4.setImage(black_star, for: .normal)
            star5.setImage(black_star, for: .normal)
        default:
            return
        }
    }
    
    func DataSetting() {
        if Flag == "new" {
            MainTitle.text = mainData?.mainTitle
            SubTitle.text = ""
            SubContext.text = ""
            now_star = 0
            starSetting()
        } else if Flag == "update" {
            MainTitle.text = mainData?.mainTitle
            SubTitle.text = subData?.subTitle
            SubContext.text = subData?.subContent
            
            if let subRating = subData?.subRating {
                now_star = Int(subRating)
            }else { return }
            
            starSetting()
        }
    }

    func UIsetting () {
        MainTitle.layer.borderWidth = 2
        MainTitle.layer.borderColor = color_1?.cgColor
        
        SubTitle.layer.borderWidth = 2
        SubTitle.layer.borderColor = color_1?.cgColor
        
        SubContext.layer.borderWidth = 2
        SubContext.layer.borderColor = color_1?.cgColor
        
        InsertButton.layer.borderWidth = 2
        InsertButton.layer.borderColor = color_1?.cgColor
        InsertButton.layer.backgroundColor = color_1?.cgColor
        InsertButton.tintColor = .black
        
        CancleButton.layer.borderWidth = 2
        CancleButton.layer.borderColor = color_1?.cgColor
        CancleButton.layer.backgroundColor = UIColor.white.cgColor
        CancleButton.tintColor = .black
        
        DeleteButton.layer.borderWidth = 2
        DeleteButton.layer.borderColor = color_1?.cgColor
        DeleteButton.layer.backgroundColor = UIColor.white.cgColor
        
        
        
        
        
        if Flag == "new" {
            InsertButton.setTitle("등록", for: .normal)
            DeleteButton.layer.isHidden = true
        } else if Flag == "update" {
            InsertButton.setTitle("수정", for: .normal)
            DeleteButton.layer.isHidden = false
        }
    }


}
