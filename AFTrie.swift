//
//  AFTrie.swift
//  Artefact
//
//  Created by 陈玉龙 on 2020/1/10.
//  Copyright © 2020 SceneConsole. All rights reserved.
//

import Foundation

class AFTrie{
    
    var root_t:[AFTrieNode?] = Array.init(repeating: nil, count: 26)
    
    class AFTrieNode {
        var key:Character = "/"
        var nextNodes:[AFTrieNode?] = Array.init(repeating: nil, count: 26)
        var data:Set = Set<IndexPath>()
    }

    func insertNode( root:inout [AFTrieNode?], value:String, indexPath:IndexPath){

        let range = value.index(value.startIndex, offsetBy: 1)
        
        let lvalue = value.lowercased()
        
        guard let prec = lvalue.first else { return }
        let suffix = lvalue.suffix(from: range)
        
        let idx = Int(prec.asciiValue! - Character.init("a").asciiValue!)
        
        if let subNode = root[idx] {
            subNode.data.insert(indexPath)
            if suffix.count >= 1 {
                insertNode(root: &subNode.nextNodes, value: String(suffix), indexPath: indexPath)
            }
        }else{
            let newNode = AFTrieNode.init()
            newNode.key = prec
            newNode.data.insert(indexPath)
            root[idx] = newNode
            if suffix.count >= 1 {
                insertNode(root: &newNode.nextNodes, value: String(suffix), indexPath: indexPath)
            }
        }
    }

    func search(root:[AFTrieNode?], value:String) -> Set<IndexPath>{
        
        let value_t = value.trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
        if value_t.isEmpty {
            return []
        }
        let range = value_t.index(value_t.startIndex, offsetBy: 1)
        guard let prec = value_t.first else { return []}
        
//        let suffix = value.suffix(from: range).trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
        
        guard let asciiValue = prec.asciiValue else {
            return []
        }
        
        if asciiValue < UInt8(97) || asciiValue > UInt8(122) {
            return []
        }
        
        let idx = Int(prec.asciiValue! - Character.init("a").asciiValue!)
        let suffix = value_t.suffix(from: range)
        
        if suffix.count == 0 {
            if let node = root[idx] {
                return node.data
            }
            return []
        }
        
        if let node = root[idx] {
            return search(root: node.nextNodes, value: String(suffix))
        }
        return []
    }
    
}
