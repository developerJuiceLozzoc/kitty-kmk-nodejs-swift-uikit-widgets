
//  ListKittiesTVC.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/2/21.
//

import UIKit

class ListKittiesTVC: UITableViewController {
    
    var tempnetwrok = MockNetwork()
    var cd = CoreData()
    
    var kitties: [Kitty]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.kitties = cd.fetchKitties()

    }

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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ConfirmKitty"){
            guard let vc = segue.destination as? SaveOrDiscardKittyTVC, let ks = sender as? [KittyApiResults] else {return}
            vc.kitty = ks
        }
        else if (segue.identifier == "DetailsKitty"){
            guard let vc = segue.destination as? KitttyDetails, let details = sender as? Kitty else {return}
            vc.details = details
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
class MockNetwork: CatApier {
    func getJsonByBreed(with breed: String, completion: @escaping (Result<[KittyApiResults], KMKNetworkError>) -> Void) {
        let url = URL(fileURLWithPath: "/Users/yarg347/Documents/code/SwiftProjects/kitty-kmk/client/Mkk-iOSTests/MockNetwork.json")
        URLSession.shared.dataTask(with: url){data,resp,err in
                if let error = err {
                    print (error)
                    completion(.failure(.invalidRequestError))
                    return
                }
                if let data = data {
                    do{
                        let swiftkitty = try JSONDecoder().decode([KittyApiResults].self, from: data)
                        completion(.success(swiftkitty))
                    }
                    catch let err{
                        print(err)
                        completion(.failure(.decodeFail))
                    }

                }else{
                    completion(.failure(.noBreedsFoundError))
                    
                }
        }.resume()
    }
    
    func getKittyImageByBreed(with breed: String, completion: @escaping (Result<UIImage, KMKNetworkError>) -> Void) {
        return
    }
    
    
}
