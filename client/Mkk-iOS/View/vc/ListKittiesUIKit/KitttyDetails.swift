//
//  KitttyDetails.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/3/21.
//

import UIKit

class KitttyDetails: UIViewController {
    var details: KittyRealm? {
        didSet {
            guard let details = self.details else {return}
            parseKittyAndSetupUI(with: details)
        }
    }
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet var traits: [UILabel]!
    @IBOutlet weak var tableView: UITableView!
    var datasource: [[kittystuff]] = Array.init(repeating: [], count: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib1 = UINib.init(nibName: "KittyStatCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "BasicLabelCell")
        let nib2 = UINib.init(nibName: "TemperamentCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "Temperament")
        tableView.dataSource = self
        tableView.delegate = self
        self.populateUI(with: details)

    }
    func parseKittyAndSetupUI(with RLMKitty: KittyRealm){
        
        
        populateDataSource(kitty: RLMKitty)
    }
    func populateUI(with deets: KittyRealm?){
        guard let photoLink = deets?.photoLink, let data = photoLink.img else {return}
        picture.image = UIImage(data: data)
        tableView.reloadData()
    }
    
    func populateDataSource(kitty:KittyRealm){
        guard let _ = kitty.photoLink, let statsLink = kitty.statsLink else {return}
        self.datasource = Array.init(repeating: [], count: 3)
        
        datasource[0].append((pretty: "Name",value: kitty.name ))
        datasource[0].append((pretty: "Adopted on", value: doubleDateToString(from: kitty.birthday)))
        datasource[0].append((pretty: "character", value: statsLink.temperament))

        datasource[1].append((pretty: "Breed Name",value: statsLink.name ))
        datasource[1].append((pretty: "Description", value: statsLink.kitty_description))
        datasource[1].append((pretty: "Country of Origin", value: statsLink.origin))
        
        datasource[2].append((pretty: "Life Span", value:"\(statsLink.life_span) years"))
        datasource[2].append((pretty: "Dog Friendlyness", value: String.init(repeating: " 🥰 ", count: statsLink.dog_friendly)))
        datasource[2].append((pretty: "Energy Lvl", value: String.init(repeating: " ⚡️ ", count: statsLink.energy_level)))
        datasource[2].append((pretty: "Hair Shedding Amnt", value: String.init(repeating: " 🤧 ", count: statsLink.shedding_level)))
        datasource[2].append((pretty: "Stranger Friendly Lvl", value: String.init(repeating: " 😎 ", count: statsLink.stranger_friendly)))
    }
    
    
}
extension KitttyDetails: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return ""
        case 1:
            return "Breed"
        default:
            return "Personality Traits"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0 && indexPath.row == 2){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Temperament") as? TemperamentCell else { return UITableViewCell()}
            let character: String = datasource[indexPath.section][indexPath.row].value
            cell.datasource = character.split(separator: ",").map{
                return String($0)
            }
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BasicLabelCell") as? KittyStatCell else {return UITableViewCell()}
            if(indexPath.section == 0 && indexPath.row == 0){
                let val = datasource[indexPath.section][indexPath.row].value
                let attr = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title3)]
                let text = NSAttributedString(string: val, attributes: attr)
                cell.statContent.attributedText = text

            }
            else{
                cell.statContent.text = datasource[indexPath.section][indexPath.row].value

            }
            cell.statLabel.text = datasource[indexPath.section][indexPath.row].pretty

            return cell
        }
       
    }
    
    
}
