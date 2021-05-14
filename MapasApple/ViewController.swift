import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var ubicacionLabel: UILabel!
    
    // MARK: Properties location
    var locationManager: CLLocationManager?
    var userLocation: CLLocation?
    
    // MARK: Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        
        obtenerUbicacion()
        mostrarMarcadores()
    }
    
    // MARK: Solicita ubicacion usuario
    func obtenerUbicacion() -> Void {
        // validamos si el usuario tiene el gps activo y disponible
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest // pide la ubicacion mas precisa posible
        locationManager?.requestAlwaysAuthorization() // pedira el permiso de geolocalizacion
        locationManager?.startUpdatingLocation()
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            self.ubicacionLabel.text = "No se pudo determinar la ubicacion"
        case .restricted:
            self.ubicacionLabel.text = "La ubicacion esta restringida"
        case .denied:
             self.ubicacionLabel.text = "La ubicacion fue denegada"
        case .authorizedAlways:
            mostrarUbicacionRealMapa()
        case .authorizedWhenInUse:
            mostrarUbicacionRealMapa()
        @unknown default:
            self.ubicacionLabel.text = "¡Autorizacion desconocida!"
        }
    }
    
    // MARK: Ubicacion Azul mapa
    func mostrarUbicacionRealMapa() {
        mapa.delegate = self // no es necesario, solo si haces otras cosas
        mapa.showsUserLocation = true
    }
    
    // MARK: Marcadores
    func mostrarMarcadores() -> Void {
        let marcador = MKPointAnnotation()
        marcador.coordinate.latitude = 19.2980639
        marcador.coordinate.longitude = -99.1792704
        marcador.title = "Trabajo"
        marcador.subtitle = "Por el sueldo"
        mapa.addAnnotation(marcador)
    }

}
// MARK: Extencion Map Delegate
extension ViewController : MKMapViewDelegate {

}

// MARK: Extencion locacion Delegado
extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mejorUbicacion = locations.last else {
            return
        }
        
        // en este punto ya tenemos la ubicacion
        self.userLocation = mejorUbicacion
        self.ubicacionLabel.text = "Ubicación Real: \(mejorUbicacion.coordinate.latitude), \(mejorUbicacion.coordinate.longitude) "
        
    }
    
}
