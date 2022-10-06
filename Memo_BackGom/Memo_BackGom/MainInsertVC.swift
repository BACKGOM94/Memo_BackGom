//
//  MainInsertVC.swift
//  Memo_BackGom
//
//  Created by Hoony on 2022/10/04.
//

import UIKit
import PhotosUI
import CoreData

class MainInsertVC: UIViewController {

    @IBOutlet weak var IconImage: UIImageView!
    
    var ImageCheck = false
    
    @IBOutlet weak var IconImageLine: UIView!
    
    @IBOutlet weak var InsertButton: UIButton!
    
    @IBOutlet weak var CancleButton: UIButton!
    
    @IBOutlet weak var DeleteButton: UIButton!
    
    @IBOutlet weak var MainTitle: UITextField!
    
    var Flag = ""
    var MainID_C : UUID?
    var IconImage_C : UIImage?
    var MainTitle_C : String?
    
    //메인컬러 1 (cccccc)
    let color_1 = UIColor(named: "MainColor_1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetting()
        
        let ImageLine_Click = UITapGestureRecognizer(target: self, action: #selector(ImageLine_Click))
        IconImageLine.addGestureRecognizer(ImageLine_Click)
        
        if Flag == "update" {
            showData()
        }
        
        
    }
    
    
    func showData(){
        MainTitle.text = MainTitle_C
        IconImage.image = IconImage_C
    }
    
    @IBAction func DeleteButtonPressed(_ sender: Any) {

        DeleteData()

        navigationController?.popViewController(animated: true)
        
    }
    
    func DeleteData () {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<MainCellTable> = MainCellTable.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "mainID = %@", MainID_C! as CVarArg)
        
                do {
                    let loadedData = try context.fetch(fetchRequest)
                    
                    if let loadFirstData = loadedData.first {
                        context.delete(loadFirstData)
                    }
                    
                } catch {
                    print(error)
                }
        
    }
    @IBAction func InsertButtonPressed(_ sender: UIButton) {
        
        if MainTitle.text != "" && ImageCheck {
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let MainCellTable = NSEntityDescription.insertNewObject(forEntityName: "MainCellTable", into: context) as! MainCellTable
            
            MainCellTable.mainImage = self.IconImage.image?.jpegData(compressionQuality: 1.0)
            MainCellTable.mainTitle = MainTitle.text
            
            if Flag == "New" {
                MainCellTable.mainID = UUID()
            } else if Flag == "update" {
                MainCellTable.mainID = MainID_C
            }
            
            do{
        
                    try context.save()
                
                
                
                navigationController?.popViewController(animated: true)
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        }else {
            let alert = UIAlertController(title: "폴더명이나 사진을 추가해 주세요", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    
    @objc func ImageLine_Click() {
       
        let Photo_status = PHPhotoLibrary.authorizationStatus()
        
        if Photo_status == .authorized || Photo_status == .limited {
            showGallery()
        } else if Photo_status == .denied {
            
            let alert = UIAlertController(title: "포토라이브러리 접근 권한이 없습니다.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
            alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default, handler: { action in
                guard let url = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url)
                }
            }))
            self.present(alert, animated: true)
        } else if Photo_status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { status in
                self.ImageLine_Click()
            }
        }
    }
    
    func showGallery() {
        let library = PHPhotoLibrary.shared()
        
        var configuration = PHPickerConfiguration(photoLibrary: library)
        
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self
        
        present(picker, animated: true)
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
        
        DeleteButton.layer.borderWidth = 2
        DeleteButton.layer.borderColor = color_1?.cgColor
        DeleteButton.layer.backgroundColor = UIColor.white.cgColor
        
        if Flag == "New" {
            InsertButton.setTitle("등록", for: .normal)
            DeleteButton.layer.isHidden = true
        } else if Flag == "update" {
            InsertButton.setTitle("수정", for: .normal)
            DeleteButton.layer.isHidden = false
        }
        
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color_1?.cgColor
        borderLayer.lineDashPattern = [2, 2]
        borderLayer.frame = IconImageLine.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: IconImageLine.bounds, cornerRadius: 10).cgPath
        
        IconImageLine.layer.addSublayer(borderLayer)
    }
    
}
extension MainInsertVC : PHPickerViewControllerDelegate {
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        let itemProvider = results[0].itemProvider
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    DispatchQueue.main.sync {
                        self.IconImage.image = image
                        
                        self.ImageCheck = true
                    }
                }
            }
        }
        self.dismiss(animated: true)
    }
    
    
}
