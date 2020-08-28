//
//  ViewController.swift
//  Capitamon
//
//  Created by Meyrillan Silva on 26/08/20.
//  Copyright © 2020 Meyrillan Silva. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {
    
    var habilidadeUm = 0
    var habilidadeDois = 0
    var habilidadeTres = 0
    
    
    @IBOutlet weak var pokemonUm: UITextField!
    @IBOutlet weak var baseExperiencePokemonUm: UILabel!
    @IBOutlet weak var baseExperiencePokemonDois: UILabel!
    @IBOutlet weak var baseExperiencePokemonTres: UILabel!
    @IBOutlet weak var pokemonDois: UITextField!
    @IBOutlet weak var pokemonTres: UITextField!
    @IBOutlet weak var experienciaTotal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonUm.delegate = self
        pokemonDois.delegate = self
        pokemonTres.delegate = self
        
        // Do any additional setup after loading the view.
        somar()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == pokemonUm {
            pokemonDois.becomeFirstResponder()
        } else if textField == pokemonDois {
            pokemonTres.becomeFirstResponder()
        } else if textField == pokemonTres {
            textField.resignFirstResponder()
        }
        return false
    }
    
    
    @IBAction func btnCalculate(_ sender: Any) {
        
        // Busca a experiencia de um pokemon usando o nome do pokemon que a pessoa preencheu em PokemonUM, PokemonDOIS e PokemonTres
        let nomePokemonUm = self.pokemonUm.text
        let nomePokeUmFormatado = nomePokemonUm?.lowercased().replacingOccurrences(of: " ", with: "")
        let nomePokemonDois = self.pokemonDois.text
        let nomePokeDoisFormatado = nomePokemonDois?.lowercased().replacingOccurrences(of: " ", with: "")
        let nomePokemonTres = self.pokemonTres.text
        let nomePokeTresFormatado = nomePokemonTres?.lowercased().replacingOccurrences(of: " ", with: "")

        
        let stringURL1 = "https://pokeapi.co/api/v2/pokemon/\(nomePokeUmFormatado!)"
        let stringURL2 = "https://pokeapi.co/api/v2/pokemon/\(nomePokeDoisFormatado!)"
        let stringURL3 = "https://pokeapi.co/api/v2/pokemon/\(nomePokeTresFormatado!)"
        
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
                    self.habilidadeUm = jsonData.baseExperience
                    let experiencePokemonUm = String(self.habilidadeUm)
                    self.baseExperiencePokemonUm.text = "Experiência: " + experiencePokemonUm
                    self.somar()
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
                    self.habilidadeDois = jsonData.baseExperience
                    let experiencePokemonDois = String(self.habilidadeDois)
                    self.baseExperiencePokemonDois.text = "Experiência: " + experiencePokemonDois
                    self.somar()
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
                    self.habilidadeTres = jsonData.baseExperience
                    let experiencePokemonTres = String(self.habilidadeTres)
                    self.baseExperiencePokemonTres.text = "Experiência: " + experiencePokemonTres
                    self.somar()
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
    
    func somar() {
        experienciaTotal.text =  "Experiência Total: " + (String(self.habilidadeUm + self.habilidadeDois + self.habilidadeTres))
    }
    
}

//Dificuldades:
//1) Como fazer as tasks retornarem valores inteiros pra que possamos somar e, assim, conseguir a experiência total?
//2) Como fazer um laço pra otimizar o código e realizar só uma task, em vez de três?
