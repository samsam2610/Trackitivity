//
//  practiceViewController.swift
//  thePrototype
//
//  Created by Tran Sam on 9/21/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreData


class practiceViewController: UIViewController, CBPeripheralManagerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    //UI
    
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var smallRing: KDCircularProgress!
    @IBOutlet weak var bigRing: KDCircularProgress!
    
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseWarning: UILabel!
    
    
    
    
    //Data
    var peripheralManager: CBPeripheralManager?
    var peripheral: CBPeripheral!
    var timer: Timer?
    var initialStartDate: NSDate?
    var startDate : NSDate?
    var duration : TimeInterval = 0
    var mean: Double?
    var pointData: [Int]?
    var trueData: [Int]?
    var rep = String(currentCount)
    var finishedWorkout = false
    
    
    
    
    private var consoleAsciiText:NSAttributedString? = NSAttributedString(string: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigRing.angle = 0
        smallRing.angle = 0
        currentCount = 0
        self.exerciseWarning.lineBreakMode = .byWordWrapping // notice the 'b' instead of 'B'
        self.exerciseWarning.numberOfLines = 3
        self.exerciseName.text = selectedExercise
        self.startWorkout()
        //Create and start the peripheral manager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        //-Notification for updating the text view with incoming text
        updateIncomingData()
    }
    
    override func viewDidAppear(_ animated: Bool) {

        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        peripheralManager?.stopAdvertising()
        self.peripheralManager = nil
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    // Buttons' function
    @IBAction func backToMain(_ sender: Any) {
        if (finishedWorkout) {
            performSegue(withIdentifier: "backToMain", sender: (Any).self)

        } else {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please finish the exercise!",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "Fine! Ok then!", style: UIAlertActionStyle.default,handler: nil))
            
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
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to finish the session?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            self.finishedWorkout = true
            endTime = NSCalendar.current as NSCalendar
            self.wrappingUpData()
            rawData.removeAll()
            self.performSegue(withIdentifier: "backToMain", sender: (Any).self)
        })
        
        // Create Cancel button with action handlder
        let nah = UIAlertAction(title: "Nah", style: .cancel, handler: { (action) -> Void in
            workoutActive = true
            self.startWorkout()
        })
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(yes)
        dialogMessage.addAction(nah)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    
    // Data functions
    
    func wrappingUpData () {
        print("Start Time: \(startTime!)")
        print("End Time: \(endTime!)")
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
    
    func analyzeData (clearedStringData: String) {
        let dataCache = self.checkString(String: clearedStringData)
        Second = dataCache.valueY
        thighAngle = dataCache.valueX
        guard dataCache.Time > 0 else {
            return
        }
        guard  thighAngle > thighMinAngle! && thighAngle < thighMaxAngle! && thighAngle != 361 else {
            return
        }
        let diff = Second - First
        if abs(diff) > 3 {
            dAfter = diff
        }
        
        if Second > First {
            currentMax = Second
        } else if Second < First {
            currentMin = Second
        }
        
        if dAfter*dBefore < 0 {
            if dAfter < 0 {
                Max = currentMax
            } else if dAfter > 0 {
                Min = currentMin
            }
        }
        
        if First != Second {
            First  = Second
            dBefore = dAfter
        }
        
        guard abs(Max) > 0 && abs(Min) > 0 else { return }
        let ROM: Double = abs(Max - Min)
        print("cMax \(Max), cMin \(Min), cDiff \(ROM), cVal \(Second), cCount \(currentCount)")
        if ROM > targetROM && ROM < 180 {
            currentCount += 1
            print("YOOO - cMax \(Max), cMin \(Min), cDiff \(ROM), cVal \(Second), cCount \(currentCount)")
            avgROM = (avgROM + ROM)/(currentCount)
            if Max > sessionMax { sessionMax = Max}
            if Min < sessionMin { sessionMin = Min}
            Max = 0
            Min = 0
        }
        
    }
    
    func checkString (String: String) -> (Time: Double, valueX: Double, valueY: Double, valueZ: Double){
        var Time: Double
        var valueX: Double
        var valueY: Double
        var valueZ: Double
        let StringRecorded = String.components(separatedBy: ",").flatMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        guard StringRecorded.count == 4, StringRecorded[1] < 360, StringRecorded[2] < 360, StringRecorded[3] < 360 else {
            Time = 0
            valueX = 361
            valueY = 361
            valueZ = 361
            return (Time, valueX, valueY, valueZ)
        }
        Time = StringRecorded[0]
        valueX = StringRecorded[1]
        valueY = StringRecorded[2]
        valueZ = StringRecorded[3]
        return (Time, valueX, valueY, valueZ)
    }
    
    
    
    
    func startWorkout() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(practiceViewController.updateTime), userInfo: nil, repeats: true)
        
        if initialStartDate == nil {
            initialStartDate = NSDate()
        }
        startDate = NSDate()
        
        toggleButton.backgroundColor = UIColor.init(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        toggleButton.setTitle("PAUSE", for: UIControlState.normal)
    }
    
    func stopWorkout() {
        self.timer?.invalidate()
        let now = Date()
        
        //pause timer
        toggleButton.backgroundColor = UIColor.init(red: 26/255, green: 188/255, blue: 156/255, alpha: 1)
        toggleButton.setTitle("CONTINUE", for: UIControlState.normal)
        duration += now.timeIntervalSince(startDate! as Date)//
    }
    
    @objc func updateTime() {
        
        let now = NSDate()
        
        if (startDate != nil) {
            totalTime = duration + now.timeIntervalSince(startDate! as Date)
            DispatchQueue.main.async {
                self.timeLabel!.text = TimeInterval().toString(input: totalTime)
            }
        }
    }
    
    func updateData() {
        var str: String?
        let rep = String(currentCount)
        self.dataLabel.text = rep
        guard thighAngle != 361 else {
            return
        }
        if thighAngle > thighMaxAngle! {
            str = "Your thigh angle is \(thighAngle). \nPlease sit down"
            self.exerciseWarning.textColor = UIColor.init(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        } else if thighAngle < thighMinAngle! {
            str = "Your thigh angle is \(thighAngle). \nPlease stand up"
            self.exerciseWarning.textColor = UIColor.init(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        } else {
            str = "Keep going! You can do it!"
            self.exerciseWarning.textColor = UIColor.init(red: 26/255, green: 188/255, blue: 156/255, alpha: 1)
        }
        
        self.exerciseWarning.text = str
        
        let elapsedTime = Double(totalTime)
        if currentCount <= targetCount {
            let newAngleValue = 360 * (currentCount / targetCount)
            bigRing.animate(toAngle: newAngleValue, duration: 0.5, completion: nil)
        }
        if  elapsedTime <= targetTime {
            let newAngleValue = 360 * (elapsedTime/targetTime)
            smallRing.animate(toAngle: newAngleValue, duration: 0.5, completion: nil)
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
    
    
    
    func save(rawData: [Float?], mean: Double?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(mean!, forKeyPath: "mean")
        person.setValue(rawData, forKeyPath: "rawData")
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetch() -> [NSManagedObject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
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

