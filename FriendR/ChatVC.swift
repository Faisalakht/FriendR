//
//  ChatVC.swift
//  FriendR
//
//  Created by Faisal Akhtar on 2017-04-04.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import JSQMessagesViewController

class ChatVC: JSQMessagesViewController {
    var msg = [JSQMessage]()

    var destname:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = FIRAuth.auth()?.currentUser?.uid
        self.senderDisplayName = FIRAuth.auth()?.currentUser?.email
        print("IN CHAT VC---------------------------")
        self.title = self.destname
        print(self.destname)
        observemessage()
        
    
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func observemessage()
    {
        
        FIRDatabase.database().reference().child(Constants.MESSAGES).observe(FIRDataEventType.childAdded)
            
        { (snapshot: FIRDataSnapshot) in
            
            //print (snapshot.value!)
            if let data  = snapshot.value as? NSDictionary {
                
                if let text = data[Constants.TEXT] as? String {
                 
                    
                    
                    if let dest = data[Constants.DEST_NAME] as? String {
                        
                        if let id = data[Constants.SENDER_ID] as? String {
                            
                            if let email = data[Constants.EMAIL] as? String {
                                
                                //print(dest)
                                //print(email)
                                //print(id)
                                //print(text)
                                
                                if (dest == self.senderDisplayName && email == self.destname) || (email == self.senderDisplayName && dest == self.destname) {
                                    
                                    
                                    if (email == self.senderDisplayName)
                                    {
                                        
                                        self.msg.append(JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text: text))
                                        
                                        
                                    }
                                    else {
                                        
                                        self.msg.append(JSQMessage(senderId: id, displayName: email, text: text))
                                        
                                        
                                    }
                                   
                                    
                                    DispatchQueue.main.async {
                                        self.collectionView.reloadData()
                                        
                                    }
                                    
                                }
                                
                            }
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                }
                
                
                
            }
            
            
            
            
            
            
        }
        
        
        
        
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        print(senderId)
        let data:Dictionary <String,Any> = [Constants.SENDER_ID : senderId,Constants.EMAIL : senderDisplayName,Constants.TEXT : text , Constants.DEST_NAME : destname]
        FIRDatabase.database().reference().child(Constants.MESSAGES).childByAutoId().setValue(data);
        //msg.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        print("pressed the sent button");
        finishSendingMessage();
        //collectionView.reloadData()
    }

    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return msg.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        return cell;
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return msg[indexPath.item];
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        //return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.black);
        let message = msg[indexPath.item]
        
        
        if message.senderId == self.senderId
        {
            print(destname);
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.black);
        }
            
        else{
            
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.cyan);
            
        }

        
        
        
        
        
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil;
    }
    
    
    
    
    
    
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        print("Attachment button pressed!");
        
        let imgChoose = UIImagePickerController()
        imgChoose.delegate = self;
        self.present(imgChoose, animated: true, completion: nil);
    }
    
    
    
    
    @IBAction func backbtn(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil);
    }
    
    

}





extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Attach Image");
        let pic = info[UIImagePickerControllerOriginalImage] as? UIImage
        let con_pic = JSQPhotoMediaItem(image: pic!)
        msg.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: con_pic))
        self.dismiss(animated: true, completion: nil);
        collectionView.reloadData()
    }
    
    
    
    
    
    
    
    
}
