import UIKit

class MediaEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var introLabel: UILabel!                  //introductory label asking user to select the image
    @IBOutlet weak var imageView: UIImageView!          //the image view for the selected image
    @IBOutlet weak var topText: UITextField!            //the top text field for specifying the top text of the meme
    @IBOutlet weak var bottomText: UITextField!         //the bottom text field for specifying the bottom text of the meme
    @IBOutlet weak var cameraImage: UIBarButtonItem!    //button to access a photo by clicking one using the camera (not tested on physical device)
    @IBOutlet weak var albumImage: UIBarButtonItem!     //button to access a photo in the photo album
    @IBOutlet weak var action: UIBarButtonItem!         //button to share the created meme
    @IBOutlet weak var tool: UIToolbar!                 //outlet to access toolbar properties
    var haveImage=false                                 //notes whether image has been obtained from the image picker
    var image:UIImage!                                  //stores the created meme
    @IBOutlet var done: UIBarButtonItem!                //button to return to sent memes menu
    override func viewDidLoad() {
        action.isEnabled = false                        //disable share button as image has not yet been selected
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font:UIFont(name: "AvenirNext-Regular", size: 18)!]
        topText.delegate = self         //set toptext textfield delegate to self
        bottomText.delegate = self      //set bottomtext textfield delegate to self
        albumImage.setTitleTextAttributes([NSAttributedStringKey.font:UIFont(name: "AvenirNext-Regular", size: 18)!], for: UIControlState())
        done.setTitleTextAttributes([NSAttributedStringKey.font:UIFont(name: "AvenirNext-Regular", size: 18)!], for: UIControlState())
        setTextAttributes(topText)      //set topText textfield attributes
        setTextAttributes(bottomText)   //set bottomText textfield attributes
        if(!haveImage) {                 //check if image has been obtained from image picker
            introLabel.isHidden = false //show the introductory label
            topText.isHidden = true     //hide top textfield
            bottomText.isHidden = true  //hide bottom textfield
        } else {
            introLabel.isHidden = true  //hide the introductory label
            topText.isHidden = false    //show the top textfield
            bottomText.isHidden = false //show the bottom textfield
        }
        cameraImage.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    @IBAction func shareMemedImage(_ sender: UIBarButtonItem) {
        image=generateMeme()
        let shareMenu = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        shareMenu.completionWithItemsHandler = { string, complete, items, error in
            if complete {
                self.saveMeme()
            }}
        self.present(shareMenu, animated: true, completion: nil)
    }
    
    func generateMeme()->UIImage{//generate the memed image
        navigationController?.isNavigationBarHidden = true
        tool.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame,
            afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        navigationController?.isNavigationBarHidden=false
        tool.isHidden = false
        return memedImage!
    }
    
    func saveMeme(){//save the generated meme and append it to the meme array
        let meme = MemeImage(editedImage: self.image, image: imageView.image, topText: self.topText.text, bottomText: self.bottomText.text)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    @IBAction func selectPhotoFromAlbum(_ sender: UIBarButtonItem) {
        haveImage = true
        selectPhoto(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    @IBAction func clickPhotoFromCamera(_ sender: UIBarButtonItem) {
        haveImage = true
        selectPhoto(UIImagePickerControllerSourceType.camera)
    }
    
    func selectPhoto(_ sourceType: UIImagePickerControllerSourceType) {
        let photoSelector = UIImagePickerController()
        photoSelector.delegate = self
        photoSelector.sourceType = sourceType
        self.present(photoSelector, animated: true, completion: nil)
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image = image
        print(image)
        action.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
    func setTextAttributes(_ field: UITextField!) {
        field.defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue:UIColor.white,NSAttributedStringKey.font.rawValue:UIFont(name: "Impact", size: 42)!, NSAttributedStringKey.strokeColor.rawValue: UIColor.black,NSAttributedStringKey.strokeWidth.rawValue: -5.0]
        field.textAlignment = NSTextAlignment.center
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self,selector: #selector(MediaEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(MediaEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
   
    func unsubscribeToKeyboardNotifications(){//unsubscribe to keyboard notifications
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    @IBAction func dissmissView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification: Notification)->CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        if(textField == bottomText) {
            subscribeToKeyboardNotifications()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.text!.isEmpty) {
            if(textField == topText) {
                textField.text = "TOP"
            }
            if(textField == bottomText) {
                textField.text="BOTTOM"
            }
            setTextAttributes(textField)
            unsubscribeToKeyboardNotifications()
        }
    }
}

