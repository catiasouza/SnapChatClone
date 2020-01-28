//
//  DetalhesSnapViewController.swift
//  SnapchatClone
//
//  Created by Catia Miranda de Souza on 28/01/20.
//  Copyright © 2020 Catia Miranda de Souza. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class DetalhesSnapViewController: UIViewController {
    
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var contador: UILabel!
    @IBOutlet weak var detalhes: UILabel!
    
    var snap = Snap()
    var tempo = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detalhes.text = "Carregando..."
        let url = URL(string: snap.urlImagem)
        imagem.sd_setImage(with: url) { (imagem, error, cache, url) in
            if error == nil{
                self.detalhes.text = self.snap.descricao
                //INICIR TIME
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block:  { (timer) in
                    self.tempo = self.tempo - 1
                    
                    //DECREMENTAR TIME
                    self.contador.text = String(self.tempo)
                    
                    //CASO O TIMER EXECUTE ATE O 0 ,INVALIDA
                    if self.tempo == 0{
                        timer.invalidate()
                        self.dismiss(animated: true, completion:    nil)
                    }
                    
                })
                
            }
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        //REMOVE NOS
        let autenticacao = Auth.auth()
        if let idUsuarioLogado = autenticacao.currentUser?.uid{
            let dataBase = Database.database().reference()
            let usuarios = dataBase.child("usuarios")
            let snaps = usuarios.child(idUsuarioLogado).child("snaps")
            
            snaps.child(snap.identificador).removeValue()
            
            //REMOVE IMAGENS
            
            let storage = Storage.storage().reference()
            let imagens = storage.child("imagens")
            
            imagens.child("\(snap.idImagem).jpg").delete { (erro) in
                if erro == nil{
                    print("Sucesso ao excluir imagem")
                }else{
                    print("Erro ao excluir imagem")
                }
            }
            
        }
    }
}
