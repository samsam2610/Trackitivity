//
//  PracticeViewController.swift
//  thePrototype
//
//  Created by Tran Sam on 9/21/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreData
import ResearchKit


class PracticeViewController: UIViewController, CBPeripheralManagerDelegate, ORKTaskViewControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    //UI
    
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var dataLabel: UILabel?
    @IBOutlet weak var smallRing: KDCircularProgress?
    @IBOutlet weak var bigRing: KDCircularProgress?
    @IBOutlet weak var ROMLabel: UILabel?
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseWarning: UILabel?
    
    // Export
    fileprivate static let kExportFormats: [ExportFormat] = [.txt, .csv]
    
    //Data
    var peripheralManager: CBPeripheralManager?
    var peripheral: CBPeripheral!
    var timer: Timer?
    var startDate : Date = Date()
    var endDate : Date = Date()
    var duration : TimeInterval = 0
    var mean: Double?
    var pointData: [Int]?
    var trueData: [Int]?
    var rep = String(currentCount)
    var finishedWorkout = false
    var surveyFinish = false
    var bodyJoints = [String:BodyJoint]()
    var managedContext: NSManagedObjectContext!
    var currentDog: Dog?
    internal var packetsSemaphore = DispatchSemaphore(value: 1)
    fileprivate var originTimestamp: CFAbsoluteTime!
    var packetData = UartData.sharedInstance
    
    enum ExportFormat: String {
        case txt = "txt"
        case csv = "csv"
    }
    

    //Exercise:
    let exercise = SelectedExercise.manager.getSelectedExercise()
    
    
    private var consoleAsciiText:NSAttributedString? = NSAttributedString(string: "")

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        bigRing?.angle = 0
        smallRing?.angle = 0
        currentCount = 0
        self.ROMLabel?.text = "\(String(0)) degrees"
        self.dataLabel?.text = "\(String(0)) counts"
        self.exerciseWarning?.lineBreakMode = .byWordWrapping // notice the 'b' instead of 'B'
        self.exerciseWarning?.numberOfLines = 3
        self.exerciseName.text = selectedExercise
        self.startWorkout()
        
        originTimestamp = CFAbsoluteTimeGetCurrent()
        //Create and start the peripheral manager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        //-Notification for updating the text view with incoming text
        updateIncomingData()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedContext = appDelegate.managedContext
        
        
        let dogName = "Fido"
        let dogFetch: NSFetchRequest<Dog> = Dog.fetchRequest()
        dogFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Dog.name), dogName)
        
        do {
            let practiceResults = try managedContext.fetch(dogFetch)
            if practiceResults.count > 0 {
                // Fido found, use Fido
                currentDog = practiceResults.first
            } else {
                // Fido not found, create Fido
                currentDog = Dog(context: managedContext)
                currentDog?.name = dogName
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }

        loadExercise()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (surveyFinish){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        peripheralManager?.stopAdvertising()
        self.peripheralManager = nil
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)

    }

    func loadExercise() {
        if let exercise = exercise {
            exerciseName.text = exercise.exerciseName
        }
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        //Handle results with taskViewController.result
        if let results = taskViewController.result.results as? [ORKStepResult] {
            print("Results: \(results)")
            for stepResult: ORKStepResult in results {
                
                for result in stepResult.results as! [ORKResult] {
                    
                    if let questionResult = result as? ORKQuestionResult {
                        print("\(questionResult.identifier), \(String(describing: questionResult.answer))")
                    }
                    else{
                        print("No printable results.")
                    }
                    
                }
            }
        }
        taskViewController.dismiss(animated: true, completion: nil)
    }

    
    // Data functions
    
    func wrappingUpData () {
        print("Start Time: \(startDate)")
        print("End Time: \(endDate)")
        print("Session Max: \(sessionMax)")
        print("Session Min: \(sessionMin)")
        print("Average ROM: \(avgROM)")
        print("Count: \(currentCount)")
    }
    
    func updateIncomingData () {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){
            notification in
            self.updateData()
            
        }
    }
    
    func analyzeData (clearStringData: String) {
        let uartPacket = UartPacket(string: clearStringData)
        let queue = DispatchQueue(label: "MyArrayQueue", attributes: .concurrent)
        queue.async(flags: .barrier) {
            self.packetData.append(uartPacket)
        }
        print(packetData)
        let numberOfElement = 8
        let data = self.checkString(String: clearStringData, numberOfElement: numberOfElement)
        

        thighAngle = abs(data[6])
        legPosition = abs(data[5])
        guard thighAngle > thighMinAngle!
            && thighAngle < thighMaxAngle!
            && thighAngle != 361 else { return }

        let IMUData = Array(data[0...3])
        let time_interval = Int(data.last!)
                var cycle_count: [Double]
        var ROM: [Double]
        (cycle_count, ROM) = RepCount.manager.run_2(IMUData, time_interval)
        currentCount = cycle_count.max()!
        if ROM.max()! != 0 {
            currentROM = ROM.max()!
        }
        //tempData[2] = thighAngle
        self.updateData()

    }
    
    func checkString (String: String, numberOfElement: Int) -> [Double]{
        let dumbOutput: Array<Double> = Array(repeating: 0, count: numberOfElement)
        let StringRecorded = String.components(separatedBy: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }        
        guard StringRecorded.count == numberOfElement
        else {
            return dumbOutput
        }
        return StringRecorded
    }
    
    func startWorkout() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PracticeViewController.updateTime), userInfo: nil, repeats: true)
        
        startDate = Date()
        
        toggleButton.backgroundColor = UIColor.init(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        toggleButton.setTitle("PAUSE", for: UIControlState.normal)
    }
    

    func stopWorkout() {
        self.timer?.invalidate()
        let now = Date()
        
        
        //pause timer
        toggleButton.backgroundColor = UIColor.init(red: 26/255, green: 188/255, blue: 156/255, alpha: 1)
        toggleButton.setTitle("CONTINUE", for: UIControlState.normal)
        duration += now.timeIntervalSince(startDate)//
        print(packetData)
    }
    
    @objc func updateTime() {
        
        let now = Date()
        
            totalTime = duration + now.timeIntervalSince(startDate)
            DispatchQueue.main.async {
                self.timeLabel!.text = TimeInterval().toString(input: totalTime)
            }
    }
    
    func updateData() {
        var str: String?
        DispatchQueue.main.async {
            self.dataLabel?.text = "\(currentCount) counts"
            self.ROMLabel?.text = "\(currentROM)  \(legPosition)"
            guard thighAngle != 361 else {
                return
            }
            if thighAngle > thighMaxAngle! {
                str = "Your thigh angle is \(thighAngle). \nPlease sit down"
                self.exerciseWarning?.textColor = UIColor.init(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            } else if thighAngle < thighMinAngle! {
                str = "Your thigh angle is \(thighAngle). \nPlease stand up"
                self.exerciseWarning?.textColor = UIColor.init(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            } else {
                str = "Keep going! You can do it!"
                self.exerciseWarning?.textColor = UIColor.init(red: 26/255, green: 188/255, blue: 156/255, alpha: 1)
            }
            self.exerciseWarning?.text = str
            
            let elapsedTime = Double(totalTime)
            if currentCount <= targetCount {
                let newAngleValue = 360 * (currentCount / targetCount)
                self.bigRing?.animate(toAngle: newAngleValue, duration: 0.5, completion: nil)
            }
            if  elapsedTime <= targetTime {
                let newAngleValue = 360 * (elapsedTime/targetTime)
                self.smallRing?.animate(toAngle: newAngleValue, duration: 0.5, completion: nil)
            }
        }
        
    }
    

    
    // Write functions
    func writeValue(data: String){
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        //change the "data" to valueString
        if let blePeripheral = blePeripheral{
            if let txCharacteristic = txCharacteristic {
                blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    func writeCharacteristic(val: Int8){
        var val = val
        let ns = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
        blePeripheral!.writeValue(ns as Data, for: txCharacteristic!, type: CBCharacteristicWriteType.withResponse)
    }
    
    
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            return
        }
        print("Peripheral manager is running")
    }
    
    //Check when someone subscribe to our characteristic, start sending the data
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Device subscribe to characteristic")
    }
    
    //This on/off switch sends a value of 1 and 0 to the Arduino
    //This can be used as a switch or any thing you'd like
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("\(error)")
            return
        }
    }

    
    func saveScore(repetition: Double, avgAngle: Double, exerciseID: String, exerciseName: String, startDate: Date, endDate: Date, currentDog: Dog) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let newRecord = Walk(context: managedContext)
        newRecord.repetition = Int16(repetition)
        newRecord.avgAngle = Float(avgAngle)
        newRecord.exerciseID = exerciseID
        newRecord.startDate = startDate as NSDate
        newRecord.endDate = endDate as NSDate
        
        currentDog.addToWalks(newRecord)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        var saveData = RestApiManager()
        saveData.stringURL = "https://apiserver269.herokuapp.com/activity"
        let parameters = PatientData(toJSon: "d19c786f-633a-44ba-98ab-0d207592c4cc", exerciseID: exerciseID, exerciseName: exerciseName, timeStart: startDate, timeEnd: endDate, repetitions: Int(repetition), averageAngle: Float(avgAngle), minAngle: 80, maxAngle: 90)

        saveData.postPatientActivity(parameters: parameters, completion: { data in
            do {
                _ = try JSONDecoder().decode(Activity.self, from: data!)
            } catch let error {
                print(error.localizedDescription)
            }

//            if let _ = SelectedAssignment.manager.getID() {
//                DispatchQueue.main.async {
//                    // GET Assignment
//                    AssignmentAPIHelper.manager.getOneAssignment(SelectedAssignment.manager.getID()!, completionHandler: { assignment in
//                        let assignmentToUpdate = assignment
//
//                        DispatchQueue.main.async {
//                            // PUT Assignment
//                            let updatedAssignment = Assignment(id: assignmentToUpdate.id, scores: assignmentToUpdate.scores, scoredDate: assignmentToUpdate.scoredDate, therapistComment: assignmentToUpdate.therapistComment, thresholdROM: assignmentToUpdate.thresholdROM, expectedDuration: assignmentToUpdate.expectedDuration, expectedRepetitions: assignmentToUpdate.expectedRepetitions, duration: Int(returnedActivity.duration), creatorID: assignmentToUpdate.creatorID, patientID: assignmentToUpdate.patientID, creator: nil, patient: nil, activities: [returnedActivity], timeCreated: assignmentToUpdate.timeCreated, timeModified: assignmentToUpdate.timeModified, exerciseID: assignmentToUpdate.exerciseID, exercise: assignmentToUpdate.exercise)
//
//                            AssignmentAPIHelper.manager.putAssignment(updatedAssignment, completionHandler: {
//                                print("Assignment updated: \($0)")
//                                SelectedAssignment.manager.cancelAssignment()
//                            }, errorHandler: { print($0) })
//                        }
//                    }, errorHandler: { print($0) })
//                }
//
//            }
        }, errorCompletion: { (error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        })
    }
    
    func fetch() -> [NSManagedObject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Walk")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return people
    }
    
    func basic(rawData: [Float]) -> Double {
        
        var total: Float = 0.0;
        for data in rawData {
            total += data
        }
        
        let countTotal = Float(rawData.count)
        let mean = total/countTotal
        //print(mean)
        return Double(mean)
    }
    
    func cleanData(rawData: [String]) -> [String] {
        var indexStart = 0
        var indexEnd = 0
        var cleanedData: [String] = []
        var Joined: String = ""
        while indexEnd < rawData.count {
            if rawData[indexEnd].lowercased().contains("\n".lowercased()){
                let toBeJoined = rawData[indexStart...indexEnd]
                Joined = toBeJoined.joined(separator: "")
                Joined = Joined.replace(target: "AT+BLEUARTTX=\r\n", withString:"")
                cleanedData.append(Joined)
                indexEnd += 1
                indexStart = indexEnd
            } else {
                indexEnd += 1
            }
        }
        return cleanedData
    }
}

// Buttons' function
extension PracticeViewController {
    
    @IBAction func backToMain(_ sender: Any) {
        if (finishedWorkout) {

            self.dismiss(animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please finish the exercise!",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            
        }
    }
    
    
    @IBAction func startButton(_ sender: UIButton) {
        if (workoutActive) {
            
            self.stopWorkout()
            
        } else {
            
            self.startWorkout()
            
        }
        workoutActive = !workoutActive
        
    }
    
    @IBAction func finishWorkout(_ sender: UIButton) {
        // Declare Alert
        self.stopWorkout()
        workoutActive = false

        //Add 3rd dialog message to go to survey
        let surveyMessage = UIAlertController(title: "Survey", message: "Do you wanna answer a short survey for the exercise?", preferredStyle: .alert)
        
        //Create Yes to survey questions
        let yesIdo = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            let taskViewController = ORKTaskViewController(task: SurveyTask, taskRun: nil)
            taskViewController.delegate = self
            self.present(taskViewController, animated: true, completion: nil)
            print("View Cleared")
            
        })
        
        //Create No to survey questions
        let noIdont = UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        
        //Add buttons to survey dialog message
        surveyMessage.addAction(yesIdo)
        surveyMessage.addAction(noIdont)
        
        //Add 2nd dialog message
        let alertController = UIAlertController(title: "Export data", message: "Do you want to export the data as CSV", preferredStyle: .alert)
        
        let exportAction = UIAlertAction(title: "Export as CSV", style: .default) { [unowned self] (_) in
            var exportObject: AnyObject?
            exportObject = UartDataExport.packetsAsCsv(self.packetData.show()) as AnyObject
            self.export(object: exportObject)

            self.present(surveyMessage, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{ (action) -> Void in
            self.present(surveyMessage, animated: true, completion: nil)
        })
        
        alertController.addAction(exportAction)
        alertController.addAction(cancelAction)

        
        //Add 1st dialog message
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to finish the session?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            self.finishedWorkout = true
            self.endDate = Date()
            self.wrappingUpData()
            rawData.removeAll()
            guard let unwrappedExercise = self.exercise else { return }
            self.saveScore(repetition: currentCount, avgAngle: avgROM, exerciseID: unwrappedExercise.id!, exerciseName: unwrappedExercise.exerciseName, startDate: self.startDate, endDate: self.endDate, currentDog: self.currentDog!)
            self.present(alertController, animated: true, completion: nil)
            //print(self.fetch())
        })
        
        // Create Cancel button with action handlder
        let nah = UIAlertAction(title: "No", style: .cancel, handler: { (action) -> Void in
            workoutActive = true
            self.startWorkout()
        })
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(yes)
        dialogMessage.addAction(nah)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    private func export(object: AnyObject?) {
        if let object = object {
            // TODO: replace randomly generated iOS filenames: https://thomasguenzel.com/blog/2015/04/16/uiactivityviewcontroller-nsdata-with-filename/
            
            let activityViewController = UIActivityViewController(activityItems: [object], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            DLog("exportString with empty text")
        }
    }
}

