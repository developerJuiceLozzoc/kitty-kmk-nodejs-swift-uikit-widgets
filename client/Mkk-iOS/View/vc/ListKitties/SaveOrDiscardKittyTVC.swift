//
//  SaveOrDiscardKittyTVCTableViewController.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/2/21.
//

import UIKit
import CoreData


class SaveOrDiscardKittyTVC: UITableViewController {
    var cd = CoreData()
    var datasource: [[kittystuff]] = Array.init(repeating: [], count: 2)
    var collectionDataSource: [UIImage?] = []
    var kitty: [KittyApiResults]? {
        didSet {
            guard let kitty = self.kitty else {return}
            for _ in kitty {
                collectionDataSource.append(nil)
            }
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section < 2){
            return datasource[section].count
        }
        else{
            return 3
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return "About Kitty Breed"
            case 1:
                return "Kitty Stats"
            default:
                return "Choose A Kitty of this breed to adopt"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section < 2){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BasicLabelCell") as? KittyStatCell else {return UITableViewCell()}
            cell.info = datasource[indexPath.section][indexPath.row]
            return cell
        }
        else {
            return buildCorrectCell(type: indexPath.row)
        }

    }
    
    
    func buildCorrectCell(type: Int) -> UITableViewCell {
        switch type {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NameTextFieldCell") as? KittyNameCell else {break}
            return cell
            
        case 1:
            print("DEQUEING COLLECTION VIEW")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GridViewCell") as? KittyAdoptCollectionCell else {break}
            cell.urls = kitty?.map{
                return $0.url
            }
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmBtnCell") as? KittyConfirmBtnCell else {break}
            cell.delegate = self
            return cell;
            
        }
        return UITableViewCell()
    }

   

}
extension SaveOrDiscardKittyTVC: ConfirmKittyable {
    func confirmAdoption() {
        guard let textcell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? KittyNameCell else {return}
        guard let collectioncell = tableView.cellForRow(at: IndexPath(row: 1, section: 2))  as? KittyAdoptCollectionCell  else {return}
        
        guard let chosenid = collectioncell.selectedItem, let url = collectioncell.urls?[chosenid], let uiimg = collectioncell.imgvm.images[chosenid] else {return}
        guard let KName = textcell.textField.text else {return}
        guard let currstat = self.kitty?[0].breeds[0] else {return}
        
        
        let context = cd.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Kitty", in: context)!
        let statentity = NSEntityDescription.entity(forEntityName: "KStats", in: context)!
        
        let kitty = Kitty(entity: entity, insertInto: context)
        kitty.imgurl = url
        kitty.name = KName
        kitty.img = uiimg.pngData()
        kitty.birthday = Date().timeIntervalSince1970
        
        let stats = KStats(entity: statentity, insertInto: context)
        
        stats.dog_friendly = Int16(currstat.dog_friendly)
        stats.energy_level = Int16(currstat.energy_level)
        stats.shedding_level = Int16(currstat.shedding_level)
        stats.stranger_friendly = Int16(currstat.stranger_friendly)
        
        stats.id = currstat.id
        stats.kitty_description = currstat.description
        stats.life_span = currstat.life_span
        stats.name = currstat.name
        stats.origin = currstat.origin
        stats.temperament = currstat.temperament
        kitty.stats = stats
        
        cd.saveContext()
        navigationController?.popViewController(animated: true)
        
        
        
    }
    
    
}

extension SaveOrDiscardKittyTVC {
    override func viewDidLoad() {
        
        let nib1 = UINib.init(nibName: "KittyStatCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "BasicLabelCell")
        
        let nib2 = UINib.init(nibName: "KittyAdoptCollectionCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "GridViewCell")
        
        let nib3 = UINib.init(nibName: "KittyNameCell", bundle: nil)
        tableView.register(nib3, forCellReuseIdentifier: "NameTextFieldCell")
        
        let nib4 = UINib.init(nibName: "KittyConfirmBtnCell", bundle: nil)
        
        tableView.register(nib4, forCellReuseIdentifier: "ConfirmBtnCell")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backItem?.title = "Cancel Adoption" // why doesnt this work?
        guard let kitty = self.kitty else {return}
        datasource = Array.init(repeating: [], count: 2)
        let stats = kitty[0].breeds[0]
        datasource[0].append((pretty: "Breed", value: stats.name))
        datasource[0].append((pretty: "Character", value: stats.temperament))
        datasource[0].append((pretty: "Desc", value: stats.description))
        datasource[0].append((pretty: "Country of Origin", value: stats.origin))
        
        datasource[1].append((pretty: "Life Span", value:"\(stats.life_span) years"))
        datasource[1].append((pretty: "Dog Friendlyness", value: String.init(repeating: " 🥰 ", count: stats.dog_friendly)))
        datasource[1].append((pretty: "Energy Lvl", value: String.init(repeating: " ⚡️ ", count: stats.energy_level)))
        datasource[1].append((pretty: "Hair Shedding Amnt", value: String.init(repeating: " 🤧 ", count: stats.shedding_level)))
        datasource[1].append((pretty: "Stranger Friendly Lvl", value: String.init(repeating: " 😎 ", count: stats.stranger_friendly)))
        tableView.reloadData()
        
        
    }
}
