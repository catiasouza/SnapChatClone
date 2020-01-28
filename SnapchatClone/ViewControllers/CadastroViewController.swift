//
//  CadastroViewController.swift
//  SnapchatClone
//
//  Created by Catia Miranda de Souza on 21/01/20.
//  Copyright © 2020 Catia Miranda de Souza. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CadastroViewController: UIViewController {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senhaConfirmada: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var nomeCompleto: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // BARRA DE NAVEGACAO
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    //EXIBIR MSG
    func exibirMensagem(titulo: String, mensagem: String){
        
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler:    nil)
        alerta.addAction(acaoCancelar)
        present(alerta,animated: true, completion: nil)
        
    }
    //RECUPERAR DADOS DIGITADOS
    @IBAction func criarconta(_ sender: Any) {
        if let emailR = self.email.text {
            if let nomeCompletoR = self.nomeCompleto.text {
                if let senhaR = self.senha.text{
                    if let senhaconfirmadaR = self.senhaConfirmada.text{
                        
                        //VALIDAR SENHA
                        if senhaR == senhaconfirmadaR{
                            //VALIDA NOME
                            if nomeCompletoR != ""{
                                
                                
                                //CRIAR CONTA NO FIREBASE
                                let autenticacao = Auth.auth()
                                autenticacao.createUser(withEmail: emailR, password: senhaR) { (usuario, erro) in
                                    
                                    if erro == nil{
                                        if usuario == nil{
                                            self.exibirMensagem(titulo: "Erro ao autenticar", mensagem: "Problema ao realizar a autenticacao, tente novamente.")
                                        }else{
                                            // SALVA DADOS NO FB
                                            let database = Database.database().reference()
                                            let usuarios = database.child("usuarios")
                                            
                                            let usuarioDados = ["nome": nomeCompletoR, "email": emailR]
                                            usuarios.child(usuario!.user.uid).setValue(usuarioDados)
                                            
                                            
                                            
                                            //REDIRECIONA AO USUARIO PARA TELA PRINCIPAL
                                            self.performSegue(withIdentifier: "cadastroLoginSegue", sender: nil)
                                            
                                        }
                                    }else{
                                        let erroR = erro! as NSError
                                        print( erroR.userInfo )
                                        
                                        
                                    }
                                }
                            }else{
                                self.exibirMensagem (titulo: "Dados Incorretos", mensagem: "Digite seu nome para prosseguir!")
                            }
                        }else{
                            self.exibirMensagem(titulo: "Dados incorretos.", mensagem: "As senhas nao estao iguais, digite novamente.")
                        }//FIM VALIDACAO SENHA
                    }
                }
            }
        }
    }
    
    
}
