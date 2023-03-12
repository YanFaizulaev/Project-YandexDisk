//
//  DirectoryViewController.swift
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

public protocol DirectoryViewControllerDelegate {
    func directoryViewController(dirController:DirectoryViewController!, didSelectFileWithURL fileURL: NSURL?, resource:YandexDiskResource) -> Void
}

public class DirectoryViewController: UITableViewController {

    public var delegate : DirectoryViewControllerDelegate?
    var disk: YandexDisk!
    var dirItem: YandexDiskResource?
    var entries: [YandexDiskResource?] = []

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewStyle) {
        super.init(style: style)

        refreshControl = UIRefreshControl()
        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: Selector("reloadDir"), forControlEvents: .ValueChanged)
        }
    }

    public convenience init?(disk: YandexDisk) {
        self.init(style: .Plain)
        self.disk = disk

        refreshTitle()
        reloadDir()
    }

    public convenience init?(disk: YandexDisk, path: YandexDiskResource) {
        self.init(style: .Plain)
        self.disk = disk
        self.dirItem = path

        refreshTitle()
        reloadDir()
    }

    private var bundle : NSBundle {
        return NSBundle(forClass: DirectoryViewController.self)
    }

    func reloadDir() -> Void {
        var ownPath = YandexDisk.Path.Disk("")

        if let path = dirItem {
            ownPath = path.path
        }

        dispatch_async(dispatch_get_main_queue()) {
            if let refreshControl = self.refreshControl {
                refreshControl.beginRefreshing()
            }
        }

        disk.listPath(ownPath, preview_size:.L, handler: listHandler)
    }

    func listHandler(listing:YandexDisk.ListingResult) -> Void {
        switch listing {
        case .Failed(let error):
            println("An error occured: \(error.localizedDescription)")
        case .File(let file):
            println("Callback Handler was called for a file: \(file.name) at path: \(file.path)")
        case let .Listing(dir, limit, offset, total, path, sort, items):
            if offset == 0 {
                self.entries = Array<YandexDiskResource?>(count: total, repeatedValue: nil)

                if total > items.count {
                    let sliceSize = 100

                    for (var sliceOffset = limit; sliceOffset < total; sliceOffset+=sliceSize) {
                        disk.listPath(path, limit: sliceSize, offset: sliceOffset, sort: sort, handler: listHandler)
                    }
                }
            }
            for (index, item) in enumerate(items) {
                self.entries[offset + index] = item
            }

            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }

        dispatch_async(dispatch_get_main_queue()) {
            if let refreshControl = self.refreshControl {
                refreshControl.endRefreshing()
            }
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self

        refreshTitle()
    }

    func refreshTitle() {
        if let pathListing = dirItem {
            title = pathListing.path.description.lastPathComponent
        } else {
            title = "Tiny Disk"
        }
    }

    // MARK: UITableView methods

    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {

        let cellIdentifier = "TinyDiskDirCell"

        var cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell

        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }

        if let entry = entries[indexPath.row] {

            cell.textLabel?.text = entry.name
            cell.detailTextLabel?.text = entry.mime_type

            switch entry.type {
            case .Directory:
                cell.imageView?.image = UIImage(named: "Folder_icon", inBundle:self.bundle, compatibleWithTraitCollection:nil)
                cell.accessoryType = .DetailDisclosureButton
            case .File:
                cell.imageView?.image = UIImage(named: "File_icon", inBundle:self.bundle, compatibleWithTraitCollection:nil)
                cell.accessoryType = .None
            }
        }

        return cell
    }

    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let entry = entries[indexPath.row] {
            switch entry.type {
            case .Directory:
                if let nextDirController = DirectoryViewController(disk: disk, path:entry) {
                    nextDirController.delegate = delegate
                    navigationController?.pushViewController(nextDirController, animated: true)
                }
            case .File:
                delegate?.directoryViewController(self, didSelectFileWithURL: nil, resource: entry)
            }
        }
    }

    override public func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        if let entry = entries[indexPath.row] {
            delegate?.directoryViewController(self, didSelectFileWithURL: nil, resource: entry)
        }
    }

    override public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .None:
            break
        case .Insert:
            break

        case .Delete:
            if let entry = entries[indexPath.row] {
                disk.deletePath(entry.path, permanently:nil) {
                    (result) in
                    switch result {
                    case .Failed:
                        break
                    default:
                        self.reloadDir()
                    }
                }
            }
        }
        return
    }

    override public func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String!  {
        return "Delete"
    }

    func performAction(action: UITableViewRowAction!, indexPath: NSIndexPath!) {

        if let entry = self.entries[indexPath.row] {
            switch action.title as String {
            case "Unpublish":
                disk.unpublishPath(entry.path) {  _ in
                    self.reloadDir()
                }

            case "Publish":
                disk.publishPath(entry.path) { _ in
                    self.reloadDir()
                }

            default:
                break
            }
        }
    }

    override public func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {

        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") {
            (action, indexPath) -> Void in
            self.tableView(tableView, commitEditingStyle: .Delete, forRowAtIndexPath: indexPath)
        }

        if let entry = entries[indexPath.row] {
            if entry.public_url != nil {
                let unpublishAction = UITableViewRowAction(style: .Default, title: "Unpublish", handler: performAction)
                unpublishAction.backgroundColor = UIColor.orangeColor()
                return [deleteAction, unpublishAction]
            } else {
                let publishAction = UITableViewRowAction(style: .Default, title: "Publish", handler: performAction)
                publishAction.backgroundColor = UIColor.greenColor()
                return [deleteAction, publishAction]
            }
        }

        return [deleteAction]
    }

}
