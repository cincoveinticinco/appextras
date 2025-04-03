//
//  ScannerViewController.swift
//  CardScanner
//
//  Created by 525 on 1/12/17.
//  Copyright © 2017 525. All rights reserved.
//

import UIKit
import GoneVisible
import BarcodeScanner
import FLAnimatedImage

class ScannerViewController: UIViewController, DTDeviceDelegate {

    var person = Person()
    var characters = [Characters]()
    
    var device = DTDevices.sharedDevice() as! DTDevices
    var scanActive = false
    @IBOutlet weak var btScan: UIButton!
    @IBOutlet weak var buttonScanCamera: UIButton!
    @IBOutlet weak var btnNewForm: UIButton!
    
    @IBOutlet weak var imageScan: FLAnimatedImageView!
    @IBOutlet weak var imageScanCamera: FLAnimatedImageView!
    
    deinit {
        device.disconnect()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        device.disconnect()
    }
    
    override func viewWillAppear(_ animated: Bool){
        device.connect()
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path1 : String = Bundle.main.path(forResource: "tarjeta2", ofType: "gif")!
        let imageData1 = try? FLAnimatedImage(animatedGIFData: Data(contentsOf: URL(fileURLWithPath: path1)))
        imageScan.animatedImage = imageData1 as? FLAnimatedImage
        
        let path2 : String = Bundle.main.path(forResource: "tarjeta1", ofType: "gif")!
        let imageData2 = try? FLAnimatedImage(animatedGIFData: Data(contentsOf: URL(fileURLWithPath: path2)))
        imageScanCamera.animatedImage = imageData2 as? FLAnimatedImage
        
        
        device.addDelegate(self)
        device.connect()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindToScanDriverLicence(segue:UIStoryboardSegue) { }
    
    @IBAction func OnCancelScan(_ sender: Any) {
        performSegue(withIdentifier: "unwindToSelectArrival", sender: self)
    }
    @IBAction func OnNewFormBtn(_ sender: Any) {
        person = Person(
            id: "",
            name: "",
            middleName: "",
            lastName: "",
            address: "",
            city: "",
            state: "",
            zip: "",
            birthday: "",
            expirationDate: "",
            gender: ""
        )
        GlobalData.sharedInstance.person = self.person;
        performSegue(withIdentifier: "PersonalInfo", sender: self)
    }
    // MARK: - Actions
    @IBAction func scanDown(_ sender: UIButton) {
        do
        {
            var scanMode = SCAN_MODES.MODE_SINGLE_SCAN
            try device.barcodeGetScanMode(&scanMode)
            
            if scanMode==SCAN_MODES.MODE_MOTION_DETECT {
                scanActive = !scanActive
                if scanActive {
                    try device.barcodeStartScan()
                }else {
                    try device.barcodeStopScan()
                }
            }else
            {
                try device.barcodeStartScan()
            }
        }catch let error as NSError {
            //tvInfo.text = "Operation failed with: \(error.localizedDescription)"
            print("Operation failed with: \(error.localizedDescription)")
        }

    }
    
    @IBAction func scanUp(_ sender: UIButton) {
        do
        {
            try device.barcodeStopScan()
        }catch let error as NSError {
            //tvInfo.text = "Operation failed with: \(error.localizedDescription)"
            print("Operation failed with: \(error.localizedDescription)")
        }
    }
    
    @IBAction func scanWithCamera(_ sender: UIButton) {
       
        let viewController = makeBarcodeScannerViewController()
        present(viewController, animated: true, completion: nil)

    }
    
    private func makeBarcodeScannerViewController() -> BarcodeScannerViewController{
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        
        return viewController
    }
    
    
    func connectionState(_ state: Int32) {
        var info="SDK: ver \(device.sdkVersion/100).\(String.init(format: "%02d", device.sdkVersion%100)) \(DateFormatter.localizedString(from: device.sdkBuildDate, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none))\n"
        
        do
        {
            
            if state==CONN_STATES.CONNECTED.rawValue
            {
                let connected = try device.getConnectedDevicesInfo()
                for device in connected
                {
                    info+="\(device.name!) \(device.model!) connected\nFW Rev: \(device.firmwareRevision!) HW Rev: \(device.hardwareRevision!)\nSerial: \(device.serialNumber!)\n"
                }
                
                if device.getSupportedFeature(FEATURES.FEAT_BARCODE, error: nil) != FEAT_UNSUPPORTED
                {
                    btScan.isHidden = false
                    imageScan.isHidden = false
                    buttonScanCamera.isHidden = true
                    imageScanCamera.isHidden = true
                }
                
                //btBattery.isHidden=false
                //updateBattery()
            }else {
                btScan.isHidden=true
                buttonScanCamera.isHidden = false
                imageScan.isHidden = true
                imageScanCamera.isHidden = false
                //Utils.showMessage("CONN_STATES.CONNECTED", message: "Type: \(state)")
                //btBattery.isHidden=true
            }
        }catch {}
        //tvInfo.text = info
        //print("INFO", info)
    }
    
    // MARK: Library Scanner
    
    func barcodeData(_ barcode: String!, type: Int32) {
        print("Barcode scanned \nType: \(type)\nBarcode:\(barcode!)")
        //Utils.showMessage("Barcode scanned", message: "Type: \(type)\nBarcode: \(barcode!)")
        splitString(string: barcode)
    }
    
    func magneticCardEncryptedData(_ encryption: Int32, tracks: Int32, data: Data!, track1masked: String!, track2masked: String!, track3: String!, source: Int32) {
        let card = device.msExtractFinancialCard(track1masked, track2: track2masked)
        var status = "Encryption: "
        
        switch encryption {
        case ALG_EH_AES256:
            status += "AES256"
            
        case ALG_EH_AES128:
            status += "AES128"
            
        case ALG_EH_MAGTEK:
            status += "MAGTEK"
            
        case ALG_EH_IDTECH:
            status += "IDTECH"
            
        case ALG_PPAD_DUKPT:
            status += "Pinpad DUKPT"
            
        case ALG_PPAD_3DES_CBC:
            status += "Pinpad 3DES CBC"
            
        case ALG_TRANSARMOR:
            status += "TransArmor"
            
        case ALG_EH_VOLTAGE:
            status += "Voltage"
            
        default:
            status += ""
        }
        
        status += "\n"
        
        if card != nil
        {
            if !(card?.cardholderName.isEmpty)! {
                status += "Name: \(card!.cardholderName!)\n"
            }
            status += "PAN: \(card!.accountNumber)\n"
            status += "Expires: \(card!.expirationMonth)/\(card!.expirationYear)\n"
            if !(card?.serviceCode.isEmpty)! {
                status += "Service Code: \(card!.serviceCode!)\n"
            }
            if !(card?.discretionaryData.isEmpty)! {
                status += "Discretionary: \(card!.discretionaryData!)\n"
            }
        }
        
        status += "Data: " + data.toHexString()
        
        do {
            let sound: [Int32] = [2730,150,0,30,2730,150];
            try device.playSound(100, beepData: sound, length: Int32(sound.count*4))
        } catch {
        }
        
        //Utils.showMessage("Card Data", message: status)
        //tvInfo.text = "\nCard Data:  \(status)"
    }
    
    //plain magnetic card data
    func magneticCardData(_ track1: String!, track2: String!, track3: String!) {
        let card = device.msExtractFinancialCard(track1, track2: track2)
        var status = ""
        if card != nil {
            if card!.cardholderName != nil && !(card!.cardholderName.isEmpty) {
                status += "Name: \(card!.cardholderName!)\n"
            }
            status += "PAN: \((card!.accountNumber)!.masked(4, end: 4))\n"
            status += "Expires: \(card!.expirationMonth)/\(card!.expirationYear)\n"
            if card!.serviceCode != nil && !(card!.serviceCode.isEmpty) {
                status += "Service Code: \(card!.serviceCode!)\n"
            }
            if card!.discretionaryData != nil && !(card!.discretionaryData.isEmpty) {
                status += "Discretionary: \(card!.discretionaryData!)\n"
            }
        }
        
        if track1 != nil && !track1.isEmpty {
            status += "Track1: \(track1!)\n"
        }
        if track2 != nil && !track2.isEmpty {
            status += "Track2: \(track2!)\n"
        }
        if track3 != nil && !track3.isEmpty {
            status += "Track3: \(track3!)\n"
        }
        
        do {
            let sound: [Int32] = [2730,150,0,30,2730,150];
            try device.playSound(100, beepData: sound, length: Int32(sound.count*4))
        } catch {
        }
        
        
        print("TRACK 1")
        print(track1)
        
        print("TRACK 2")
        print(track2)
        
        print("TRACK 3")
        print(track3)
        
        splitTrackString(track1: track1, track2: track2,track3: track3)
    
    }
    
    // MARK: - Other Functions
    
    func splitTrackString(track1: String?, track2: String?,track3: String?) {
        
        let parse = ParseLicence();
        
        do{
            //let _track1 = "%FLMIAMI^ESPINOZA BERTI$HELI$^600 NW 6TH ST APT6?";
            //let _track2 = ";6360100521532068283=2408196899030=?";
            //let _track3 = "%! 33136      E               1508         ECCECC00000?";
            
            var parseData = try parse.parse_magnetic(track1: track1, track2: track2,track3: track3);
            let firstName = parseData["firstName"];
            let middleName = parseData["middleName"];
            let lastName = parseData["lastName"];
            let address = parseData["addressStreet"];
            let city = parseData["addressCity"];
            let state = parseData["addressState"];
            var zip = parseData["addressPostalCode"]?.components(separatedBy: "-")[0]
            
            
            zip = zip?.substringToIndex(5);
            let expirationDate = parseData["dateOfExpiry"]
            let dateOfBirth = parseData["dateOfBirth"]
            let genre = parseData["sex"]
            
            person = Person(
                id: "",
                name: String(firstName ?? ""),
                middleName: String(middleName  ?? ""),
                lastName: String(lastName  ?? ""),
                address: address!,
                city: city!,
                state: state!,
                zip: zip!,
                birthday: dateOfBirth!,
                expirationDate: expirationDate!,
                gender: genre!
            )
            
            GlobalData.sharedInstance.person = self.person;
            performSegue(withIdentifier: "PersonalInfo", sender: self)
        }catch {
            let alert : UIAlertController  =
                UIAlertController(
                    title: "Error",
                    message: "Invalid Driver's Licence",
                    preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Continue", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func splitString(string: String) {
        
        let parse = ParseLicence();
        
        do{
            var parseData = try parse.parse(str: string);
            let firstName = parseData["firstName"];
            let middleName = parseData["middleName"];
            let lastName = parseData["lastName"];
            let address = parseData["addressStreet"];
            let city = parseData["addressCity"];
            let state = parseData["addressState"];
            var zip = parseData["addressPostalCode"]?.components(separatedBy: "-")[0]
            
            
            zip = zip?.substringToIndex(5);
            let expirationDate = parseData["dateOfExpiry"]
            let dateOfBirth = parseData["dateOfBirth"]
            let genre = parseData["sex"]
            
            person = Person(
                id: "",
                name: String(firstName ?? ""),
                middleName: String(middleName  ?? ""),
                lastName: String(lastName  ?? ""),
                address: address!,
                city: city!,
                state: state!,
                zip: zip!,
                birthday: dateOfBirth!,
                expirationDate: expirationDate!,
                gender: genre!
            )
            
            GlobalData.sharedInstance.person = self.person;
            performSegue(withIdentifier: "PersonalInfo", sender: self)
        }catch {
            let alert : UIAlertController  =
                UIAlertController(
                    title: "Error",
                    message: "Invalid Driver's Licence",
                    preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Continue", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        
       
    }
    
    func readOldLicence(){
        //let userNameData = arrayData[1]
        //print("arr code:", userNameData)
        //Utils.showMessage("String", message: userNameData)
        //let userNameTemp = userNameData.components(separatedBy: "DAA")
        //print(userNameTemp)
        /* let names = userNameTemp[1].components(separatedBy: ",")
         let firstName = names[1]
         let middleName = names [2]
         let lastName = names[0]
         
         let addressTemp = arrayData[2].components(separatedBy: "DAG")
         let address = addressTemp[1]
         
         let cityTemp = arrayData[3].components(separatedBy: "DAI")
         let city = cityTemp[1]
         let stateTemp = arrayData[4].components(separatedBy: "DAJ")
         let state = stateTemp[1]
         let zipTemp = arrayData[5].components(separatedBy: "DAK")
         let zip = zipTemp[1].components(separatedBy: "-")[0]
         let IDtemp = arrayData[6].components(separatedBy: "DAQ")
         let ID = IDtemp[1]
         let driverClassTemp = arrayData[7].components(separatedBy: "DAR")
         _ = driverClassTemp[1]
         let restTemp = arrayData[8].components(separatedBy: "DAS")
         _ = restTemp[1]
         let endorseTemp = arrayData[9].components(separatedBy: "DAT")
         _ = endorseTemp[1]
         let expirationDateTemp = arrayData[10].components(separatedBy: "DBA")
         let expirationDate = expirationDateTemp[1]
         let dateOfBirthTemp = arrayData[11].components(separatedBy: "DBB")
         let dateOfBirth = dateOfBirthTemp[1]
         let genreTemp = arrayData[12].components(separatedBy: "DBC")
         var genre = genreTemp[1]
         if genre == "1" {
         genre = "M"
         } else {
         genre = "F"
         }
         let issuedDateTemp = arrayData[13].components(separatedBy: "DBD")
         _ = issuedDateTemp[1]
         _ = arrayData[14].components(separatedBy: "DBH")
         let replacedDateTemp = arrayData[15].components(separatedBy: " ")
         _ = replacedDateTemp[1]
         
         person = Person(
         id: ID,
         name: firstName,
         middleName: middleName,
         lastName: lastName,
         address: address,
         city: city,
         state: state,
         zip: zip,
         birthday: dateOfBirth,
         expirationDate: expirationDate,
         gender: genre
         )
         
         let characters = GlobalData.sharedInstance.myDailyPlan?.characters;
         
         for character in characters!{
         let talent  = character.talent;
         
         for t in talent!{
         print("--------------..--------")
         print(t.name!, t.last_name!, t.date_of_birth!)
         print(person.name!, person.lastName!, person.birthday)
         print("--------------..--------")
         if t.name! == person.name && t.last_name! == person.lastName && t.date_of_birth == person.birthday{
         GlobalData.sharedInstance.characterHasId = (t.characterHasTalentId)!
         person.isStored = true;
         GlobalData.sharedInstance.person = person;
         
         performSegue(withIdentifier: "segueSelectRolId", sender: self)
         print(GlobalData.sharedInstance.characterHasId);
         }
         }
         }
         
         GlobalData.sharedInstance.person = self.person;
         performSegue(withIdentifier: "PersonalInfo", sender: self)*/
    }

}



// MARK: - Barcode Delegate

extension ScannerViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
            //controller.isOneTimeSearch = false
            if type == "org.iso.PDF417"{
                controller.dismiss(animated: true, completion: { //
                    self.splitString(string: code)
                })
            }else{
                Utils.showMessage("Error", message: "Invalid code, please point directly to the bar code of the driver's license")
                controller.resetWithError(message: "Invalid code, please point directly to the bar code of the driver's license")
                
                //controller.reset();
                
            }
        
          /*  controller.dismiss(animated: true, completion: { //
                if type == "org.iso.PDF417"{
                    self.splitString(string: code)
                }else{
                     Utils.showMessage("Error", message: "Invalid code, please point directly to the bar code of the driver's license")
                    controller.reset();
                }
                
            })*/
        
        
    }
}
extension ScannerViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
}
extension ScannerViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        print("Me fui")
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Segue

/*extension ScannerViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Personal Info" {
            let personalInfoVC = segue.destination as! PersonalInfoViewController
            personalInfoVC.person = self.person
            
        }
    }
}*/
