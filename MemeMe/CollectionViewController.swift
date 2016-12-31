import UIKit

class CollectionViewController: UICollectionViewController {//manages the collection view of the app
    var didEdit=false//checks if user did try deleting items
    var memeData:[MemeImage]!//accessing all saved memes
    var indices:[IndexPath]!
    override func viewWillAppear(_ animated: Bool) {
        let appdelegate=UIApplication.shared.delegate as! AppDelegate
        memeData=appdelegate.memes//saving stored memes into accessible variable
        navigationController?.navigationBar.barStyle=UIBarStyle.black//changing navigation bar style to black
        navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName:UIFont(name: "AvenirNext-Regular", size: 18)!]//adding title text attributes
        collectionView?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(memeData.isEmpty){
            tabBarController?.selectedIndex=0//return to default view once there are no memes available
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memeData.count//returning the number of memes currently saved
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "memeCell", for: indexPath) as! MemeCell//dequeueing a cell
        cell.memeImageView.image=memeData[indexPath.item].editedImage//setting cell image property to the memed image
        setCellLabelProperties(cell.topLabel, text: memeData[indexPath.item].topText)//setting top text property for the cell
        setCellLabelProperties(cell.bottomLabel, text: memeData[indexPath.item].bottomText)//setting bottom text property for the cell
        return cell//returning the modified cell
    }
    
    func setCellLabelProperties(_ cellLabel: UILabel,text: String){//sets the common cell properties
        cellLabel.text=text//sets the text of the cellLabel
        cellLabel.textAlignment=NSTextAlignment.center//aligns the text in cellLabel
        cellLabel.font=UIFont(name: "Impact", size: 17)//adds a custom font for text in cellLabel
        cellLabel.textColor=UIColor.white//sets the text color in cellLabel
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController=self.storyboard?.instantiateViewController(withIdentifier: "MemeViewer") as! MemeViewController//instantiating the meme view
        viewController.image=memeData[indexPath.item].editedImage//setting image property in meme view
        viewController.index=indexPath.item//passing index value to the meme view
        self.navigationController?.pushViewController(viewController, animated: true)//pushing the navigation controller onto the stack
    }
    
}
