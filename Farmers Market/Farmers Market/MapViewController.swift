//
//  MapViewController.swift
//  Farmers Market
//
//  Created by 庄玮祺 on 4/24/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var api = APIGet()
    var vendors : [Vendor] = []
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let centerlocation = CLLocationCoordinate2D(latitude: 40.42501, longitude: -86.91432)
        
        let mapSpan = MKCoordinateSpan.init(latitudeDelta: 0.003, longitudeDelta: 0.003)
        
        let mapRegion = MKCoordinateRegion.init(center: centerlocation, span: mapSpan)
        
        self.map.setRegion(mapRegion, animated: true)
        api.getVendors(name: "", success:{ (vendors: [Vendor]) in
            self.vendors = vendors
            DispatchQueue.main.sync {
                
                self.setPins()
            }
        }, fail:{ error in
            print(error)
        })
        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 40.42501, longitude: -86.91432)
//        annotation.title = "longping"
//        annotation.subtitle = "best carrot ever"
//        map.addAnnotation(annotation)
    }
    
    func setPins(){
        for vendor in vendors{
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: vendor.longitude, longitude: vendor.latitude)
            annotation.title = vendor.name
            annotation.subtitle = vendor.slogan
            map.addAnnotation(annotation)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
