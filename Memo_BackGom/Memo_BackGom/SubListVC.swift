//
//  SubListVC.swift
//  Memo_BackGom
//
//  Created by Hoony on 2022/10/08.
//

import UIKit
import CoreData

class SubListVC: UIViewController {

    
    var mainData : MainCellTable?
    var subData = [SubCellTable]()
    
    @IBOutlet weak var MainTitle: UILabel!
    
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var SubList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DataSetting()
        SubList.dataSource = self
        SubList.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        subDataSetting()
        SubList.reloadData()
        
    }
    func DataSetting() {
        
        
        AddButton.layer.borderWidth = 2
        AddButton.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        AddButton.layer.cornerRadius = 10
        
        MainTitle.text = mainData?.mainTitle
        subDataSetting()
        let nibName = UINib(nibName: "SubCellVC", bundle: nil)
        SubList.register(nibName, forCellReuseIdentifier: "SubCellVC")
    }
    
    func subDataSetting() {
        
        guard let hasData = mainData else { return }
        
        guard let hasUUID = hasData.mainID else { return }
        
        let fetchRequst : NSFetchRequest<SubCellTable> = SubCellTable.fetchRequest()
        
        fetchRequst.predicate = NSPredicate(format: "mainID = %@", hasUUID)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            self.subData = try context.fetch(fetchRequst)
        }catch {
            print(error)
        }
    }

    @IBAction func SubAddPress(_ sender: Any) {
        let SubInsertVC = SubInsertVC(nibName: "SubInsertVC", bundle: nil)
        
        SubInsertVC.mainData = mainData
        SubInsertVC.Flag = "new"
        
        self.show(SubInsertVC, sender: nil)
    }
    

}
extension SubListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let SubCellVC = tableView.dequeueReusableCell(withIdentifier: "SubCellVC", for: indexPath) as! SubCellVC

        SubCellVC.SubTitle.text = subData[indexPath.row].subTitle
        SubCellVC.SubRating.text = String(subData[indexPath.row].subRating)
        
        return SubCellVC
    }
    }
    

extension SubListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SubInsertVC = SubInsertVC(nibName: "SubInsertVC", bundle: nil)
        
        SubInsertVC.mainData = self.mainData
        SubInsertVC.subData = subData[indexPath.row]
        SubInsertVC.Flag = "update"
        
        self.show(SubInsertVC, sender: nil)
    }
    
}
