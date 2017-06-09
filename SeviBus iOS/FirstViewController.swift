//
//  FirstViewController.swift
//  SeviBus iOS
//
//  Created by Rafa Vázquez on 09/06/2017.
//  Copyright © 2017 Rafa Vázquez. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var lineFiled: UITextField!

    @IBOutlet weak var busStopField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onClick(_ sender: Any) {
        let busLine = lineFiled.text!
        let busStop = busStopField.text!


        let url: String = "https://sevibus.herokuapp.com/llegada/\(busStop)/?lineas=\(busLine)"

        let urlDeVerdad = URL(string: url)!

        URLSession(configuration: .default).dataTask(with: urlDeVerdad) { (data, response, error) in
            DispatchQueue.main.async {
                if let _ = error {
                    // No rula
                    self.alertError()
                } else {
                    // Sí que rula
                    let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[AnyHashable: Any]]

                    let firstLineResult: [AnyHashable: Any] = json[0]
                    let nextBusJson = firstLineResult["nextBus"] as! [AnyHashable: Any]
                    let secondBusJson = firstLineResult["secondBus"] as! [AnyHashable: Any]

                    let nextBus = Bus(json: nextBusJson)
                    let secondBus = Bus(json: secondBusJson)

                    let arrivals = ArrivalTimes(busLineName: busLine, busStopNumber: Int(busStop)!, nextBus: nextBus, secondBus: secondBus)

                    self.alertTimes(arrivals)
                }

            }
        }.resume()


    }

    func alertTimes(_ arrivals: ArrivalTimes) {
        let message = "Primera llegada:\n\(arrivals.nextBus.time) minutos | \(arrivals.nextBus.distance) metros" +
                "\n\n" +
                "Siguiente llegada:\n\(arrivals.secondBus.time) minutos | \(arrivals.secondBus.distance) metros"

        let alert = UIAlertController(title: "Línea \(arrivals.busLineName)", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Guay", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

    func alertError() {
        let alert = UIAlertController(title: "Error", message: "Algo ha ido mal :(", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Pos fale", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }


}

