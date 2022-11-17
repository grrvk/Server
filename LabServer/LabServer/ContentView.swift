//
//  ContentView.swift
//  LabServer
//
//  Created by Vika Granadzer on 01.11.2022.
//

import SwiftUI

struct ContentView: View {
    @State var textFieldtextPrice: String = textT
    @State var Info: String = ""
    @State var showingAlert = false
    @State private var name = ""
    @State private var isShowing = false
    @ObservedObject var command: CommandCreator = command_observer
    var body: some View {
        //Text("Text: \(command.dataM)")
        VStack {
            /*Button(action: saveButtonPressed, label: {
                Text("Update".uppercased())
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            })*/
            HStack{
                Text("Дошка")
                    .padding(.horizontal)
                    .frame(height: 45)
                    .cornerRadius(10)
            }
            /*HStack{
                Text(Info)
                    .padding(.horizontal)
                    .frame(height: 45)
                    .cornerRadius(10)
            }*/
            HStack{
                VStack{
                    List(command.Data_matrix[0], id: \.self){
                        str in Text(str)
                            .frame(width: 70.0)
                            .padding(40)
                            .border(.black)
                    }
                }
                VStack{
                    List(command.Data_matrix[1], id: \.self){
                        str in Text(str)
                            .frame(width: 70.0)
                            .padding(40)
                            .border(.black)
                    }
                }
                VStack{
                    List(command.Data_matrix[2], id: \.self){
                        str in Text(str)
                            .frame(width: 70.0)
                            .padding(40)
                            .border(.black)
                    }
                }
                .alert(isPresented: $command.Alert) {
                    Alert(title: Text(command.alertTopText), message: Text(command.alertBottomText), dismissButton: .default(Text("Оцк")))
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(command: command_observer)
    }
}
