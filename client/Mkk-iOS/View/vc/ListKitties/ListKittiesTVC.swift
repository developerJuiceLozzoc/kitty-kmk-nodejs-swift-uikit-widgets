
//  ListKittiesTVC.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/2/21.
//

import UIKit

class ListKittiesTVC: UITableViewController {
    
    var cd = CoreData()
    
    var kitties: [Kitty]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.kitties = cd.fetchKitties()
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
                guard let vc = segue.destination as? KitttyDetails, let details = sender as? Kitty else {return}
                vc.details = details
            case "ScheduleKitty":
                break;
            default:
                break;
        }
        
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arr = self.kitties else {return 0}
        return arr.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = kitties?[indexPath.row].name

        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let kitty = self.kitties?[indexPath.row] else{ return}
        performSegue(withIdentifier: "DetailsKitty", sender: kitty)
    }
    

}
