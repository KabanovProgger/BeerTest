//
//  BreweryCell.swift
//  BeerTest
//
//  Created by Owner on 8/10/24.
//

import UIKit
import MapKit

class BreweryCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breweryTypeLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var postalLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var adress1Label: UILabel!
    @IBOutlet weak var adress2Label: UILabel!
    @IBOutlet weak var adress3Label: UILabel!
    
    var websiteURL: String?
    var latitude: String?
    var longitude: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func connect(with brewery: Brewery){
        
        
        nameLabel.text = brewery.name
        breweryTypeLabel.text = brewery.breweryType
        countryLabel.text = brewery.country
        stateLabel.text = brewery.state
        cityLabel.text = brewery.city
        phoneLabel.text = brewery.phone
        postalLabel.text = brewery.postalCode
        adress1Label.text = brewery.address1
        adress2Label.text = brewery.address2
        adress3Label.text = brewery.address3
        
        // website button
        
        if let url = brewery.websiteURL{
            websiteButton.setTitle("Visit website", for: .normal)
            websiteButton.isHidden = false
            websiteURL = url
        } else {
            websiteButton.isHidden = true
        }
        
        // show on map
            
        if let latit = brewery.latitude,
           let longit = brewery.longitude, !latit.isEmpty, !longit.isEmpty {
            mapButton.isHidden = false
            longitude = longit
            latitude = latit
        } else {
            mapButton.isHidden = true
        }
        
    }
    
    // mapButtonTapped func
    @IBAction func mapButtonTapped(_ sender: Any) {
        guard let latitString = latitude,
              let longitString = longitude,
              let longit = Double(longitString),
              let latit =
                Double(latitString) else {
            return
        }
        
        let coordinates = CLLocationCoordinate2D(latitude: latit, longitude: longit)
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = nameLabel.text
        
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    
    
    // websiteButtonTapped func
    @IBAction func websiteButtonTapped(_ sender: Any) {
        
        if let urlString = websiteURL,
           let url = URL(string: urlString){
            UIApplication.shared.open(url)
        }
        
    }
}
