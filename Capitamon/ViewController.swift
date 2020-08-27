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
    @IBOutlet weak var baseExperiencePokemonDois: UILabel!
    @IBOutlet weak var baseExperiencePokemonTres: UILabel!
    @IBOutlet weak var pokemonDois: UITextField!
    @IBOutlet weak var pokemonTres: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCalculate(_ sender: Any) {
        
        // Busca a experiencia de um pokemon usando o nome do pokemon que a pessoa preencheu em PokemonUM, PokemonDOIS e PokemonTres
        let nomePokemonUm = self.pokemonUm.text
        let nomePokemonDois = self.pokemonDois.text
        let nomePokemonTres = self.pokemonTres.text
        
        let stringURL1 = "https://pokeapi.co/api/v2/pokemon/\(nomePokemonUm!)"
        let stringURL2 = "https://pokeapi.co/api/v2/pokemon/\(nomePokemonDois!)"
        let stringURL3 = "https://pokeapi.co/api/v2/pokemon/\(nomePokemonTres!)"
        
        let url1 = URL(string:stringURL1)!
        let url2 = URL(string:stringURL2)!
        let url3 = URL(string:stringURL3)!
        
        let session = URLSession.shared
        
        let task1 = session.dataTask(with: url1) { data, response, serverError in
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
        
        
        let task2 = session.dataTask(with: url2) { data, response, serverError in
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Pokemon.self, from: data!)
                
                DispatchQueue.main.async {
                    
         //conversão de int pra string
                    let guardaInt = jsonData.baseExperience
                    let experiencePokemonDois = String(guardaInt)
                    self.baseExperiencePokemonDois.text = "Experiência: " + experiencePokemonDois
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.baseExperiencePokemonDois.text = "Esse Pokemón não existe ou está escrito errado"
                }
            }
        }
        
        let task3 = session.dataTask(with: url3) { data, response, serverError in
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Pokemon.self, from: data!)
                
                DispatchQueue.main.async {
                    
         //conversão de int pra string
                    let guardaInt = jsonData.baseExperience
                    let experiencePokemonTres = String(guardaInt)
                    self.baseExperiencePokemonTres.text = "Experiência: " + experiencePokemonTres
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.baseExperiencePokemonTres.text = "Esse Pokemón não existe ou está escrito errado"
                }
            }
        }
        
        task1.resume()
        task2.resume()
        task3.resume()
        
    }
}

//Dificuldades:
//1) Como fazer as tasks retornarem valores inteiros pra que possamos somar e, assim, conseguir a experiência total?
//2) Como fazer um laço pra otimizar o código e realizar só uma task, em vez de três?
