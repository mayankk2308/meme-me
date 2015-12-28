import UIKit

class MediaEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {//manages the media editor of the app

    @IBOutlet var introLabel: UILabel!//introductory label asking user to select the image
    @IBOutlet weak var imageView: UIImageView!//the image view for the selected image
    @IBOutlet weak var topText: UITextField!//the top text field for specifying the top text of the meme
    @IBOutlet weak var bottomText: UITextField!//the bottom text field for specifying the bottom text of the meme
    @IBOutlet weak var cameraImage: UIBarButtonItem!//button to access a photo by clicking one using the camera (not tested on physical device)
    @IBOutlet weak var albumImage: UIBarButtonItem!//button to access a photo in the photo album
    @IBOutlet weak var action: UIBarButtonItem!//button to share the created meme
    @IBOutlet weak var tool: UIToolbar!//outlet to access toolbar properties
    var haveImage=false//notes whether image has been obtained from the image picker
    var image:UIImage!//stores the created meme
    @IBOutlet var done: UIBarButtonItem!//button to return to sent memes menu
    override func viewDidLoad() {
        action.enabled=false//disable share button as image has not yet been selected
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.barStyle=UIBarStyle.Black//set navigation bar style to black
        navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName:UIFont(name: "AvenirNext-Regular", size: 18)!]//set navigation bar text attributes
        topText.delegate=self//set toptext textfield delegate to self
        bottomText.delegate=self//set bottomtext textfield delegate to self
        albumImage.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "AvenirNext-Regular", size: 18)!], forState: UIControlState.Normal)//set "Album" button attributes
        done.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "AvenirNext-Regular", size: 18)!], forState: UIControlState.Normal)//set "Done" button attributes
        setTextAttributes(topText)//set topText textfield attributes
        setTextAttributes(bottomText)//set bottomText textfield attributes
        if(!haveImage){//check if image has been obtained from image picker
            introLabel.hidden=false//show the introductory label
            topText.hidden=true//hide top textfield
            bottomText.hidden=true//hide bottom textfield
        }
        else{
            introLabel.hidden=true//hide the introductory label
            topText.hidden=false//show the top textfield
            bottomText.hidden=false//show the bottom textfield
        }
        cameraImage.enabled=UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)//enable camera button for devices with a camera (not tested on a physical device)
    }
    
    @IBAction func shareMemedImage(sender: UIBarButtonItem) {
        image=generateMeme()//store the generated meme
        let shareMenu=UIActivityViewController(activityItems: [image], applicationActivities: nil)//instantiate the share sheet
        shareMenu.completionWithItemsHandler = { string, complete, items, error in
            if complete {
                self.saveMeme()
            }}
        self.presentViewController(shareMenu, animated: true, completion: nil)
//        shareMenu.completionWithItemsHandler = {(s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) in if ok{self.saveMeme()}}//set the share sheet completion handler
//        self.presentViewController(shareMenu, animated: true, completion: nil)//present the share sheet modally
    }
    
    func generateMeme()->UIImage{//generate the memed image
        navigationController?.navigationBarHidden=true
        tool.hidden=true
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        navigationController?.navigationBarHidden=false
        tool.hidden=false
        return memedImage
    }
    
    func saveMeme(){//save the generated meme and append it to the meme array
        let meme=MemeImage(editedImage: self.image, image: imageView.image, topText: self.topText.text, bottomText: self.bottomText.text)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    @IBAction func selectPhotoFromAlbum(sender: UIBarButtonItem) {//access photo from the photo library
        haveImage=true
        selectPhoto(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func clickPhotoFromCamera(sender: UIBarButtonItem) {//take a new photo from the camera and memefy it
        haveImage=true
        selectPhoto(UIImagePickerControllerSourceType.Camera)
    }
    
    func selectPhoto(sourceType: UIImagePickerControllerSourceType){//instantiate image picker with code: sourceType as source type
        let photoSelector=UIImagePickerController()
        photoSelector.delegate=self
        photoSelector.sourceType=sourceType
        self.presentViewController(photoSelector, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image=image
        action.enabled=true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setTextAttributes(field: UITextField!){//set the common textfield attributes
        field.defaultTextAttributes=[NSForegroundColorAttributeName:UIColor.whiteColor(),NSFontAttributeName:UIFont(name: "Impact", size: 42)!,NSStrokeColorAttributeName: UIColor.blackColor(),NSStrokeWidthAttributeName: -5.0]
        field.textAlignment=NSTextAlignment.Center//aligns text to center
    }
    
    func subscribeToKeyboardNotifications(){//subscribe to keyboard notifications
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "keyboardWillShow:",name: UIKeyboardWillShowNotification,object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "keyboardWillHide:",name: UIKeyboardWillHideNotification,object:nil)
    }
   
    func unsubscribeToKeyboardNotifications(){//unsubscribe to keyboard notifications
        NSNotificationCenter.defaultCenter().removeObserver(self,name: UIKeyboardWillShowNotification,object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,name: UIKeyboardWillHideNotification,object:nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    @IBAction func dissmissView(sender: UIBarButtonItem) {//dismisses media editor
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){//adjust view when the keyboard shows
        view.frame.origin.y-=getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification)->CGFloat{//obtain the keyboard height
        let userInfo=notification.userInfo
        let keyboardSize=userInfo![UIKeyboardFrameBeginUserInfoKey]as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillHide(notification: NSNotification){//adjust view when the keyboard hides
        view.frame.origin.y+=getKeyboardHeight(notification)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.autocapitalizationType=UITextAutocapitalizationType.AllCharacters
        if(textField==bottomText){
            subscribeToKeyboardNotifications()
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField.text!.isEmpty){//if text field is empty, return text to default template
            if(textField==topText){
                textField.text="TOP"
            }
            if(textField==bottomText){
                textField.text="BOTTOM"
            }
            setTextAttributes(textField)//reset textfield attributes
            unsubscribeToKeyboardNotifications()//unsubscribe to any keyboard notifications
        }
    }
}

