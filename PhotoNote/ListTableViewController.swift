//
//  ListTableViewController.swift
//  PhotoNote
//
//  Created by Bobby on 16/04/2015.
//  Copyright (c) 2015 Azuki Apps. All rights reserved.
//

import UIKit

class ListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var photonotes = PhotoNoteCollection.sharedInstance
    var tableView: UITableView!
    var imagePicker = UIImagePickerController()
    var imageView: UIImageView!
    var newTitleField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let newButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPhotoNoteButton:")
        self.navigationItem.rightBarButtonItem = newButton
        
        tableView = UITableView(frame: self.view.frame, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.rowHeight = 44;
        
        self.view.addSubview(tableView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.photonotes.list.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = self.photonotes.list[indexPath.row].title
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let targetVC = PhotoViewController()
        targetVC.photonote = self.photonotes.list[indexPath.row]
        self.navigationController?.pushViewController(targetVC, animated: true)

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func addPhotoNoteButton(sender:UIButton!) {
        
        var alert = UIAlertController(title: "New Photo", message: "Where would you like to get a picture from?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in

                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                    self.imagePicker.allowsEditing = false
                    self.presentViewController(self.imagePicker, animated: true, completion: nil)
                } else {
                    println("No camera available")
                }

            })
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in

                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
                    self.imagePicker.allowsEditing = false
                    self.presentViewController(self.imagePicker, animated: true, completion: nil)
                }

            })

        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {

            self.dismissViewControllerAnimated(true, completion: { () -> Void in

                let alertController = UIAlertController(title: "Title", message: "Enter a title for your new PhotoNote:", preferredStyle: .Alert)
                
                alertController.addTextFieldWithConfigurationHandler { (textField) in
                    textField.placeholder = "Title"
                    self.newTitleField = textField
                }
                
                let saveTitleAction = UIAlertAction(title: "Save", style: .Default) { (_) in
                    if let newImage = image {
                        var tempPhotoNote = PhotoNote(title: self.newTitleField.text, photo: newImage)
                        self.photonotes.list.append(tempPhotoNote)
                        self.photonotes.saveCollection()
                        self.tableView.reloadData()
                    }
                }
                
                alertController.addAction(saveTitleAction)
                self.presentViewController(alertController, animated: false, completion: nil)

            })
    }

}
