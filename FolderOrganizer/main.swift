#!/usr/bin/swift
//
//  main.swift
//  FolderOrganizer
//
//  Created by Rodrigo Silva Ribeiro on 13/03/20.
//  Copyright © 2020 Rodrigo Silva Ribeiro. All rights reserved.
//



import Foundation

//CLASSES FOR CODABLE
class FilePaths: Codable {
    var path: String?
    var folder: Folder?
}
class Folder: Codable {
    var folderName: String?
    var dataTypes: String?
    var folder: Folder?
}

//FUNCS
func getJson() -> FilePaths? {
    let file = "/Desktop/FolderOrganizer/FolderOrganizer/file.json"
    let reader = JSONReader(file)
    guard let dados = try? reader.readJsonData() else {
        exit(0)
    }
    let decoder = JSONDecoder()
    let object = try? decoder.decode(FilePaths.self, from: dados)
    return object
}

//CONSTANTS
let fileManager = FileManager.default
let home = fileManager.homeDirectoryForCurrentUser
var extensions  = [String]()
let fm = Controller.init()
var set = CharacterSet()
set.insert(charactersIn: ", ;.")

let dadosJSon = getJson()
guard let unJson = dadosJSon else {
    exit(0)
}

guard let fileToSniff = unJson.path else {
    exit(0)
}

let dirURL = home.appendingPathComponent(fileToSniff)
let fileURLs = try fileManager.contentsOfDirectory(at: dirURL, includingPropertiesForKeys: nil)




for file in fileURLs {
    if !extensions.contains(file.pathExtension) {
        extensions.append(file.pathExtension)
    }
}


extensions.remove(at: 0)

for ext in extensions{
    print(extensions.firstIndex(of: ext)!+1, ":", ext)
}

guard var fileType = readLine() else {
    exit(0)
}

let choosed = fileType.components(separatedBy: set)


for choose in choosed{
    var newDirectory = try fm.createFolder(dirURL, extensions[Int(choose)! - 1])
    for file in fileURLs {
        if (file.pathExtension == extensions[Int(choose)! - 1]) {
            newDirectory = newDirectory.appendingPathComponent(file.lastPathComponent)
            print(newDirectory)
            try fm.transferFiles(file, newDirectory)
            newDirectory = newDirectory.deletingLastPathComponent()
            print(newDirectory)
        }
    }
}

//print("""
//---------------MENU--------------------
//1 - TRASNFERIR ARQUIVOS
//2 - DELETAR ARQUIVOS
//3 - CRIAR PASTA
//4 - EXIT
//---------------------------------------
//
//
//""")
//let option = Int(readLine() ?? "4")
////let fm = Controller.init()
////switch option{
////case 1:
////    try fm.transferFiles()
////case 2:
////    try fm.deleteFiles()
////case 3:
////    try fm.createFolder()
////default:
////    print("""
////    VOLTE SEMPRE.
////
////    """)
////    exit(0)
////
////}


import Foundation

print("Hello, World!")

