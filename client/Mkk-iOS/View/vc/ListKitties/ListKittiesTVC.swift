
//  ListKittiesTVC.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/2/21.
//

import UIKit
import RealmSwift
import SwipeCellKit

class ListKittiesTVC: UITableViewController  {
    
    var cd = CoreData()
    var rlm = RealmCrud()
    var kitties: Results<KittyRealm>? {
        didSet {
            guard let kitties = self.kitties else {return}
            guard kitties.count > 0 else {return}
            self.parseDataSource()
        }
    }
    
    var contentDataSource: [[KittyListRow]] = [];
    var sectionTitleDataSource: [String] = []
    
    func parseDataSource(){
        
        contentDataSource = []
        sectionTitleDataSource = []
        
        var breeddict: [String : [KittyListRow]] = [:]
        for kitty in self.kitties!{
            if let breedname = kitty.statsLink?.name {
                if  breeddict[breedname] == nil {
                    breeddict[breedname] = []
                }
                breeddict[breedname]!.append((name: kitty.name, id: kitty.uid))
            }
            
        }
        
        breeddict.keys.forEach { (breedname) in
            sectionTitleDataSource.append(breedname)
            contentDataSource.append(breeddict[breedname]!)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        
        
        tableView.rowHeight = 45.0
        let nib = UINib.init(nibName: "AdoptedKittyCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "BasicSwipeCell")
        self.kitties = rlm.fetchKitties()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.kitties = rlm.fetchKitties()
    }
    @IBAction func CreateContactClicked(_ sender: Any) {
        performSegue(withIdentifier: "ScheduleKitty", sender: nil)
    }
    /*
    @IBAction func devTest(_ sender: Any) {
        tempnetwrok.getJsonByBreed(with: "asdf") { [unowned self](result) in
            switch result {
                case .success(let kitties):
                    DispatchQueue.main.async{
                        self.performSegue(withIdentifier: "ConfirmKitty", sender: kitties)
                    }
                    
                    
                case .failure(let e):
                    print(e)
            }
        }
    }
 */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "ConfirmKitty":
                guard let vc = segue.destination as? SaveOrDiscardKittyTVC, let ks = sender as? [KittyApiResults] else {return}
                vc.kitty = ks
            case "DetailsKitty":
                guard let vc = segue.destination as? KitttyDetails, let details = sender as? KittyRealm else {return}
                vc.details = details
            case "ScheduleKitty":
                break;
            default:
                break;
        }
        
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentDataSource[section].count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitleDataSource.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitleDataSource[section];
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BasicSwipeCell") as? AdoptedKittyCell else {return UITableViewCell()}
        cell.delegate = self 
        cell.nameLabel.text = contentDataSource[indexPath.section][indexPath.row].name

        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = contentDataSource[indexPath.section][indexPath.row]
        
        guard let kitty = self.kitties?.first(where: { (k) -> Bool in
            return (k.uid == selected.id)
        }) else{ return}
        
        performSegue(withIdentifier: "DetailsKitty", sender: kitty)
    }
    

}
//extension ListKittiesTVC {
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive,
//                                              title: "Delete") { [weak self] _, _, complete in
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            complete(true)
//        }
//        deleteAction.backgroundColor = .red
//
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//
//    }
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//            if editingStyle == .delete {
//                tableView.beginUpdates()
//                self.contentDataSource[indexPath.section].remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .none)
//                tableView.endUpdates()
//            }
//        }
//}

extension ListKittiesTVC: SwipeTableViewCellDelegate {


    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {return nil}


        let deleteAction = SwipeAction(style: .destructive, title: "Delete") {
            [weak self] (action, indexPath) in
            guard let self = self else {return}

            let selectedKittyId =  self.contentDataSource[indexPath.section][indexPath.row].id
            guard let kitty = self.kitties?.first(where: { (el) -> Bool in
                return el.uid == selectedKittyId;
            }) else {return}
            self.contentDataSource[indexPath.section].remove(at: indexPath.row)
            
            self.rlm.deleteItemWithRealm(ref: kitty)

            action.fulfill(with: .delete)






        }
        deleteAction.image = UIImage(named: "Trash")
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
}
