//
//  DebugText.swift
//  LabServer
//
//  Created by Vika Granadzer on 02.11.2022.
//

import Foundation

class Debug_Text: ObservableObject{
    func printText(text: String, access: Bool, custom: String){
        if (access){
            print("[lab] ",custom, " ", text)
        }
    }
}
