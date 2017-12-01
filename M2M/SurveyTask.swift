//
//  SurveyTask.swift
//  thePrototype
//
//  Created by Tran Sam on 10/21/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import ResearchKit

public var SurveyTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "The Questions Three"
    instructionStep.text = "Who would cross the Bridge of Death must answer me these questions three, ere the other side they see."
    steps += [instructionStep]
    
    let testQuestionStepTitle = "What is your test?"
    let testChoices = [
        ORKTextChoice(text: "1000 pushup", value: 0 as NSNumber),
        ORKTextChoice(text: "1000 situp", value: 1 as NSNumber),
        ORKTextChoice(text: "10k run", value: 2 as NSNumber)
    ]
    let testAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: testChoices)
    let testQuestionStep = ORKQuestionStep(identifier: "TestChoiceQuestionStep", title: testQuestionStepTitle, answer: testAnswerFormat)
    steps += [testQuestionStep]
    
    let questQuestionStepTitle = "What is your quest?"
    let textChoices = [
        ORKTextChoice(text: "Create a ResearchKit App", value: 0 as NSNumber),
        ORKTextChoice(text: "Seek the Holy Grail", value: 1 as NSNumber),
        ORKTextChoice(text: "Find a shrubbery", value: 2 as NSNumber)
    ]
    let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let questQuestionStep = ORKQuestionStep(identifier: "TextChoiceQuestionStep", title: questQuestionStepTitle, answer: questAnswerFormat)
    steps += [questQuestionStep]
    
    let question = NSLocalizedString("How was your pain today?", comment: "")
    let maximumValueDescription = NSLocalizedString("Very much", comment: "")
    let minimumValueDescription = NSLocalizedString("Not at all", comment: "")
    
    // Create a question and answer format.
    let answerFormat = ORKScaleAnswerFormat(
        maximumValue: 10,
        minimumValue: 1,
        defaultValue: 0,
        step: 1,
        vertical: false,
        maximumValueDescription: maximumValueDescription,
        minimumValueDescription: minimumValueDescription
    )
    
    let questionStep = ORKQuestionStep(identifier: "ScaleQuestionStep", title: question, answer: answerFormat)
    questionStep.isOptional = false
    steps += [questionStep]

    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Right. Off you go!"
    summaryStep.text = "That was easy!"
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}



