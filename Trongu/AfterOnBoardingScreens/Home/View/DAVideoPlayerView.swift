//
//  DAVideoPlayerView.swift
//  Clout Lyfe
//
//  Created by apple on 20/05/22.
//

import UIKit
import AVKit
import AVFoundation
import Kingfisher

extension Notification.Name {
    static let playerDidChangeFullscreenMode = Notification.Name("playerDidEnterFullscreenMode")
}

class DAVideoPlayerView: UIView, ObservableObject {
    
    static var player: DAVideoPlayerView?
    
    //MARK: Public variables
    var videoUrl: URL? {
        didSet {
            prepareVideoPlayer()
        }
    }
    var videoGravity: AVLayerVideoGravity = .resizeAspect {
        didSet {
            self.playerController.videoGravity = videoGravity
        }
    }
    var previewImage: UIImage? {
        didSet {
            previewImageView.image = previewImage
            previewImageView.contentMode = videoGravity == .resizeAspectFill ? .scaleAspectFill : .scaleAspectFit
            previewImageView.isHidden = false
        }
    }
    
    func duration() -> Int{
        if let duration =  videoAsset?.duration{
            var durationSeconds = Int(CMTimeGetSeconds(duration))
           // let time = timeString(time: TimeInterval(durationSeconds ))
            return durationSeconds
        }
       return 0
    }
    
    func currentTime() -> Int{
        if let duration =  playerController.player?.currentItem?.currentTime(){
            var durationSeconds = Int(CMTimeGetSeconds(duration))
           // let time = timeString(time: TimeInterval(durationSeconds ))
            return durationSeconds
        }
       return 0
    }
    
//    func timeString(time:TimeInterval) -> String {
//        let minutes = Int(time) / 60 % 60
//        let seconds = Int(time) % 60
//        return String(format:"%02i:%02i", minutes, seconds)
//    }
    var previewImageUrl: String? {
        didSet {
            previewImageView.setImage(image: previewImageUrl, placeholder: UIImage(named: "vidioPlaceHolder"))
            previewImageView.isHidden = false
        }
    }
    
    func showloading() {
        self.previewImageView.image = .gifImageWithName(name: "skeleton-loading")
    }
    
    //Automatically play the video when its view is visible on the screen.
    var shouldAutoplay: Bool = false {
        didSet {
            if shouldAutoplay {
                runTimer()
            } else {
                removeTimer()
            }
        }
    }

    //Automatically replay video after playback is complete.
    var shouldAutoRepeat: Bool = false {
        didSet {
            if oldValue == shouldAutoRepeat { return }
            if shouldAutoRepeat {
                NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
            } else {
                NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
            }
        }
    }
    
    //Automatically switch to full-screen mode when device orientation did change to landscape.
    var shouldSwitchToFullscreen: Bool = false {
        didSet {
            if oldValue == shouldSwitchToFullscreen { return }
            if shouldSwitchToFullscreen {
                NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
            } else {
                NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
            }
        }
    }
    
    //Use AVPlayer's controls or custom. Now custom control view has only "Play" button. Add additional controls if needed.
    var showsCustomControls: Bool = true {
        didSet {
            playerController.showsPlaybackControls = !showsCustomControls
            customControlsContentView.isHidden = !showsCustomControls
        }
    }
    
    //Value from 0.0 to 1.0, which sets the minimum percentage of the video player's view visibility on the screen to start playback.
    var minimumVisibilityValueForStartAutoPlay: CGFloat = 0.3
    
    //Mute the video.
    var isMuted: Bool = true {
        didSet {
            playerController.player?.isMuted = isMuted
        }
    }
    //MARK: Private variables
    fileprivate let playerController = AVPlayerViewController()
    var isPlaying: Bool = false
    fileprivate var videoAsset: AVURLAsset?
    fileprivate var displayLink: CADisplayLink?
    
    var previewImageView: UIImageView!
    fileprivate var customControlsContentView: UIView!
    fileprivate var playIcon: UIImageView!
    fileprivate var isFullscreen = false
    
//    var isAudioEnabled: Bool = false {
//        didSet {
//            self.playerController.player?.isMuted = !isAudioEnabled
//        }
//    }
    
    //MARK: Life cycle
    deinit {
        NotificationCenter.default.removeObserver(self)
//        removePlayerObservers()
        displayLink?.invalidate()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            pause()
            removeTimer()
        } else {
            if shouldAutoplay {
                runTimer()
            }
        }
    }
}

//MARK: View configuration
extension DAVideoPlayerView {
    fileprivate func setUpView() {
//        self.backgroundColor = .black
        addVideoPlayerView()
        configurateControls()
    }
    
    private func addVideoPlayerView() {
        playerController.view.frame = self.bounds
        playerController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerController.showsPlaybackControls = false
        playerController.view.backgroundColor = .clear
        self.insertSubview(playerController.view, at: 0)

    }
    
    private func configurateControls() {
        customControlsContentView = UIView(frame: self.bounds)
        customControlsContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customControlsContentView.backgroundColor = .clear
        
        previewImageView = UIImageView(frame: self.bounds)
        previewImageView.contentMode = .scaleAspectFit
        previewImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        previewImageView.clipsToBounds = true
        
        playIcon = UIImageView(image: UIImage(named:"")) //video
        playIcon.isUserInteractionEnabled = true
        playIcon.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        playIcon.center = previewImageView!.center
        playIcon.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        
        addSubview(previewImageView!)
        
        customControlsContentView?.addSubview(playIcon)
        addSubview(customControlsContentView!)
        
//        let playAction = UITapGestureRecognizer(target: self, action: #selector(didTapPlay))
//        playIcon.addGestureRecognizer(playAction)
//        let pauseAction = UITapGestureRecognizer(target: self, action: #selector(didTapPause))
//        customControlsContentView.addGestureRecognizer(pauseAction)
    }
}

//MARK: Timer part
extension DAVideoPlayerView {
    
    fileprivate func runTimer() {
        if displayLink != nil {
            displayLink?.isPaused = false
            return
        }
        displayLink = CADisplayLink(target: self, selector: #selector(timerAction))
        if #available(iOS 10.0, *) {
            displayLink?.preferredFramesPerSecond = 5
        } else {
            displayLink?.frameInterval = 5
        }
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    fileprivate func removeTimer() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func timerAction() {
        guard videoUrl != nil else {
            return
        }
        if isVisible() {
            play()
        } else {
            
            pause()
        }
    }
}

//MARK: Logic of the view's position search on the app screen.
extension DAVideoPlayerView {
    fileprivate func isVisible() -> Bool {
        if self.window == nil {
            return false
        }
        let displayBounds = UIScreen.main.bounds
        let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow})
        let selfFrame = self.convert(self.bounds, to: window)
        let intersection = displayBounds.intersection(selfFrame)
        let visibility = (intersection.width * intersection.height) / (frame.width * frame.height)
        return visibility >= minimumVisibilityValueForStartAutoPlay
    }
}

//MARK: Video player part
extension DAVideoPlayerView {
    fileprivate func prepareVideoPlayer() {
        playerController.player?.removeObserver(self, forKeyPath: "rate")
        guard let url = videoUrl else {
            self.videoAsset = nil
            self.playerController.player = nil
            return
        }
        let asset = AVAssetManager.setAsset(videoUrl: url)
        self.videoAsset = asset.0
        self.restorationIdentifier = url.absoluteString
        
        if let image = asset.1 {
            self.previewImage = image
            print("get saved image for url \(url.absoluteString)")
        } else {
            self.previewImage = nil
            if self.previewImageUrl == nil {
                let imgGenerator = AVAssetImageGenerator(asset: asset.0)
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                        DispatchQueue.main.async {
                            let image = UIImage(cgImage: cgImage)
                            if self.restorationIdentifier == url.absoluteString {
                                AVAssetManager.setImageTo(videoUrl: url, image: image)
                                self.previewImage = image
                            } else {
                                self.previewImage = nil
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.previewImage = nil
                        }
                    }
                }
            }
        }
        let item = AVPlayerItem(asset: videoAsset!)
        let player = AVPlayer(playerItem: item)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            // report for an error
        }
        player.isMuted = self.isMuted
        playerController.player = player
        playerController.videoGravity = videoGravity
        addPlayerObservers()
    }
    
    @objc fileprivate func didTapPlay() {
//        DAVideoPlayerView.player?.addActivityIndigator()
        displayLink?.isPaused = false
        play()
    }
    
    @objc fileprivate func didTapPause() {
        displayLink?.isPaused = true
//        DAVideoPlayerView.player?.removeActivityIndigator()
        pause()
    }
    
    func play() {
        if let player = DAVideoPlayerView.player {
            player.pause()
            
        }
        if isPlaying { return }
        isPlaying = true
//        videoAsset?.loadValuesAsynchronously(forKeys: ["playable", "tracks", "duration"], completionHandler: {
            DispatchQueue.main.async { [weak self] in
                if self?.isPlaying == true {
                    self?.playIcon.isHidden = true
//                    self?.previewImageView.isHidden = true
                    print("video will play \(self?.isPlaying)")
                    self?.playerController.player?.play()
                    print("self?.playerController.player? \(self?.playerController.player?.rate)")
                    DAVideoPlayerView.player = self
                }
            }
//        })
    }
    
    func pause() {
        if isPlaying {
            isPlaying = false
            playIcon.isHidden = false
            playerController.player?.pause()
        }
        DAVideoPlayerView.player = nil
    }
    
    func setPlayerNIL() {
        isPlaying = false
        playIcon.isHidden = false
        playerController.player?.pause()
        playerController.player = nil
    }
    
    @objc fileprivate func itemDidFinishPlaying() {
        if isPlaying {
            playerController.player?.seek(to: CMTime.zero, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            playerController.player?.play()
        }
    }
}

//MARK: Player size observing part
extension DAVideoPlayerView {
    fileprivate func addPlayerObservers() {
        playerController.player?.addObserver(self, forKeyPath: "rate", options: .new, context: nil)
        playerController.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        playerController.contentOverlayView?.addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
    }
   
    
    fileprivate func removePlayerObservers() {
        playerController.player?.removeObserver(self, forKeyPath: "rate")
        playerController.player?.removeObserver(self, forKeyPath: "timeControlStatus")
        playerController.contentOverlayView?.removeObserver(self, forKeyPath: "bounds")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("key path are \(keyPath)")
        
        let newValue = (change?[NSKeyValueChangeKey.newKey] as? Int)
        let oldValue = change?[NSKeyValueChangeKey.oldKey] as? Int
        
        switch keyPath! {
        case "rate":
//            self.previewImageView.isHidden = true
//            self.addActivityIndigator()
            print("****   rate ***** ")
        case "bounds":
            let fullscreen = playerController.contentOverlayView?.bounds == UIScreen.main.bounds
            if isFullscreen != fullscreen {
                isFullscreen = fullscreen
                NotificationCenter.default.post(name: .playerDidChangeFullscreenMode, object: isFullscreen)
            }
        case "timeControlStatus":
            print("****   timeControlStatus ***** \(newValue) ** \(oldValue)")
            if newValue == 2 && oldValue == 1 {
                if self.previewImageView.isHidden == false {
                    self.previewImageView.isHidden = true
                }
            }
            
            if (change?[NSKeyValueChangeKey.newKey] as? Int) == 2 {
                self.removeActivityIndigator()
            } else {
                self.addActivityIndigator(color: .clear, indigatorColor: .white)
            }
            
//            if let newValue = change?[NSKeyValueChangeKey.newKey] as? Int {
//                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
//                if newStatus == .playing {
//                    self.removeActivityIndigator()
//                } else if newStatus == .paused {
////                    self.addActivityIndigator()
//                } else {
//                    self.removeActivityIndigator()
//                }
//            }
            
//            if keyPath == "timeControlStatus",
//                let change = change,
//                let newValue = change[NSKeyValueChangeKey.newKey] as? Int,
//                let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
//
//                let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
//                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
//                if newStatus != oldStatus {
//                    DispatchQueue.main.async {[weak self] in
//                        if newStatus == .playing {
//                            self?.removeActivityIndigator()
//                        } else if newStatus == .paused {
//                            self?.addActivityIndigator()
//                        } else {
//                            self?.removeActivityIndigator()
//                        }
//                    }
//                }
//            }
        default: break
        }
    }
}

//MARK: Device orientation observing
extension DAVideoPlayerView {
    @objc fileprivate func deviceOrientationDidChange(_ notification: Notification) {
        if isFullscreen || !isVisible() { return }
        if let orientation = (notification.object as? UIDevice)?.orientation, orientation == .landscapeLeft || orientation == .landscapeRight {
            playerController.forceFullScreenMode()
            updateDeviceOrientation(with: orientation)
        }
    }
    
    private func updateDeviceOrientation(with orientation: UIDeviceOrientation) {
        UIDevice.current.setValue(UIDeviceOrientation.portrait.rawValue, forKey: "orientation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        })
    }
}

//MARK: AVPlayerViewController extension for force fullscreen mode
extension AVPlayerViewController {
    
    func forceFullScreenMode() {
        let selectorName : String = {
            if #available(iOS 11, *) {
                return "_transitionToFullScreenAnimated:completionHandler:"
            } else {
                return "_transitionToFullScreenViewControllerAnimated:completionHandler:"
            }
        }()
        let selectorToForceFullScreenMode = NSSelectorFromString(selectorName)
        if self.responds(to: selectorToForceFullScreenMode) {
            self.perform(selectorToForceFullScreenMode, with: true, with: nil)
        }
    }
}
