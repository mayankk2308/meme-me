import UIKit

class TableViewController: UITableViewController {//manages the table view of the app
    @IBOutlet var tempView: UIView!//temporary view when table is empty
    @IBOutlet var noMemes: UILabel!//the no memes label
    @IBOutlet var addSome: UILabel!//the instruction label
    var memeData:[MemeImage]!//access stored memes
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memeData.count//returns total number of saved memes
    }
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.barStyle=UIBarStyle.Black//set navigation bar style to black
        navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName:UIFont(name: "AvenirNext-Regular", size: 18)!]//set navigation bar text attributes
        tabBarController?.tabBar.barStyle=UIBarStyle.Black//set tab bar style to black
        tabBarController?.tabBar.tintColor=UIColor.orangeColor()//set selected tab item color
        noMemes.textColor=UIColor.whiteColor()//set code: noMemes label text color
        addSome.textColor=UIColor.whiteColor()//set code: addSome label text color
        tempView.backgroundColor=UIColor.blackColor()//set temporary view background color
        self.tableView.backgroundColor=UIColor.blackColor()//set table view background color
        self.tableView.separatorColor=UIColor.whiteColor()//set table view seperator color
        let object=UIApplication.sharedApplication().delegate
        let appdelegate=object as! AppDelegate
        memeData=appdelegate.memes//access stored memes
        tableView.rowHeight=100//set table row height
        noMemesAvailable()//check if memes have been previously saved
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCellWithIdentifier("memeCell") as UITableViewCell!//dequeue a cell
        cell.textLabel?.textColor=UIColor.whiteColor()//set cell text color
        cell.textLabel?.font=UIFont(name: "AvenirNext-Regular", size: 18)!//set cell text font
        cell.backgroundColor=UIColor.blackColor()//set cell background color
        let tempView=UIView(frame: cell.frame)//create a view with dimensions of the cell
        tempView.backgroundColor=UIColor.orangeColor()//set view background color
        cell.selectedBackgroundView=tempView//choose selected background view for the cell
        cell.textLabel?.text=memeData[indexPath.row].topText+" "+memeData[indexPath.row].bottomText//set the cell text
        cell.imageView?.contentMode=UIViewContentMode.ScaleAspectFill//set the cell image view content mode
        cell.imageView?.image=memeData[indexPath.row].editedImage//set the cell image
        return cell//return the cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController=self.storyboard?.instantiateViewControllerWithIdentifier("MemeViewer") as! MemeViewController
        viewController.image=memeData[indexPath.row].editedImage//pass memed image to destination
        viewController.index=indexPath.row//pass index value to destination
        self.navigationController?.pushViewController(viewController, animated: true)//push to new view controller to see the meme
        tableView.cellForRowAtIndexPath(indexPath)?.selected=false//deselect the cell
        tableView.reloadData()//reload the table view data
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {//deletion method for cells
        if(editingStyle==UITableViewCellEditingStyle.Delete){
            memeData.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        noMemesAvailable()//check if memes are available
    }
    
    func noMemesAvailable(){//checks if memes are available and shows or hides the introductory label and tab bar on this basis
        if(!memeData.isEmpty){
            self.tableView.tableFooterView=UIView()
            self.tableView.scrollEnabled=true
            self.tabBarController?.tabBar.hidden=false
        }
        else{
            self.tabBarController?.tabBar.hidden=true
            self.tableView.scrollEnabled=false
            self.tableView.tableFooterView=tempView
        }
    }
    
}
