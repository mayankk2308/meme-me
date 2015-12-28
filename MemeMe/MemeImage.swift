import UIKit

public class MemeImage{//meme class which defines properties for each memed image
    let editedImage:UIImage!//stores the memed image
    let image:UIImage!//stores the original image
    let topText:String!//stores the top text of the meme
    let bottomText:String!//stores the bottom text of the meme
    
    init(editedImage:UIImage!,image:UIImage!,topText:String!,bottomText:String!){//initialize all properties
        self.editedImage=editedImage
        self.image=image
        self.topText=topText
        self.bottomText=bottomText
    }
}