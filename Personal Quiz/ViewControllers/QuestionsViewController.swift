//
//  QuestionsViewController.swift
//  Personal Quiz
//
//  Created by 18992227 on 31.05.2021.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet weak var multipleStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet weak var rangedStackView: UIStackView!
    @IBOutlet weak var rangedSlider: UISlider!
    @IBOutlet var rangedLabels: [UILabel]!
    
    var questions: [Question] = []
    private var questionIndex = 0 // индекс активного вопроса
    
    private var answersChosen: [Answer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
}

extension QuestionsViewController {
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        let currentAnswers = questions[questionIndex].answers
        
        guard let currentIndex = singleButtons.firstIndex(of: sender) else {
            return
        }
        let currentAnswer = currentAnswers[currentIndex]
        answersChosen.append(currentAnswer)
        
        nextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed() {
        let currentAnswers = questions[questionIndex].answers
        
        for (switcher, answer) in zip(multipleSwitches, currentAnswers) {
            if switcher.isOn {
                answersChosen.append(answer)
            }
        }
        
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let currentAnswers = questions[questionIndex].answers
        
        let index = Int(round(rangedSlider.value * Float(currentAnswers.count - 1)))
        answersChosen.append(currentAnswers[index])
        
        nextQuestion()
    }
}

extension QuestionsViewController {
    private func updateUI() {
        // скрыть все стеки
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            stackView?.isHidden = true
        }
        
        // получить текущий вопрос
        let currentQuestion = questions[questionIndex]
        questionLabel.text = currentQuestion.text
        
        // подсчёт прогресса
        let totalProgress = Float(questionIndex) / Float(questions.count)
        progressView.setProgress(totalProgress, animated: true)
        
        // navigation title
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        let answers = currentQuestion.answers
        
        switch currentQuestion.type {
        case .single:
            updateSingleStackView(answers: answers)
        case .multiple:
            updateMultipleStackView(answers: answers)
        case .ranged:
            updateRangedStackView(answers: answers)
        }
    }
    
    private func updateSingleStackView(answers: [Answer]) {
        singleStackView.isHidden = false
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.text, for: .normal)
        }
    }
    
    private func updateMultipleStackView(answers: [Answer]) {
        multipleStackView.isHidden = false
        
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.text
        }
    }
    
    private func updateRangedStackView(answers: [Answer]) {
        rangedStackView.isHidden = false
        
        rangedLabels.first?.text = answers.first?.text
        rangedLabels.last?.text = answers.last?.text
    }
    
    private func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "resultSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "resultSegue",
              let vc = segue.destination as? ResultViewController else {
            return
        }
        
        vc.answers = answersChosen
    }
}
