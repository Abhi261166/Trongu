//
//  VideoPlayerVC.swift
//  Trongu
//
//  Created by apple on 03/10/23.
//

import AVFoundation
import AVKit
import UIKit

class VideoPlayerVC: UIViewController {

    var videoUrl:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let videoURL = URL(string: videoUrl ?? "") 
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            player.play()
        }

    }
    
    
   
}
