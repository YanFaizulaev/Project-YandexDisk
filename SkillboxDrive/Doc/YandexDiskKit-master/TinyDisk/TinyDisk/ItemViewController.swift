//
//  ItemViewController.swift
//
//  Copyright (c) 2014-2015, Clemens Auer
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import UIKit
import YandexDiskKit

public class ItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var disk: YandexDisk!
    var item: YandexDiskResource!
    @IBOutlet var preview: UIImageView!
    @IBOutlet var tableview: UITableView!

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init?(disk: YandexDisk, resource: YandexDiskResource) {
        self.init(nibName: "ItemViewController", bundle: NSBundle(forClass: ItemViewController.self))
        self.disk = disk
        self.item = resource

        title = item.name
    }

    private var bundle : NSBundle {
        return NSBundle(forClass: DirectoryViewController.self)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        if item.public_url != nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("action:"))
        }

        var image : UIImage!

        if item.type == .Directory {
            image = UIImage(named: "Folder_icon", inBundle:self.bundle, compatibleWithTraitCollection:nil)
        } else {
            image = UIImage(named: "File_icon", inBundle:self.bundle, compatibleWithTraitCollection:nil)
        }

        dispatch_async(dispatch_get_main_queue()) {
            if let iv = self.preview {
                iv.image = image
                iv.setNeedsDisplay()
            }
        }

        if let preview = item.preview {
            disk.session.dataTaskWithURL(NSURL(string: preview)!) {
                (data, response, error) -> Void in

                let res = response as? NSHTTPURLResponse
                let image = UIImage(data: data)

                dispatch_async(dispatch_get_main_queue()) {
                    if let iv = self.preview {
                        iv.image = image
                        iv.setNeedsDisplay()
                    }
                }
            }.resume()
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func action(sender:AnyObject?) {
        let activityItems = [ item.public_url! ]

        let activityView = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityView.modalPresentationStyle = .Popover

        if let  popoverController = activityView.popoverPresentationController {
            if let view = sender?.valueForKey("view") as? UIView {
                popoverController.sourceView = view
                popoverController.sourceRect = view.bounds
            }
            popoverController.permittedArrowDirections = .Any
        }

        presentViewController(activityView, animated: true) { }
    }

    // #pragma mark - Table view data source

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cellIdentifier = "TinyDiskItemCell"

        var cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell

        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }

        var name : String?
        var value : String?

        switch indexPath.row {
        case 0:
            name = "Name";
            value = item.name;
        case 1:
            name = "Type";
            value = item.type == .Directory ? "directory" : item.mime_type
        case 2:
            name = "Size";
            value = item.size != nil ? "\(item.size!) bytes" : "-"
        case 3:
            name = "M-Time"
            value = "\(item.modified)"
        case 4:
            name = "C-Time"
            value = "\(item.created)"
        case 5:
            name = "MD5"
            value = item.md5 ?? "-"
        case 6:
            name = "Public URL"
            value = item.public_url ?? "-"
        case 7:
            name = "Public key"
            value = item.public_key ?? "-"
        case 8:
            name = "Origin path"
            value = item.origin_path ?? "-"
        case 9:
            name = "MIME Type"
            value = item.mime_type ?? "-"
        case 10:
            name = "Media Type"
            value = item.media_type ?? "-"
        default:
            break;
        }

        cell.textLabel?.text = value
        cell.detailTextLabel?.text = name

        return cell
    }

    public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

}
