import UIKit

class MemeViewController: UIViewController, UINavigationControllerDelegate{//manages the view which shows the meme in its original aspect ratio
    var image:UIImage!//store the memed image
    var index:Int!//store the index of the meme in the array
    @IBOutlet weak var memeView: UIImageView!//access the image view for the view
    override func viewWillAppear(animated: Bool) {
        memeView.image=self.image//assign the image view
    }
    
    @IBAction func backButton(sender: UIBarButtonItem) {
        navigationController?.popToRootViewControllerAnimated(true)//return to root view controller
    }
    @IBAction func deleteMeme(sender: UIBarButtonItem) {//delete meme and return to root view controller
        deleteMeme()
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func deleteMeme(){//removes the meme from the array
        let appdelegate=UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.memes.removeAtIndex(index)
    }
}
