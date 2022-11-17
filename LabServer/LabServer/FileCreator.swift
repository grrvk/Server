//
//  FileCreator.swift
//  LabServer
//
//  Created by Vika Granadzer on 02.11.2022.
//

import Foundation

class File_Output: ObservableObject{
    init(){
        file = "LabTextServer.txt"
        textToWrite = ""
        filePath = NSHomeDirectory() + "/LabTextServer.txt"
        if FileManager.default.fileExists(atPath: filePath) {
            do{
                try FileManager.default.removeItem(atPath: filePath)
            }
            catch{
                print("error file")
            }
        }
        FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = documentDirectory.appendingPathComponent(filePath)
    }
    var textToWrite = ""
    public var file = ""
    var fileURL: URL
    var filePath: String
    func writeSocketMessage(text: String, remoteAdress: String){
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "'['yyyy-MM-dd' 'HH:mm:ss']'"
        textToWrite = remoteAdress + " " + formatter2.string(from: Date.now)+"[lab]" + text + "\n"
        if FileManager.default.fileExists(atPath: filePath) {
            if let fileHandle = try? FileHandle(forWritingTo: URL(string: filePath)!) {
                        fileHandle.seekToEndOfFile()
                        fileHandle.write(textToWrite.data(using: String.Encoding.utf8)!)
                        }
                    }
    }
    func writeT(text: String){
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "'['yyyy-MM-dd' 'HH:mm:ss']'"
        textToWrite = formatter2.string(from: Date.now)+"[lab]" + text + "\n"
        if FileManager.default.fileExists(atPath: filePath) {
            if let fileHandle = try? FileHandle(forWritingTo: URL(string: filePath)!) {
                        fileHandle.seekToEndOfFile()
                        fileHandle.write(textToWrite.data(using: String.Encoding.utf8)!)
                        }
                    }
    }
}
