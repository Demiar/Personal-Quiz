//
//  ResultViewController.swift
//  Personal Quiz
//
//  Created by 18992227 on 31.05.2021.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    var answers: [Answer] = []
    
    private var animals: Array<Character> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.setHidesBackButton(true, animated: false)
        for (key, value) in getResultQuiz() {
            iconLabel.text = key
            textLabel.text = value
        }
    }
    
    private func getResultQuiz() -> Dictionary<String, String> {
        getAnimals()
        var iconAnimal: Character = " "
        var count = 0
        for (key, value) in countAnimals() {
            if value > count {
                iconAnimal = key
                count = value
            } else if value == count {
                if Int.random(in: 0...1) == 1 {
                    iconAnimal = key
                    count = value
                }
            }
        }
        let aboutAnimal = AnimalType(rawValue: iconAnimal)?.definition
        if aboutAnimal != nil {
            return ["Вы - \(iconAnimal)!": aboutAnimal!]
        } else {
            return ["Вы - \(iconAnimal)!": ""]
        }
        
    }
    
    private func getAnimals() {
        for answer in answers {
            animals.append(answer.type.rawValue)
        }
    }
    
    private func countAnimals() -> Dictionary<Character, Int> {
        var result = [Character: Int]()
        let frequency = animals.frequency
        for (key, value) in frequency {
            result[key] = value
        }
        print(result)
        return result
    }
}

extension Sequence where Element: Hashable {
    var frequency: [Element: Int] { reduce(into: [:]) { $0[$1, default: 0] += 1 } }
}
