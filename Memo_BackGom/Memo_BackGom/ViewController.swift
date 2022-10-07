//
//  ViewController.swift
//  Memo_BackGom
//
//  Created by Hoony on 2022/10/04.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var Main_View: UICollectionView!
    
    var mainCellTable = [MainCellTable]()
    
    //메인컬러 1 (cccccc)
    let color_1 = UIColor(named: "MainColor_1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        
        //네비게이션 세팅
        Nav_setting()
        
        //Main_View의 데이터를 가져오기 위한 선언
        Main_View.dataSource = self
       
        //Main_View의 동작을 만들어주기 위한 선언
        Main_View.delegate = self
        
        //Main_View의 레이아웃을 잡아주기 위한 함수
        Main_View_layout()
        
        get_Main_Data()
        
        setupLongGestureRecognizerOnCollection()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        get_Main_Data()
        
        Main_View.reloadData()
    }

    func get_Main_Data() {
        
        let fetchRequst : NSFetchRequest<MainCellTable> = MainCellTable.fetchRequest()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            self.mainCellTable = try context.fetch(fetchRequst)
        }catch {
            print(error)
        }

        
    }
    
    //네비게이션바 셋팅
    func Nav_setting() {
        navigationController?.navigationBar.backgroundColor = color_1
    }
    
    //Main_View의 레이아웃을 잡아주기 위한 세팅
    func Main_View_layout() {
        let layout = UICollectionViewFlowLayout()

        let width = UIScreen.main.bounds.width / 2 - 15

        layout.itemSize = CGSize(width: width, height: 150)

        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        Main_View.collectionViewLayout = layout
    }
}

//Main_List에 데이터를 뿌려주기 위한 함수들
extension ViewController : UICollectionViewDataSource {
    
    //반환해주는 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainCellTable.count + 1
    }
    
    //반환해주는 Cell에 대한 정보
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let MainCellVC = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCellVC", for: indexPath) as! MainCellVC
        
//        print("indexPath.row = \(indexPath.row)")
//        print("indexPath.count = \(indexPath.count)")
//        print("mainCellTable.count = \(mainCellTable.count)")
//        print("----------------------------")
        
        //점선 추가를 위한 함수사용
        MainCellVC.setLineDot()
        if indexPath.row == mainCellTable.count  {
                
            MainCellVC.MainCellTitle.text = ""
            MainCellVC.MainCellImage.image = UIImage(systemName: "plus")
            MainCellVC.MainCellImage.tintColor = color_1
            
        }else {
                
            MainCellVC.MainCellTitle.text = mainCellTable[indexPath.row].mainTitle
            if mainCellTable[indexPath.row].mainImage != nil {
                MainCellVC.MainCellImage.image = UIImage(data: mainCellTable[indexPath.row].mainImage!)
            }
            MainCellVC.MainCellImage.tintColor = color_1
            
        }
        return MainCellVC
    }
}

//Main_List의 동작을 만들어주기 위한 함수들
extension ViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        if indexPath.row == mainCellTable.count {
            
            let MainInsertVC = MainInsertVC(nibName: "MainInsertVC", bundle: nil)
            
            MainInsertVC.Flag = "new"
            
            self.show(MainInsertVC, sender: nil)
            
        }else {
            let SubListVC = SubListVC(nibName: "SubListVC", bundle: nil)
            
            SubListVC.mainData = mainCellTable[indexPath.row]
            
            self.show(SubListVC, sender: nil)
        }
    }
        
}

extension ViewController: UIGestureRecognizerDelegate {
    // long press 이벤트 부여
    private func setupLongGestureRecognizerOnCollection() {
        
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        Main_View.addGestureRecognizer(longPressedGesture)
    }
  
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: Main_View)

        
        if gestureRecognizer.state == .began {
            
            if let indexPath = Main_View.indexPathForItem(at: location) {
                    
                if mainCellTable.count != indexPath.row{
                    let MainInsertVC = MainInsertVC(nibName: "MainInsertVC", bundle: nil)
                    
                    MainInsertVC.Flag = "update"
                    MainInsertVC.ImageCheck = true
                    MainInsertVC.selectedData = mainCellTable[indexPath.row]
                    
                    self.show(MainInsertVC, sender: nil)
                }
            }
            
        }
    }
}


    

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
