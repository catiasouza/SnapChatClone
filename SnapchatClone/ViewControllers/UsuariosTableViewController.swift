//
//  UsuariosTableViewController.swift
//  SnapchatClone
//
//  Created by Catia Miranda de Souza on 22/01/20.
//  Copyright © 2020 Catia Miranda de Souza. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UsuariosTableViewController: UITableViewController {
    
    var ususarios: [Usuario] = []
    var urlImagem = ""
    var descricao = ""
    var idImagem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataBase = Database.database().reference()
        let usuarios = dataBase.child("usuarios")
        //adiciona evento novo usuario adicionado
        usuarios.observe(DataEventType.childAdded) { (snapshot) in
            
            let dados = snapshot.value as! NSDictionary
            
            //REXCUPERA DADOS USUARIOS LOGADO
            let autenticacao = Auth.auth()
            let idUsuarioLogado = autenticacao.currentUser?.uid
            
            //RECUPERAR DADOS
            let emailUsuario = dados["email"] as! String
            let nomeUsuario = dados ["nome"] as! String
            let idUsuario = snapshot.key
            
            let usuario = Usuario(email: emailUsuario, nome: nomeUsuario, uid: idUsuario)
            
            //adiciona usuario no array
            if idUsuario != idUsuarioLogado{
                 self.ususarios.append(usuario)
            }
           
            self.tableView.reloadData()
            print(self.ususarios)
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.ususarios.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        let usuario = self.ususarios[indexPath.row]
        celula.textLabel?.text = usuario.nome
        celula.detailTextLabel?.text = usuario.email
        
        return celula
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let usuarioSelecionado = self.ususarios[indexPath.row]
        let idUsuarioSelecionado = usuarioSelecionado.uid
        
        let dataBase = Database.database().reference()
        let usuarios = dataBase.child("usuarios")
        
        
        let snaps = usuarios.child(idUsuarioSelecionado).child("snaps")
        
        // RECUPERAR DADOS DO USUARIO LOGADO
        let autenticacao = Auth.auth()
        if let idUsuarioLogado = autenticacao.currentUser?.uid{
            let usuarioLogado = usuarios.child(idUsuarioSelecionado)
            usuarioLogado.observeSingleEvent(of: DataEventType.value) { (snapshot) in
                print(snapshot)
                let dados = snapshot.value as? NSDictionary
                
                let snap = [
                    "de": dados?["email"] as! String,
                    "nome":dados?["nome"] as! String,
                    "descricao":self.descricao,
                    "urlImagem":self.urlImagem,
                    "idImagem":self.idImagem]
                
                snaps.childByAutoId().setValue(snap)
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
