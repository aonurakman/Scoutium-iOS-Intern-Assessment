//
//  ViewController.swift
//  Scoutium
//
//  Created by Ahmet Onur Akman on 12.12.2020.
//

import UIKit
import Firebase
import FirebaseRemoteConfig

class OpeningScreenViewController: UIViewController {

    @IBOutlet weak var textFromCloud: UILabel!
    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet weak var connectionCheckIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionCheckIndicator.startAnimating()
        // Do not need to check connection in advance.
        // This control is handled within the fetching process.
        setupRemoteConfigDefaults()
        fetchRemoteConfig() // Fetch data from cloud
    }
    
    // Setting up defaults for the values to be collected from firebase
    func setupRemoteConfigDefaults(){
        let defaults = [
            RemoteConfigKeys.openingLabel.rawValue: "" as NSObject,
        ]
        RemoteConfig.remoteConfig().setDefaults(defaults)
    }
    
    // Fetch data from cloud with the given default keys
    func fetchRemoteConfig(){
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        RemoteConfig.remoteConfig().configSettings = settings
        RemoteConfig.remoteConfig().fetch(completionHandler: { [unowned self] (status, error) in
            guard error == nil else {
                print(DebugMessages.firebaseFetchError.rawValue, " \(error!)")
                // Did we get this error because of the connection?
                if !ConnectionChecker().isConnected() { hold() }
                return
            }
            print(DebugMessages.firebaseFetchSuccess.rawValue)
            RemoteConfig.remoteConfig().activate()
            self.updateViewWitchFatchedValues() // Show values on UI
        })
    }
    
    // Display values from designated UI Elements
    // -------------------IMPORTANT--------------------------
    // This function is also designed to call necessary functions-
    // -to proceed instead of returning after finishing its task.
    // This is usually not a great approach.
    // However, the assessment was specifically requiring a 3-
    // -seconds text display - whatever is the connection speed.
    func updateViewWitchFatchedValues(){
        textFromCloud.text = RemoteConfig.remoteConfig().configValue(forKey: RemoteConfigKeys.openingLabel.rawValue).stringValue ?? ""
        // Need to make sure if the connection is still there before proceeding.
        ConnectionChecker().isConnected() ? proceed() : hold()
    }
    
    // A function to be called to show text and proceed to the next view.
    func proceed(){
        stopLoadingAnimation()
        appLogoImageView.isHidden = true
        textFromCloud.alpha = 1
        goToDataDisplayer(segueID: "goToDisplayer", after: 3)
    }
    
    // The function to hold the UI as it is as the connection is not obtained.
    func hold(){
        stopLoadingAnimation()
        showAlert(title: "No Internet Connection", context: AlertMessages.noConnection.rawValue)
    }
    
    // Called to stop loading animation
    func stopLoadingAnimation(){
        connectionCheckIndicator.stopAnimating()
        connectionCheckIndicator.hidesWhenStopped = true
    }
    
    // Perform segue to the requested view
    func goToDataDisplayer(segueID: String, after: Int){
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + DispatchTimeInterval.seconds(after)), execute: {[unowned self] () in
            performSegue(withIdentifier: segueID, sender: self)
        })
    }
    
    // Pop alert box
    func showAlert(title: String, context: String){
        let alertController = UIAlertController(title: title, message:
                context, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default))

            self.present(alertController, animated: true, completion: nil)
    }
}

