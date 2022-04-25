//
//  MapViewController.swift
//  Farmers Market
//
//  Created by 庄玮祺 on 4/24/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let centerlocation = CLLocationCoordinate2D(latitude: 40.42501, longitude: -86.91432)
        
        let mapSpan = MKCoordinateSpan.init(latitudeDelta: 0.003, longitudeDelta: 0.003)
        
        let mapRegion = MKCoordinateRegion.init(center: centerlocation, span: mapSpan)
        
        self.map.setRegion(mapRegion, animated: true)
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
