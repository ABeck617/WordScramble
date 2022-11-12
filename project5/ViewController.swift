//
//  ViewController.swift
//  project5
//
//  Created by Anthony Beckford on 11/12/22.
//

import UIKit

class ViewController: UITableViewController {
    // creating properties
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
            
            if allWords.isEmpty{
                allWords = ["silkworm"]
            }
           
        }
    
    func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
            
    }




