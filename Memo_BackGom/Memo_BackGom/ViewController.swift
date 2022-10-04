//
//  ViewController.swift
//  Memo_BackGom
//
//  Created by Hoony on 2022/10/04.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Main_View: UICollectionView!
    
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
        return 10
    }
    
    //반환해주는 Cell에 대한 정보
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let MainCellVC = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCellVC", for: indexPath) as! MainCellVC
        
        //점선 추가를 위한 함수사용
        MainCellVC.setLineDot()
//        if indexPath.count == Main_Data.count + 1 {
        MainCellVC.MainCellTitle.text = "제목"
        MainCellVC.MainCellImage.image = UIImage(systemName: "plus")
        MainCellVC.MainCellImage.tintColor = color_1
//        }else {
//            Main_Cell.Main_Cell_Label.text = Main_Data[indexPath.row].title
//        }
        return MainCellVC
    }
}

//Main_List의 동작을 만들어주기 위한 함수들
extension ViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let MainInsertVC = MainInsertVC(nibName: "MainInsertVC", bundle: nil)
        
        self.show(MainInsertVC, sender: nil)
    }
        
}
    

