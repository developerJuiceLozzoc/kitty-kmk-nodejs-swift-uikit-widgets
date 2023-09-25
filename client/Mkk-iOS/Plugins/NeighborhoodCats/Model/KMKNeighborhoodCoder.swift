//
//  KMKNeighborhoodCoder.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/25/23.
//

import Foundation


struct CatAdoption: Codable, Hashable {
    let name: String
    let email: String
    let date: String
}

struct ZipcodeCat: Codable, Identifiable, Equatable, Hashable {
    static func == (lhs: ZipcodeCat, rhs: ZipcodeCat) -> Bool {
        return lhs.id == rhs.id
        
    }
    var requiredToys: [Int]
    var id: String
    var material: String
    var activeColorName: String
    var maintainer: CatAdoption?
    var breed: KittyBreed
}

extension ZipcodeCat {
    static var previews: [ZipcodeCat] {
        var arr: [ZipcodeCat] = []
        (0..<6).forEach { _ in
            arr.append(
                .init(
                    requiredToys: [0,4],
                    id: UUID().uuidString,
                    material: SceneCat.randomTexturePrefix,
                    activeColorName: SceneCat.randomActiveColor,
                    breed: KittyBreed.previews
                )
            )
        }
        return arr
    }
}

struct KMKNeighborhood: Codable {
    typealias Breed = String
    var zipcode: String
    var cats: [ZipcodeCat]
    
    // BREED
//    var pokedex: [Breed: KittyBreed]
}



struct KMKNeighborhoodCatCoder {
    func encode( stuff: KMKNeighborhood) {
        guard !kmk_isPreviews() else {
            return
        }
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        if let path = Bundle.main.resourceURL?.appendingPathComponent( "KMKNeighborhoodCatPlist.plist"),
           let data = try? encoder.encode(stuff) {
            do {
                try data.write(to: path)
                // Write the data to a file or use it in-memory
            } catch {
                print("Error encoding array: \(error)")
            }
        }
       
    }
    
    
    
    func decode() -> KMKNeighborhood? {
        guard !kmk_isPreviews() else {
            return KMKNeighborhood(zipcode: "80304", cats: ZipcodeCat.previews)
        }
        let encoder = PropertyListDecoder()
        var format = PropertyListSerialization.PropertyListFormat.xml
        
        if let path = Bundle.main.resourceURL?.appendingPathComponent( "KMKNeighborhoodCatPlist.plist"),
           let data = try? Data(contentsOf: path),
           let decoded = try? encoder.decode(KMKNeighborhood.self, from: data, format: &format),
           format == .xml
        {
            return decoded
        } else {
            guard let path = Bundle.main.path(forResource: "breeds", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
                  let kittys = try? JSONDecoder().decode([KittyBreed].self, from: data) else {
                return nil
            }
            var cats = [String: KittyBreed]()
            kittys.forEach { cat in
                cats[cat.id] = cat
            }
            
            
            var result = KMKNeighborhood(zipcode: "80304", cats: [])
            
            
            ZipcodeCat.previews
                .forEach { b in
                    var breed = b
                    if let random = KITTY_BREEDS.randomElement(),
                        let randomCat = cats[random] {
                        breed.breed = randomCat
                        result.cats.append(breed)
                    }
                    
                }
            
            
            return result
        }
    }
}
