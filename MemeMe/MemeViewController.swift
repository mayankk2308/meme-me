import UIKit

class MemeViewController: UIViewController, UINavigationControllerDelegate{//manages the view which shows the meme in its original aspect ratio
    var image:UIImage!//store the memed image
    var index:Int!//store the index of the meme in the array
    @IBOutlet weak var memeView: UIImageView!//access the image view for the view
    override func viewWillAppear(_ animated: Bool) {
        memeView.image=self.image//assign the image view
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        _ = navigationController?.popToRootViewController(animated: true)//return to root view controller
    }
    @IBAction func deleteMeme(_ sender: UIBarButtonItem) {//delete meme and return to root view controller
        deleteMeme()
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func deleteMeme(){//removes the meme from the array
        let appdelegate=UIApplication.shared.delegate as! AppDelegate
        appdelegate.memes.remove(at: index)
    }
}
