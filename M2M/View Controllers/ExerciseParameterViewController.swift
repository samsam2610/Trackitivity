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

    // MARK: - Outlets and Properties
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
    var keyboardSize: CGRect? = nil

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

        setupTextFields()
        tapToDismissSetup()
        addObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeObservers()
    }

    // MARK: - Methods and Functions
    func loadExercise(_ exercise: ExerciseData) {
        exerciseName_Label.text = exercise.exerciseName
        thighAngle_min.text = "\(exercise.thighAngle_min)"
        thighAngle_max.text = "\(exercise.thighAngle_max)"
        legAngle_min.text = "\(exercise.legAngle_min)"
        legAngle_max.text = "\(exercise.legAngle_max)"
        descriptionLabel.text = exercise.description ?? ""
    }

    func tapToDismissSetup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.addGestureRecognizer(tap)
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }

    func setupTextFields() {
        _ = [exerciseName_Label,
             thighAngle_min,
             thighAngle_max,
             legAngle_min,
             legAngle_max].map { $0!.delegate = self }

        descriptionLabel.delegate = self
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        print("iPhone height: \(self.view.frame.height)")
    }

}

extension ExerciseParameterViewController {
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func done(_ sender: UIButton) {
        // Put this in viewModel
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

extension ExerciseParameterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFieldTag = textField.tag
        
        switch textFieldTag {
        case 0...3:
            let nextField: UITextField = self.view.viewWithTag(textFieldTag + 1) as! UITextField

            nextField.becomeFirstResponder()
            return false
        case 4:
            descriptionLabel.becomeFirstResponder()
            return false
        default:
            break
        }

        return true
    }

}

extension ExerciseParameterViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let keyboardSize = keyboardSize else { return }
        self.view.frame.origin.y -= keyboardSize.height
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        guard let keyboardSize = keyboardSize else { return }
        self.view.frame.origin.y += keyboardSize.height
    }

}
