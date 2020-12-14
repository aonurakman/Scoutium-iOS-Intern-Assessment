//
//  DataDisplayerViewController.swift
//  Scoutium
//
//  Created by Ahmet Onur Akman on 13.12.2020.
//

import UIKit

class DataDisplayerViewController: UIViewController{
    
    @IBOutlet weak var loadingAnimationBackground: UIView!
    @IBOutlet weak var animationImage: UIImageView!
    @IBOutlet weak var displayerTableView: UITableView!
    
    var displayLink: CADisplayLink! // For the loading animation
    var animationCounter = 0 // Needed counter for the animation
    let appManager = AppManager()
    
    
    let apiUrlString = "https://storage.googleapis.com/anvato-sample-dataset-nl-au-s1/life-1/data.json"
    let myNetworkingClient = NetworkingClient()
    var items: JSONItems? // Data collected from API
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLink = CADisplayLink(target: self, selector: #selector(animate))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayLink.add(to: RunLoop.main, forMode: .default)
        makeAPIRequest()
    }
    
    // You might notice that the animation plays for a little bit-
    // -longer than it is supposed to.
    // See the important note in NetworkClient.swift to see why
    @objc
    func animate(){
        if myNetworkingClient.requestCompleted {
            // If API req is completed, end the animation
            setUIWithData()
        }
        else{
            animationCounter += 1
            switch animationCounter{
            case 0...20:
                animationImage.image = #imageLiteral(resourceName: "a1-removebg-preview")
                animationImage.alpha = appManager.animationIconAlphaCalculator(range: 20, top: 20, counter: animationCounter)
            case 20...40:
                animationImage.image = #imageLiteral(resourceName: "a2-removebg-preview")
                animationImage.alpha = appManager.animationIconAlphaCalculator(range: 20, top: 40, counter: animationCounter)
                
            case 40...60:
                animationImage.image = #imageLiteral(resourceName: "a4-removebg-preview")
                animationImage.alpha = appManager.animationIconAlphaCalculator(range: 20, top: 60, counter: animationCounter)
            case 60...80:
                animationImage.image = #imageLiteral(resourceName: "a5-removebg-preview")
                animationImage.alpha = appManager.animationIconAlphaCalculator(range: 20, top: 80, counter: animationCounter)
            default:
                animationImage.image = #imageLiteral(resourceName: "a3-removebg-preview")
                animationImage.alpha = appManager.animationIconAlphaCalculator(range: 20, top: 100, counter: animationCounter)
            }
            if animationCounter == 100 {
                animationCounter = 0
            }
        }
    }
    
    func makeAPIRequest(){
        guard let myURL = URL(string: apiUrlString) else {
            print(DebugMessages.apiReqInvalidUrl.rawValue)
            return
        }
        myNetworkingClient.execute(myURL)
    }
    
    // Depending on the data fetch operation, either updates UI or pops alert
    func setUIWithData(){
        (myNetworkingClient.fetchedData != nil) ? processData() : displayErrorAlert()
        stopAnimation()
    }
    
    // Takes the data collected from API and converts into defined struct instances
    // After calls activateTable to display data on the screen
    func processData(){
        do {
            let jsonData = try? JSONSerialization.data(withJSONObject:myNetworkingClient.fetchedData!)
            items = try JSONDecoder().decode(JSONItems.self, from: jsonData!)
        } catch {
            print(DebugMessages.parsingError.rawValue)
        }
        print((items != nil) ? DebugMessages.parsingSuccess.rawValue : DebugMessages.parsingFailure.rawValue)
        if (items != nil) {
            activateTable()
        }
    }
    
    // Starts locating data on tableView
    func activateTable(){
        displayerTableView.delegate = self
        displayerTableView.dataSource = self
        displayerTableView.register(CustomTableViewCell.nib(), forCellReuseIdentifier: CustomTableViewCell.identifier)
        displayerTableView.reloadData()
    }
    
    // Stop animation and show the tableView
    // You might notice that the animation runs a little bit-
    // -longer than it is supposed to.
    // See the important note in NetworkClient.swift to see why
    func stopAnimation(){
        displayLink.remove(from: RunLoop.main, forMode: .default)
        animationImage.isHidden = true
        loadingAnimationBackground.isHidden = true
    }
    
    // If data cannot be collected, pop alert
    func displayErrorAlert(){
        showAlert(title: "API Request Failed", context: AlertMessages.noData.rawValue)
    }
    
    func showAlert(title: String, context: String){
        let alertController = UIAlertController(title: title, message:
                context, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default))

            self.present(alertController, animated: true, completion: nil)
    }
    
}

extension DataDisplayerViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell = displayerTableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier) as! CustomTableViewCell
        cell.configure(imageURL: items!.items[indexPath.row].url, cellText: items!.items[indexPath.row].title)
        return cell
    }
    
}
