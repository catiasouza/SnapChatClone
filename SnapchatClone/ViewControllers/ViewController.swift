//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Catia Miranda de Souza on 21/01/20.
//  Copyright © 2020 Catia Miranda de Souza. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //usuario cadastrado
        let autenticacao = Auth.auth()
        
        //DESLOGA USUSARIO
//        do {
//            try autenticacao.signOut()
//        } catch  {
//            print("ËRRO")
//        }
        autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            
            if let usuarioLogado = usuario{
                self.performSegue(withIdentifier: "loginAutomaticoSegue", sender: nil)
            }
        }
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        //OCULTA BARRA DE NAVEGACAO
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

