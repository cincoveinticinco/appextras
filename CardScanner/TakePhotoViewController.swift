//
//  TakePhotoViewController.swift
//  CardScanner
//
//  Created by Frontend on 6/09/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit
import ImagePicker
import FLAnimatedImage


class TakePhotoViewController: UIViewController, ImagePickerDelegate {
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    
        
       
        dismiss(animated: true){
            GlobalData.sharedInstance.photoCard = imagePicker.stack.assets;
            self.performSegue(withIdentifier: "selectCharacterSegue", sender: self)
          //  self.imageDocument.image = images[0];
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var imageDocument: FLAnimatedImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path1 : String = Bundle.main.path(forResource: "tarjeta1", ofType: "gif")!
        let imageData1 = try? FLAnimatedImage(animatedGIFData: Data(contentsOf: URL(fileURLWithPath: path1)))
        imageDocument.animatedImage = imageData1 as! FLAnimatedImage

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnCancelTakePhoto(_ sender: Any) {
        performSegue(withIdentifier: "unwindToFormData", sender: self)
    }
    @IBAction func onClickTakePhoto(_ sender: Any) {
        /*let imageConctroller = UIImagePickerController();
        imageConctroller.delegate = self;
        present(imageConctroller, animated: true, completion: nil);*/
        let imageController = ImagePickerController();
        imageController.delegate = self
        imageController.imageLimit = 1;
        present(imageController, animated: true, completion: nil);
    }
    
    @IBAction func unwindToPhotoDrive(segue:UIStoryboardSegue) { }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
