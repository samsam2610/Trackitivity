//
//  ExerciseParameterViewController.swift
//  
//
//  Created by Tran Sam on 2/24/18.
//

import UIKit
import RxCocoa
import RxSwift

class ExerciseParameterViewController: UIViewController {
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var back: UIButton!
    
    @IBOutlet weak var exerciseName_Label: UITextField!
    @IBOutlet weak var thighAngle_min: UITextField!
    @IBOutlet weak var thighAngle_max: UITextField!
    @IBOutlet weak var legAngle_min: UITextField!
    @IBOutlet weak var legAngle_max: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var isValid: UILabel!

    var passedExercise: ExerciseData?

    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = ExerciseParameterViewModel(
            exerciseName_Label.rx.text.orEmpty.asDriver(),
            thighAngle_max.rx.text.orEmpty.asDriver(),
            thighAngle_min.rx.text.orEmpty.asDriver(),
            legAngle_max.rx.text.orEmpty.asDriver(),
            legAngle_min.rx.text.orEmpty.asDriver()
        )

        viewModel.dataValid
            .drive(onNext: { [weak self] valid in
                self?.isValid.text = valid ? "Valid" : "Parameters are invalid"
                self?.isValid.textColor = valid ? UIColor.green : UIColor.red
                self?.done.isEnabled = valid
                self?.done.alpha = valid ? 1 : 0.5
            })
            .disposed(by: disposeBag)

        if let exercise = passedExercise {
            loadExercise(exercise)
        }
    }

    func loadExercise(_ exercise: ExerciseData) {
        exerciseName_Label.text = exercise.exerciseName
        thighAngle_min.text = "\(exercise.thighAngle_min)"
        thighAngle_max.text = "\(exercise.thighAngle_max)"
        legAngle_min.text = "\(exercise.legAngle_min)"
        legAngle_max.text = "\(exercise.legAngle_max)"
        descriptionLabel.text = exercise.description ?? ""
    }
}

extension ExerciseParameterViewController {
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func done(_ sender: UIButton) {

        let exercise = ExerciseData(toJson: exerciseName_Label.text!, descriptionLabel.text!, Int16(thighAngle_min.text!) ?? 0, Int16(thighAngle_max.text!) ?? 0, Int16(legAngle_min.text!) ?? 0, Int16(legAngle_max.text!) ?? 0)

        var id: String?

        if let passedExercise = passedExercise {
            id = passedExercise.id!
        }

        ExerciseAPIHelper.manager.postExercise(exercise, id: id, completionHandler: { (data) in
            dump(data)
            self.dismiss(animated: true, completion: nil)
        }, errorHandler: { (error) in
            print(error.localizedDescription)
        })
    }
}
