//
//  CommandCreator.swift
//  LabServer
//
//  Created by Vika Granadzer on 03.11.2022.
//

import Foundation

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

/*let str = "abcdef"
 str[1 ..< 3] // returns "bc"
 str[5] // returns "f"
 str[80] // returns ""
 str.substring(fromIndex: 3) // returns "def"
 str.substring(toIndex: str.length - 2) // returns "abcd"*/

class CommandCreator: ObservableObject {
    init(){
        command = ""
        info = ""
        Data_matrix = [["","" ,"" ], [ "","" ,"" ], [ "","" ,"" ]]
        command_validation = "OK"
        Alert = false
        size = 0
        alertTopText = ""
        alertBottomText = ""
    }
    @Published var command: String
    var info:  String
    var command_validation: String
    var Alert: Bool
    var alertTopText: String
    var alertBottomText: String
    var size: Int
    @Published var Data_matrix: Array<Array<String>>
    func observe_data(data: String){
        DispatchQueue.main.sync{
            if (data.length != 1){
                command_validation = "OK"
                size = (data[0] as NSString).integerValue
                //file_output.writeT(text: "Size: \(String(size))")
                self.command = data[1 ..< size+1]
                //file_output.writeT(text: "Command: \(self.command)")\
                let index = data.index(data.startIndex, offsetBy: size+1)
                self.info = String(data.suffix(from: index))
                self.observe_command(comm: self.command)
            }
        }
    }
    func observe_command(comm: String){
        let comm_text = comm[0 ..< 4]
        //file_output.writeT(text: "Comm_text: \(comm_text)")
        if (comm_text == "Who"){
            Alert = true
            alertTopText = "Інформація"
            alertBottomText = "Виконала Гранадзер Вікторія, К28\nВаріант 5: Електронна дошка обʼяв"
        }
        else if (comm_text == "CLR"){
            Data_matrix = [["","" ,"" ], [ "","" ,"" ], [ "","" ,"" ]]
        }
        else{
            let index = comm.index(comm.startIndex, offsetBy: 4)
            let comm_index = String(comm.suffix(from: index))
            //file_output.writeT(text: "Comm_ind: \(comm_index)")
            var first_index = (comm_index as NSString).integerValue
            var second_index = (comm_index as NSString).integerValue
            if (((comm_index as NSString).integerValue > 0) && ((comm_index as NSString).integerValue <= 9)){
                if (first_index % 3 == 0){
                    first_index = first_index / 3 - 1
                    second_index = 2
                }
                else{
                    first_index = first_index / 3
                    second_index = second_index % 3 - 1
                }
            }
            else{
                Alert = true
                alertTopText = "Помилка"
                alertBottomText = "Індекс команди \(command) поза зоною"
                command_validation = "NOK"
                return;
            }
            if (comm_text == "Put_"){
                Data_matrix[first_index][second_index] = info
                //file_output.writeT(text: "Matrix at \(first_index)\(second_index) = \(Data_matrix[first_index][second_index])")
            }
            else{
                Data_matrix[first_index][second_index] = ""
                //file_output.writeT(text: "Matrix at \(first_index)\(second_index) = \(Data_matrix[first_index][second_index])")
            }
        }
    }
}

/*
Commands:
 PUT_4
 Who
 CLR
 CLR_
 */
