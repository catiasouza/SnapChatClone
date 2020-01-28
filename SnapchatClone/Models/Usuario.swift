//
//  Usuario.swift
//  SnapchatClone
//
//  Created by Catia Miranda de Souza on 22/01/20.
//  Copyright © 2020 Catia Miranda de Souza. All rights reserved.
//

import Foundation

class Usuario{
    
    var email: String
    var nome: String
    var uid: String
    
    init(email: String, nome: String, uid: String){
        self.email = email
        self.nome = nome
        self.uid = uid
    }
}
