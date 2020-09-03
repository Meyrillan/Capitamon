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
    
    var url =  "https://pokeapi.co/api/v2/pokemon/"
    
    var habilidadeUm = 0
    var habilidadeDois = 0
    var habilidadeTres = 0
    
    var idUm = 0
    var idDois = 0
    var idTres = 0
    
    @IBOutlet weak var pokemonUm: UITextField!
    @IBOutlet weak var baseExperiencePokemonUm: UILabel!
    @IBOutlet weak var baseExperiencePokemonDois: UILabel!
    @IBOutlet weak var baseExperiencePokemonTres: UILabel!
    @IBOutlet weak var pokemonDois: UITextField!
    @IBOutlet weak var pokemonTres: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonUm.delegate = self
        pokemonDois.delegate = self
        pokemonTres.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.apagar))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
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
    
    //fim da ação usando a tap gesture?
    @objc func apagar(){
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Game" {
            let vcGiroscopio = segue.destination as? GiroscopioViewController
            vcGiroscopio?.listIds = [String(idUm), String(idDois), String(idTres)]
            vcGiroscopio?.listNames = [pokemonUm.text!, pokemonDois.text!, pokemonTres.text!]
            vcGiroscopio?.listBaseExperience = [habilidadeUm, habilidadeDois, habilidadeTres]
        }
    }
    
    @IBAction func btnCalculate(_ sender: Any) {
        
        // Busca a experiencia de um pokemon usando o nome do pokemon que a pessoa preencheu em PokemonUM, PokemonDOIS e PokemonTres
        let nomePokemonUm = self.pokemonUm.text!
        let nomePokeUmFormatado = nomePokemonUm.lowercased().replacingOccurrences(of: " ", with: "")
        let nomePokemonDois = self.pokemonDois.text!
        let nomePokeDoisFormatado = nomePokemonDois.lowercased().replacingOccurrences(of: " ", with: "")
        let nomePokemonTres = self.pokemonTres.text!
        let nomePokeTresFormatado = nomePokemonTres.lowercased().replacingOccurrences(of: " ", with: "")
        
        let list = [nomePokeUmFormatado, nomePokeDoisFormatado, nomePokeTresFormatado]
        
        func performNetworkRequest(url: String,
                                   completion: @escaping (Data?, Error?) -> Void) {
            let requestUrl = URL(string: url)
            let task = URLSession.shared.dataTask(with: requestUrl!) { (data, response, error) in
                completion(data, error)
            }
            task.resume()
        }
        
        for index in 0...2 {
            performNetworkRequest(url: "\(url)\(list[index])") { data, error in
                do {
                    
                    let decoder = JSONDecoder()
                    let pokemonData = try decoder.decode(Pokemon.self, from: data!)
                    
                    DispatchQueue.main.async {
                        
                        switch index {
                        case 0:
                            self.habilidadeUm = pokemonData.baseExperience
                            self.idUm = pokemonData.id
                            let experiencePokemonUm = String(self.habilidadeUm)
                            self.baseExperiencePokemonUm.text = "Experiência: " + experiencePokemonUm
//                            self.somar()
                        case 1:
                            self.habilidadeDois = pokemonData.baseExperience
                            let experiencePokemonDois = String(self.habilidadeDois)
                            self.baseExperiencePokemonDois.text = "Experiência: " + experiencePokemonDois
                            self.idDois = pokemonData.id
//                            self.somar()
                        case 2:
                            self.habilidadeTres = pokemonData.baseExperience
                            let experiencePokemonTres = String(self.habilidadeTres)
                            self.baseExperiencePokemonTres.text = "Experiência: " + experiencePokemonTres
                            self.idTres = pokemonData.id
//                            self.somar()
                        default: print("deu ruim")
                            
                        }
                    }
                    
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        switch index {
                        case 0:
                            self.baseExperiencePokemonUm.text = "Esse Pokemón não existe ou está escrito errado"
                        case 1:
                            self.baseExperiencePokemonDois.text = "Esse Pokemón não existe ou está escrito errado"
                        case 2:
                            self.baseExperiencePokemonTres.text = "Esse Pokemón não existe ou está escrito errado"
                        default: print("deu ruim")
                        }
                        
                    }
                }
                
            }
            
        }
    }
    
//    func somar() {
//        self.experienciaTotal.text =  "Experiência Total: " + (String(self.habilidadeUm + self.habilidadeDois + self.habilidadeTres))
//    }
    
}

//Dificuldades:
//1) Como fazer as tasks retornarem valores inteiros pra que possamos somar e, assim, conseguir a experiência total? RESOLVIDO!!!
//2) Como fazer um laço pra otimizar o código e realizar só uma task, em vez de três? RESOLVIDO!!!
//3) Como fazer a tela subir quando o teclado sobe? (ScrollView no artigo de Nádia)
//4) Como fazer o teclado descer quando o usuário clica na tela (TapGesture, tanto eu quanto Meyri já fizemos isso antes) RESOLVIDO!!!

//Para a próxima semana:
//1) Deixar o app mais divertido melhorando a UI
//2) Implementar um ranking na memória
//3) Como acessar sensores do iPhone ("para finalizar, veja o seu pokemon girando!")
