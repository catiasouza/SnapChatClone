//
//  FotoViewController.swift
//  SnapchatClone
//
//  Created by Catia Miranda de Souza on 21/01/20.
//  Copyright © 2020 Catia Miranda de Souza. All rights reserved.
//

import UIKit
import FirebaseStorage

class FotoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var descricao: UITextField!
    @IBOutlet weak var botaoProximo: UIButton!
    
    var idImage = NSUUID().uuidString
    var imagePicker = UIImagePickerController()
    
    @IBAction func proximoPasso(_ sender: Any) {
        self.botaoProximo.isEnabled = false //desabilitar o botao
        self.botaoProximo.setTitle("Carregando...", for: .normal)
        //SALVAR NO FIREBASE
        let armazenamento = Storage.storage().reference()
        let imagens = armazenamento.child("imagens") //child cria pastas p imagens
        //recuperar imagem
        if let imagemrecuperada = foto.image{
            
            if  let imagemDados = imagemrecuperada.jpegData(compressionQuality: 0.1){
                let imagemArquivo = imagens.child("\(self.idImage).jpg")
                imagemArquivo.putData(imagemDados, metadata: nil) { (metaDados, erro) in
                    
                    if erro == nil{
                        print("Sucesso ao fazer o upload do arquivo")
                        
                        imagemArquivo.downloadURL { (url, erro) in
                            print((url?.absoluteString)!)
                            
                            self.performSegue(withIdentifier: "selecionarUsuarioSegue", sender: url)
                        }
                        self.botaoProximo.isEnabled = true //desabilitar o botao
                        self.botaoProximo.setTitle("Proximo", for: .normal)
                    }else{
                        print("Erro ao fazer o upload do arquivo")
                        
                        let alerta = Alerta(titulo: "Upload falhou", mensagem: "Erro ao fazer o upload do arquivo")
                        
                        alerta.getAlerta()
                        self.present(alerta.getAlerta(), animated: true, completion: nil)
                    }
                }
            }
            
        }
        
    } /*fim metodo */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selecionarUsuarioSegue"{
            let usuarioViewController = segue.destination as! UsuariosTableViewController
            
            usuarioViewController.descricao = self.descricao.text!
            usuarioViewController.urlImagem = "\(sender!)"
            usuarioViewController.idImagem = self.idImage
        }
    }
    
    @IBAction func selecionarFoto(_ sender: Any) {
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
    }
    //RECUPERAR FOTO SELECIONADA
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageRecuperada = info[UIImagePickerController.InfoKey.originalImage
            ] as! UIImage
        
        foto.image = imageRecuperada
        //HABILITAR BOTAO PROXIMO
        self.botaoProximo.isEnabled = true
        self.botaoProximo.backgroundColor = UIColor(red: 0.553, green: 0.369, blue: 0.749, alpha: 1)
        imagePicker.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        //desabilitar o botao
        botaoProximo.isEnabled = false
        botaoProximo.backgroundColor = UIColor.gray
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
