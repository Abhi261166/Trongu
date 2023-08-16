//
//  HomeTableViewCell.swift
//  Findr
//
//  Created by apple on 31/03/23.
//

import UIKit
import AVKit
import AVFoundation
class AddPostCVC: UICollectionViewCell {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var videoTimeLabel: UILabel!
    @IBOutlet weak var volumeButton: UIButton!
    @IBOutlet weak var videoPlayerView: DAVideoPlayerView!
    
    var originalScale: CGFloat = 1.0
    var urlString: String?
    var timer: Timer?
    var duretion: Int?
    var oldDuretion: Int?
    var index:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        videoPlayerView.shouldAutoRepeat = true
        // Set up the scroll view
               scrollView.delegate = self
               scrollView.minimumZoomScale = 1.0
               scrollView.maximumZoomScale = 6.0
               scrollView.delaysContentTouches = false

               // Set up the pinch gesture recognizer
               let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureRecognized(_:)))
               scrollView.addGestureRecognizer(pinchGesture)
               originalScale = scrollView.zoomScale
        
        
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
        }
    
    func setPostData(_ url: String?,thumbnail_image:String?) {
        self.urlString = url
        if url?.isImageType == false {
            self.videoPlayerView.previewImageUrl = thumbnail_image
            print("set preview Image Url **** \(thumbnail_image ?? "")")
            if let urlStr = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: urlStr) {
                self.videoPlayerView.videoUrl = url
                duretion = videoPlayerView.duration()
                print("set video url **** \(url)")
            }
            self.volumeButton.isHidden = false
            runTimer()
            postImage.isHidden = true
            self.videoTimeLabel.isHidden = false
            videoPlayerView.isHidden = false
        } else {
            if let urlStr = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: urlStr) {
                self.postImage.setImage(image: urlStr)
                
                print("post image url **** \(url)")
            }
            postImage.isHidden = false
            videoPlayerView.isHidden = true
            self.volumeButton.isHidden = true
            self.videoTimeLabel.isHidden = true
        }
        self.videoPlayerView.isMuted = false
    }
    
    @IBAction func volumeAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected == true{
            self.videoPlayerView.isMuted = true
        }else{
            self.videoPlayerView.isMuted = false
        }
      print("Hit valume button")
    }
    
    @IBAction func watchingAction(_ sender: UIButton) {
        
    }
    
    func timeString(time:TimeInterval) -> String {
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
            return String(format:"%02i:%02i", minutes, seconds)
        }
    
    func runTimer() {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        let time = (self.duretion ?? 0) - videoPlayerView.currentTime()
        videoTimeLabel.text = timeString(time: TimeInterval(time))
    }
    
}

extension AddPostCVC:UIScrollViewDelegate{
    @objc func pinchGestureRecognized(_ gestureRecognizer: UIPinchGestureRecognizer) {
  
            let currentScale = postImage.frame.size.width / postImage.bounds.size.width
            var newScale = currentScale * gestureRecognizer.scale
            
            // Limit zoom-out to the initial image size
            if newScale < originalScale {
                newScale = originalScale
            }
            
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
        postImage.transform = transform
            
            gestureRecognizer.scale = 1.0
  
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
               return postImage
    }
    
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
            // Handle the double tap here
            let pointInView = gesture.location(in: postImage)
            
            if postImage.frame.contains(pointInView) {
                // Zoom the image
                zoomImage()
            }
        }
        
        private func zoomImage() {
            // Implement your logic to zoom the image
            // You can use UIScrollView or CGAffineTransform scale transformation
            // Here's an example using UIScrollView
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 3.0
            
            // Optionally, you can animate the zooming effect
            scrollView.alpha = 0.0
            UIView.animate(withDuration: 0.3) { [self] in
                scrollView.alpha = 1.0
            }
        }
    
}
