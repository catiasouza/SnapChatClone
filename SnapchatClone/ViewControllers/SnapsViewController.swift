//
//  SnapsViewController.swift
//  SnapchatClone
//
//  Created by Catia Miranda de Souza on 21/01/20.
//  Copyright © 2020 Catia Miranda de Souza. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalSnaps = snaps.count
        if totalSnaps == 0 {
            return 1
        }
        return totalSnaps
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
        let totalSnaps = snaps.count
        if totalSnaps == 0{
            celula.textLabel?.text = "Nenhum snap para voce :)"
        }else{
            let snap = self.snaps[indexPath.row]
            celula.textLabel?.text = snap.nome
        }
        return celula
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
          let totalSnaps = snaps.count
        
        if totalSnaps > 0 {
            let snap = self.snaps[indexPath.row]
            self.performSegue(withIdentifier: "detalhesSnapSegue", sender: snap)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detalhesSnapSegue"{
            let detalhesSnapViewController = segue.destination as! DetalhesSnapViewController
            
            detalhesSnapViewController.snap = sender as! Snap
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    var snaps:[Snap] = []
    
    @IBAction func sair(_ sender: Any) {
        //deslogar usuario
        let autenticacao = Auth.auth()
        do {
            try autenticacao.signOut()
            dismiss(animated: true, completion: nil) //FECHA A TELA
        } catch  {
            print("ËRRO")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //RECUPERAR ID USUARIO LOGADO
         let autenticacao = Auth.auth()
        if let idUsuarioLogado = autenticacao.currentUser?.uid{
            let dataBase = Database.database().reference()
            let usuarios = dataBase.child("usuarios")
            
            let snaps = usuarios.child(idUsuarioLogado).child("snaps")
            
            //CRIA OUVINTE PARA SNAPS
            snaps.observe(DataEventType.childAdded) { (snapshot) in
               
                let dados = snapshot.value as? NSDictionary
                
                let snap = Snap()
                snap.identificador = snapshot.key
                snap.nome = dados?["nome"] as! String
                snap.descricao =  dados?["descricao"] as! String
                snap.urlImagem =  dados?["urlImagem"] as! String
                snap.idImagem =  dados?["idImagem"] as! String
                
                self.snaps.append(snap)
                self.tableView.reloadData()
                
            }
            //ADICIONA EVENTO PRA ITEM REMOVIDO
            snaps.observe(DataEventType.childRemoved) { (snapshot) in
                print(snapshot)
                
                var indice = 0
                for snap in self.snaps{
                    
                    print("indice atual: " + String(indice))
                    
                    if snap.identificador == snapshot.key{
                        self.snaps.remove(at: indice)
                        print("Snap removido " + snap.identificador)
                    }
                    indice = indice + 1
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    
}
