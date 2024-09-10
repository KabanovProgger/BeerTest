//
//  ViewController.swift
//  BeerTest
//
//  Created by Owner on 8/4/24.
//

import UIKit
import CoreData
import SystemConfiguration

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var serachNameTF: UITextField!
    
    var breweries: Breweries = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        if isInternetAvailable(){
            connectbreweries()
        } else {
            fetchBreweriesFromCoreData()
        }
    }
    
    // check of connection Internet
    private  func isInternetAvailable() -> Bool {
        var reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com")
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
    }
    
    func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // API for catch breweries
    func connectbreweries() {
        let urlString = "​https://api.openbrewerydb.org/breweries"
        let trimmedUrlString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: trimmedUrlString) else { return }
        let task = URLSession.shared.dataTask(with: url) {
            [weak self] data, response, error in
            guard let self  = self else {
                return
            }
            guard let data = data, error == nil else {return}
            
            do {
                let breweries = try
                JSONDecoder().decode(Breweries.self, from: data)
                self.breweries = breweries
                
                // saving to core data
                self.saveBreweriesToCoreData(breweries)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let jsonError {
                print("Cant decode", jsonError)
            }
        }
        task.resume()
    }
    
    // saving catched breweries
    func saveBreweriesToCoreData(_ breweries: Breweries) {
        // delete old data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BreweryEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try
            context.execute(deleteRequest)
        } catch {
            print("Faild to delete old data: \(error)")
        }
        for brewery in breweries {
            let breweryEntity = BreweryEntity(context: context)
            breweryEntity.id = brewery.id
            breweryEntity.stateProvince = brewery.stateProvince
            breweryEntity.websiteURL = brewery.websiteURL
            breweryEntity.postalCode = brewery.postalCode
            breweryEntity.longitude = brewery.longitude
            breweryEntity.latitude = brewery.latitude
            breweryEntity.phone = brewery.phone
            breweryEntity.city = brewery.city
            breweryEntity.state = brewery.state
            breweryEntity.country = brewery.country
            breweryEntity.breweryType = brewery.breweryType
            breweryEntity.name = brewery.name
            breweryEntity.adress1 = brewery.address1
            breweryEntity.adress2 = brewery.address2
            breweryEntity.adress3 = brewery.address3
            breweryEntity.street = brewery.street
        }
        do {
            try context.save()
        } catch {
            print("Failed to save data \(error)")
        }
    }
    
    // upload data from core data
    func fetchBreweriesFromCoreData() {
        let request: NSFetchRequest<BreweryEntity> = BreweryEntity.fetchRequest()
        do {
            let breweryEntities = try context.fetch(request)
            breweries = breweryEntities.map { breweryEntity in
                return Brewery(
                    id: breweryEntity.id,
                    name: breweryEntity.name,
                    breweryType:  breweryEntity.breweryType,
                    address1:  breweryEntity.adress1,
                    address2:  breweryEntity.adress2,
                    address3:  breweryEntity.adress3,
                    city: breweryEntity.state,
                    stateProvince: breweryEntity.stateProvince,
                    postalCode:  breweryEntity.city,
                    country: breweryEntity.postalCode,
                    longitude: breweryEntity.country,
                    latitude: breweryEntity.phone,
                    phone: breweryEntity.websiteURL,
                    websiteURL:  breweryEntity.longitude,
                    state: breweryEntity.latitude,
                    street: breweryEntity.street
                )
            }
            tableView.reloadData()
        } catch {
            print("Failed to detch data from Core Data \(error)")
        }
    }
    
    // API for catching breweries by Name
    func searchBreweries(byName name: String) {
        let urlString = "​https://api.openbrewerydb.org/breweries"
        let noTrimmedUrlString = "\(urlString)?by_name=\(name)"
        guard let trimmedUrlString = noTrimmedUrlString.trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: trimmedUrlString) else { return }
        let task = URLSession.shared.dataTask(with: url) {
            [weak self] data, response, error in
            guard let self  = self else { return }
            guard let data = data, error == nil else { return }
            do {
                let breweries = try
                JSONDecoder().decode(Breweries.self, from: data)
                self.breweries = breweries
                self.saveBreweriesToCoreData(breweries)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let jsonError {
                print("Cant decode", jsonError)
            }
        }
        task.resume()
    }
    
    // search Breweries in Core Data by Name
    func searchBreweriesInCoreData(byName name: String) {
        let request: NSFetchRequest<BreweryEntity> = BreweryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
        do {
            let breweryEntities = try context.fetch(request)
            breweries = breweryEntities.map { breweryEntity in
                return Brewery(
                    id: breweryEntity.id,
                    name: breweryEntity.name,
                    breweryType:  breweryEntity.breweryType,
                    address1:  breweryEntity.adress1,
                    address2:  breweryEntity.adress2,
                    address3:  breweryEntity.adress3,
                    city: breweryEntity.state,
                    stateProvince: breweryEntity.stateProvince,
                    postalCode:  breweryEntity.city,
                    country: breweryEntity.postalCode,
                    longitude: breweryEntity.country,
                    latitude: breweryEntity.phone,
                    phone: breweryEntity.websiteURL,
                    websiteURL:  breweryEntity.longitude,
                    state: breweryEntity.latitude,
                    street: breweryEntity.street
                )
            }
            tableView.reloadData()
        } catch {
            print("Failed to fetch data from Core Data \(error)")
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        guard let query = serachNameTF.text, !query.isEmpty else { return  connectbreweries() }
        if isInternetAvailable(){
            searchBreweries(byName: query)
        } else {
            searchBreweriesInCoreData(byName: query)
        }
    }
}


extension ViewController: UITableViewDataSource,  UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breweries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreweryCell", for: indexPath) as! BreweryCell
        let brewery = breweries[indexPath.row]
        cell.connect(with: brewery)
        return cell
    }
}

