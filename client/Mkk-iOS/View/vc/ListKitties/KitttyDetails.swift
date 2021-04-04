//
//  KitttyDetails.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/3/21.
//

import UIKit

class KitttyDetails: UIViewController {
    var details: Kitty? {
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


    }
    func parseKittyAndSetupUI(with CDKitty: Kitty){
        var stats: KittyBreed
        stats = KittyBreed(
            id: CDKitty.stats?.id ?? "Unknown Breed",
            name: CDKitty.stats?.name ?? "Unknown Name",
            temperament: CDKitty.stats?.temperament ?? "Unknown, Not Enough Info",
            description: CDKitty.stats?.kitty_description ?? "No Desc",
            life_span: CDKitty.stats?.life_span ?? "6-9",
            dog_friendly: Int(CDKitty.stats?.dog_friendly ?? 0),
            energy_level: Int(CDKitty.stats?.energy_level ?? 2),
            shedding_level: Int(CDKitty.stats?.shedding_level ?? 5),
            stranger_friendly: Int(CDKitty.stats?.stranger_friendly ?? 5),
            origin: CDKitty.stats?.origin ?? "Planet Earth")
        
        populateDataSource(kitty: CDKitty,with: stats)
        DispatchQueue.main.async {
            self.populateUI(with: CDKitty, stats: stats)
        }
    }
    func populateUI(with deets: Kitty, stats: KittyBreed ){
        guard let data = deets.img else {return}
        picture.image = UIImage(data: data)
        tableView.reloadData()
    }
    
    func populateDataSource(kitty:Kitty,with stats: KittyBreed){
        self.datasource = Array.init(repeating: [], count: 3)
        let birthday = Date(timeIntervalSince1970: kitty.birthday)
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy"
        
        datasource[0].append((pretty: "Name",value: kitty.name! ))
        datasource[0].append((pretty: "Adopted on", value: df.string(from: birthday)))
        datasource[0].append((pretty: "character", value: stats.temperament))

        datasource[1].append((pretty: "Breed Name",value: stats.name ))
        datasource[1].append((pretty: "Description", value: stats.description))
        datasource[1].append((pretty: "Country of Origin", value: stats.origin))
        
        datasource[2].append((pretty: "Life Span", value:"\(stats.life_span) years"))
        datasource[2].append((pretty: "Dog Friendlyness", value: String.init(repeating: " 🥰 ", count: stats.dog_friendly)))
        datasource[2].append((pretty: "Energy Lvl", value: String.init(repeating: " ⚡️ ", count: stats.energy_level)))
        datasource[2].append((pretty: "Hair Shedding Amnt", value: String.init(repeating: " 🤧 ", count: stats.shedding_level)))
        datasource[2].append((pretty: "Stranger Friendly Lvl", value: String.init(repeating: " 😎 ", count: stats.stranger_friendly)))
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
                print(text)
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
