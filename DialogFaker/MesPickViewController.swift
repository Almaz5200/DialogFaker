//
//  MesPickViewController.swift
//  DialogFaker
//
//  Created by Артем Трубачеев on 28/08/2016.
//  Copyright © 2016 Артем Трубачеев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MesPickViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var typePick: UISegmentedControl!
    @IBOutlet weak var namePick: UITextField!
    @IBOutlet weak var avatarPick: UIButton!
    @IBOutlet weak var createDialog: UIButton!
    
    var opponentAvatar: UIImage?
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarPick.layer.cornerRadius = 10
        avatarPick.clipsToBounds = true
        avatarPick.rx_tap
            .subscribeNext { _ in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            .addDisposableTo(disposeBag)
        
        createDialog.rx_tap
            .subscribeNext { _ in
                let messagesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MessagesViewController") as! MessagesViewController
                messagesVC.opponentAvatar = self.opponentAvatar
                messagesVC.opponentName = self.namePick.text
                
                messagesVC.senderId = "sender"
                messagesVC.senderDisplayName = "sender"
                
                self.navigationController?.showViewController(messagesVC, sender: self)
            }
            .addDisposableTo(disposeBag)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.opponentAvatar = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}

