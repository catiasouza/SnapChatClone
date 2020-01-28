//
//  EntrarViewController.swift
//  SnapchatClone
//
//  Created by Catia Miranda de Souza on 21/01/20.
//  Copyright © 2020 Catia Miranda de Souza. All rights reserved.
//

import UIKit
import FirebaseAuth

class EntrarViewController: UIViewController {

    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBAction func entrar(_ sender: Any) {
        //RECUPERar  DADOS
        if let emailR = self.email.text{
            if let senhaR = self.senha.text{
                //AUTENTICAR NO FIREBASE
                let autenticacao = Auth.auth()
                autenticacao.signIn(withEmail: emailR, password: senhaR) { (usuario, erro) in
                    
                    
                    if erro == nil{
                        if  usuario == nil{
                            self.exibirMensagem(titulo: "Erro ao autenticar", mensagem: "Problema ao realizar a autenticacao, tente novamente.")
                        }else{
                            //REDIRECIONA AO USUARIO PARA TELA PRINCIPAL
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        }
                    }else{
                        self.exibirMensagem(titulo: "Dados incorretos", mensagem: "verifique os dados digitados e tente novamente.")
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
           
           
           self.navigationController?.setNavigationBarHidden(false, animated: false)
       }
    func exibirMensagem(titulo: String, mensagem: String){
           
           let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
           let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler:    nil)
           alerta.addAction(acaoCancelar)
           present(alerta,animated: true, completion: nil)
           
       }
    
}
