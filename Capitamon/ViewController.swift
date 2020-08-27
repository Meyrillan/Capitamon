//
//  ViewController.swift
//  Capitamon
//
//  Created by Meyrillan Silva on 26/08/20.
//  Copyright © 2020 Meyrillan Silva. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var habilidade: String = ""
    
    @IBOutlet weak var pokemonUm: UITextField!
    @IBOutlet weak var baseExperiencePokemonUm: UILabel!
    @IBOutlet weak var pokemonDois: UITextField!
    @IBOutlet weak var pokemonTres: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCalculate(_ sender: Any) {
        
        // Busca a experiencia de um pokemon usando o nome do pokemon que a pessoa preencheu em PokemonUM
        let nomePokemonUm = self.pokemonUm.text
        let stringURL = "https://pokeapi.co/api/v2/pokemon/\(nomePokemonUm!)"
        let url = URL(string:stringURL)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, serverError in
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Pokemon.self, from: data!)
                
                DispatchQueue.main.async {
         //conversão de int pra string
                    let guardaInt = jsonData.baseExperience
                    let experiencePokemonUm = String(guardaInt)
                    self.baseExperiencePokemonUm.text = "Experiência: " + experiencePokemonUm
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.baseExperiencePokemonUm.text = "Esse Pokemón não existe ou está escrito errado"
                }
            }
        }
        
        task.resume()
        
    }
}
