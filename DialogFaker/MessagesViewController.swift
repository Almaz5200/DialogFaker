//
//  MessagesViewController.swift
//  DialogFaker
//
//  Created by Артем Трубачеев on 28/08/2016.
//  Copyright © 2016 Артем Трубачеев. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import RxSwift

class MessagesViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleColor = UIColor.whiteColor()
    var outgoingBubbleColor = UIColor.whiteColor()
    
    var outgoingBubbleTextColor = UIColor.whiteColor()
    var incomingBubbleTextColor = UIColor.whiteColor()
    
    var opponentName: String?
    var opponentAvatar: UIImage?
    
    var styleType = 0
    
    func sendMessage(text: String) {
        let alert = UIAlertController(title: "Отправитель", message: "Выберете отправителя", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Собеседник", style: .Default, handler: { _ in
            self.messages.append(JSQMessage(senderId: "opponent", displayName: "opponent", text: text))
            self.finishSendingMessage()
        }))
        alert.addAction(UIAlertAction(title: "Я", style: .Default, handler: { _ in
            self.messages.append(JSQMessage(senderId: "sender", displayName: "sender", text: text))
            self.finishSendingMessage()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch styleType {
        case 0:
            collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
            collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
            
            self.navigationController?.navigationBar.topItem?.title = ""
            
            UIApplication.sharedApplication().statusBarStyle = .LightContent
            
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 87/255, green: 130/255, blue: 178/255, alpha: 1)
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            
            collectionView.backgroundColor = UIColor(red: 237/255, green: 243/255, blue: 250/255, alpha: 1)
            
            incomingBubbleColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            outgoingBubbleColor = UIColor(red: 205/255, green: 226/255, blue: 250/255, alpha: 1)
            
            outgoingBubbleTextColor = UIColor.blackColor()
            incomingBubbleTextColor = UIColor.blackColor()

        default:
            print("Error")
        }
        
        setupBubbles()
        
        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: "Hello"))
        messages.append(JSQMessage(senderId: "as", displayName: "as", text: "Hello1"))
        
        finishReceivingMessage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(outgoingBubbleColor)
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(incomingBubbleColor)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        sendMessage(text)
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {}
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        if messages[indexPath.row].senderId == self.senderId {
            cell.textView!.textColor = outgoingBubbleTextColor
        } else {
            cell.textView.textColor = incomingBubbleTextColor
        }
        
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
