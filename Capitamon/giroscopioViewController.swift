//
//  giroscopioViewController.swift
//  Capitamon
//
//  Created by Meyrillan Silva on 02/09/20.
//  Copyright © 2020 Meyrillan Silva. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class GiroscopioViewController: UIViewController {
    
    let manager = CMMotionManager()
    let queue = OperationQueue()
    
    var listIds: [String]?
    var urlImages = "https://pokeres.bastionbot.org/images/pokemon/"
    
    var listNames: [String]?
    
    var listBaseExperience: [Int]!
    
    @IBOutlet weak var imagePokeUm: UIImageView!
    @IBOutlet weak var imagePokeDois: UIImageView!
    @IBOutlet weak var imagePokeTres: UIImageView!
    @IBOutlet weak var textoFinal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.load()
        
        textoFinal.isHidden = true
        
        manager.deviceMotionUpdateInterval = 0.01
        
        if manager.isDeviceMotionAvailable {
            
            manager.startDeviceMotionUpdates(to: queue) {
                [weak self] (data: CMDeviceMotion?, error: Error?) in
                if let gravity = data?.gravity {
                    let rotation = atan2(gravity.x, gravity.y) - .pi
                    let rotationInverse = -rotation
                    
                    DispatchQueue.main.async() {
                        self?.imagePokeUm.transform = CGAffineTransform(rotationAngle: CGFloat(rotationInverse))
                        self?.imagePokeDois.transform = CGAffineTransform(rotationAngle: CGFloat(rotationInverse))
                        self?.imagePokeTres.transform = CGAffineTransform(rotationAngle: CGFloat(rotationInverse))
                    }
                }
            }
        }
        manager.startGyroUpdates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: (10 - (Double(self.listBaseExperience[0]/14)))) {
                self.imagePokeUm.frame = CGRect(x: 20, y: 65, width: 121, height: 87)
            }
            
            UIView.animate(withDuration: (10 - (Double(self.listBaseExperience[1]/14)))) {
                self.imagePokeDois.frame = CGRect(x: 147, y: 65, width: 121, height: 87)
            }
            
            UIView.animate(withDuration: (10 - (Double(self.listBaseExperience[2]/14)))) {
                self.imagePokeTres.frame = CGRect(x: 273, y: 65, width: 121, height: 87)
            }
            UIView.animate(withDuration: 2) {
                self.textoFinal.text = "Parabéns! Os seus pokémons capitalistas conseguiram ganhar \n R$ \(String(self.listBaseExperience[0] + self.listBaseExperience[1] + self.listBaseExperience[2])),00 reais."
                self.textoFinal.layer.isHidden = false
            }
        }
        
    }
    
    func load() {
        
        func performNetworkRequest(url: String,
                                   completion: @escaping (Data?, Error?) -> Void) {
            let requestUrl = URL(string: url)
            let task = URLSession.shared.dataTask(with: requestUrl!) { (data, response, error) in
                completion(data, error)
            }
            task.resume()
        }
        
        for index in 0...2 {
            performNetworkRequest(url: "\(urlImages)\(listIds![index]).png") { imageData, error in
                
                DispatchQueue.main.async {
                    
                    switch index {
                    case 0:
                        self.imagePokeUm.image = UIImage(data: imageData!)
                    case 1:
                        self.imagePokeDois.image = UIImage(data: imageData!)
                    case 2:
                        self.imagePokeTres.image = UIImage(data: imageData!)
                    default: print("deu ruim")
                        
                    }
                }
                
            }
            
        }
        
    }
}
