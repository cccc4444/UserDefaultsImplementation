//
//  main.swift
//  DanExitek
//
//  Created by Danylo Kushlianskyi on 20.09.2022.
//

import Foundation

protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei: String) -> Mobile?
    func save(_ mobile: Mobile) throws -> Mobile
    func delete(_ product: Mobile) throws
    func exists(_ product: Mobile) -> Bool
}

struct Mobile: Hashable, Codable {
    let imei: String
    let model: String
}

var storageKeys = Set<String>()
var defaults = UserDefaults.standard

class Operations: MobileStorage{
    func save(_ mobile: Mobile) throws -> Mobile {
        if let encoded = try? JSONEncoder().encode(mobile){
            if !storageKeys.contains(mobile.imei){
                defaults.set(encoded, forKey: mobile.imei)
                storageKeys.insert(mobile.imei)
            }
        }
        return mobile
    }
    
    func getAll() -> Set<Mobile> {
        var mobilesSet = Set<Mobile>()
        let dict = defaults.dictionaryRepresentation()
        for key in storageKeys{
            if let data = defaults.object(forKey: key) as? Data{
                do {
                    let decoded = try JSONDecoder().decode(Mobile.self, from: data)
                    mobilesSet.insert(decoded)
                } catch  {
                    print("error decoding the data when getting all \(error.localizedDescription)")
                }
            }
        }
        return mobilesSet
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        if let data = defaults.data(forKey: imei){
            do{
                let item = try JSONDecoder().decode(Mobile.self, from: data)
                return item
            }catch {
                print("error decoding the data when looking for imei\(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func delete(_ product: Mobile) throws {
         defaults.removeObject(forKey: product.imei)
    }
    
    func exists(_ product: Mobile) -> Bool {
        if defaults.object(forKey: product.imei) != nil {
            if let data = defaults.data(forKey: product.imei) {
                do{
                    let item = try JSONDecoder().decode(Mobile.self, from: data)
                    if product.imei == item.imei && product.model == item.model{
                        return true
                    }
                }catch {
                    print("error decoding the data when checking for existance\(error.localizedDescription)")
                }
            }
            
        }
        return false
    }
}
    
// MARK: - Uncomment to check functions

//let operation = Operations()
//UserDefaults.resetStandardUserDefaults()
//
//try operation.save(Mobile(imei: "32612876235678231", model: "Apple"))
//try operation.save(Mobile(imei: "32612876235678232", model: "Samsung"))
//try operation.save(Mobile(imei: "32612876235678233", model: "Xiaomi"))
//try operation.save(Mobile(imei: "345", model: "asf"))
//print(operation.findByImei("32612876235678233"))
//print(operation.getAll())
//try operation.delete(Mobile(imei: "32612876235678231", model: "Apple"))
//print(operation.getAll())
//print(operation.exists(Mobile(imei: "32612876235678233", model: "Xiaomi")))
//






