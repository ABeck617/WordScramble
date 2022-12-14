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
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
            
        }
            
            if allWords.isEmpty{
                allWords = ["silkworm"]
            }
        
            startGame()
           
        }
    
     @objc func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    
    // promptForAnswer is being called from the BarButtonItem
    @objc func promptForAnswer(){
        // New UIAlertControler
        let ac = UIAlertController (title: "Enter answer", message: nil, preferredStyle: .alert)
        // add a text box to the UIAlertController
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
      

        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)

                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)

                    return
                } else {
                    showErrorMessage("Word not recongnized", errorTitle: "You can't just make them up, you know")
                }
            } else {
                showErrorMessage("Word already used", errorTitle: "Be more original")
            }
        } else {
            guard let title = title?.lowercased() else { return }
            showErrorMessage("You can't spell that word from \"\(title)\".", errorTitle: "Word not possible")
        }
        
        func showErrorMessage(_ errorMessage: String, errorTitle: String) {
            let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }


    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }

    func isOriginal(word: String) -> Bool {
        guard word != title else { return false }
        
        return !usedWords.contains(word)
    }

    func isReal(word: String) -> Bool {
        guard word.count > 3 else { return false }
        
        let checker = UITextChecker() // Comes from UIKit
        let range = NSRange(location: 0, length: word.utf16.count) // The range you want to scan inside the word
        let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        
        return mispelledRange.location == NSNotFound
    }
    
            
}




}
