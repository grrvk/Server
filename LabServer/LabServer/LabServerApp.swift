//
//  LabServerApp.swift
//  LabServer
//
//  Created by Vika Granadzer on 01.11.2022.
//

import SwiftUI

var access = true

@main
struct LabServerApp: App {
    
    let socketServer: SocketServer;
    init(){
        socketServer = SocketServer(port: 1030)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(command: command_observer)
        }
    }
}
