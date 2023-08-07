//
//  VideoTrimmerVC.swift
//  VidFlix
//
//  Created by apple on 19/05/22.
//  Copyright © 2022 apple. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices


protocol VideoTrimmerVCDelegate: NSObjectProtocol {
    func videoTrimmer(_ viewController: VideoTrimmerVC, didTrimVideo url:URL?, failedTrimming error: Error?)
    func videoTrimmerDidCancel(_ viewController: VideoTrimmerVC)
}

class VideoTrimmerVC: UIViewController {

    @IBOutlet weak var trimButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var trimmerView: TrimmerView!

    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    
    var url: URL!
    var player: AVPlayer!
    var playbackTimeCheckerTimer: Timer?
    var trimmerPositionChangedTimer: Timer?
    var delegate: VideoTrimmerVCDelegate?
    var assetId: String = ""
    var vdoDuration:CMTime? = nil

    
    init(url:URL, delegate: VideoTrimmerVCDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.url = url
        self.delegate = delegate
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("controller *** VideoTrimmerVC")
        trimmerView.handleColor = UIColor.white
        trimmerView.mainColor = UIColor.darkGray
        trimmerView.maxDuration = 60.0
        if url != nil {
            self.loadAsset(AVAsset(url: url))
        }
        vdoDuration = getVideoDuration(from: url)
        self.endTimeLabel.text = formatSecondsToString(vdoDuration?.seconds ?? 0)
    }
    
    
    func getVideoDuration(from url: URL) -> CMTime {
        let asset = AVURLAsset(url: url)
        let duration = asset.duration
        return duration
    }
    
    
    func getFileName() -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let outputURL = URL(fileURLWithPath: documentsPath).appendingPathComponent("cl_\(Date().miliseconds()).mp4")
        do {
            if FileManager.default.fileExists(atPath: outputURL.path) {
                try FileManager.default.removeItem(at: outputURL)
            }
            return outputURL
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    func trimVideo(url: URL, start: CMTime, end: CMTime, outcome: @escaping (Result<URL, Error>) -> Void) {
        //    func addWatermark(videoUrl: URL, image: UIImage, outcome: @escaping (Result<URL, Error>) -> Void) {
        
        let videoUrlAsset = AVURLAsset(url: url)
        let audioUrlAsset = AVURLAsset(url: url)
        let mixComposition = AVMutableComposition()
        
        let videoCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        if let videoAssetTrack = videoUrlAsset.tracks(withMediaType: AVMediaType.video).first {
            videoCompositionTrack?.preferredTransform = videoAssetTrack.preferredTransform
            try! videoCompositionTrack?.insertTimeRange(CMTimeRange(start: start, duration: end-start), of: videoAssetTrack, at: CMTime.zero)
            
        }
        if let audioAssetTrack = audioUrlAsset.tracks(withMediaType: AVMediaType.audio).first {
            
            let audioCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            audioCompositionTrack?.preferredTransform = audioAssetTrack.preferredTransform
            try! audioCompositionTrack?.insertTimeRange(CMTimeRange(start: start, duration: end-start), of: audioAssetTrack, at: CMTime.zero)
        }
        
        
        guard let exportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPreset960x540) else {
            outcome(.failure("_error" as! Error))
            return
        }
        guard let outputURL = self.getFileName() else { return }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        
        print("export session starts \(Date())")
        
        ActivityIndicator.shared.showActivityIndicator()
        exportSession.exportAsynchronously { [weak exportSession] in
            ActivityIndicator.shared.hideActivityIndicator()
            if let strongExportSession = exportSession {
                DispatchQueue.main.async {
                    print("composition ends  \(strongExportSession.status.rawValue)  \(Date())")
                    switch strongExportSession.status {
                    case .failed:
                        print("failed")
                        if let _error = strongExportSession.error {
                            outcome(.failure(_error))
                        }
                    case .cancelled:
                        print("cancelled")
                        if let _error = strongExportSession.error {
                            outcome(.failure(_error))
                        }
                    default:
                        print("finished")
                        outcome(.success(outputURL))
                    }
                }
            }
        }
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            DispatchQueue.main.async {
                self.delegate?.videoTrimmerDidCancel(self)
            }
        }
        player.pause()
        stopPlaybackTimeChecker()
        playButton.setTitle("Play", for: .normal)
    }
    
    @IBAction func trimAction(_ sender: UIButton) {
        guard let startTime = trimmerView.startTime,
              let endTime = trimmerView.endTime else {
            return
        }
        if player != nil {
            self.player.pause()
        }
        self.trimVideo(url: self.url, start: startTime, end: endTime) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let val):
                    print("success is \(val)")
                    self.delegate?.videoTrimmer(self, didTrimVideo: val, failedTrimming: nil)
                case .failure(let error):
                    print("error is \(error)")
                    self.delegate?.videoTrimmer(self, didTrimVideo: self.url, failedTrimming: nil)
                }
            }
        }
    }
    
    @IBAction func play(_ sender: Any) {
        guard url != nil else { return }
        if !player.isPlaying {
            player.play()
            startPlaybackTimeChecker()
            playButton.setTitle("Pause", for: .normal)
        } else {
            player.pause()
            stopPlaybackTimeChecker()
            playButton.setTitle("Play", for: .normal)
        }
    }

    func loadAsset(_ asset: AVAsset) {
        DispatchQueue.main.async { [self] in
            trimmerView.asset = asset
            trimmerView.delegate = self
            addVideoPlayer(with: asset, playerView: playerView)
        }
    }

    private func addVideoPlayer(with asset: AVAsset, playerView: UIView) {
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)

        NotificationCenter.default.addObserver(self, selector: #selector(VideoTrimmerVC.itemDidFinishPlaying(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)

        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: playerView.frame.width, height: playerView.frame.height)
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerView.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        playerView.layer.addSublayer(layer)
    }

    @objc func itemDidFinishPlaying(_ notification: Notification) {
        if let startTime = trimmerView.startTime {
            player?.seek(to: startTime)
            if (player?.isPlaying != true) {
                player?.play()
            }
        }
    }

    func startPlaybackTimeChecker() {
        stopPlaybackTimeChecker()
        playbackTimeCheckerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                                        selector:
            #selector(VideoTrimmerVC.onPlaybackTimeChecker), userInfo: nil, repeats: true)
    }

    func stopPlaybackTimeChecker() {

        playbackTimeCheckerTimer?.invalidate()
        playbackTimeCheckerTimer = nil
    }

    @objc func onPlaybackTimeChecker() {
        guard let startTime = trimmerView.startTime,
              let endTime = trimmerView.endTime,
              let player = player else {
            return
        }
        let playBackTime = player.currentTime()
        trimmerView.seek(to: playBackTime)

        if playBackTime >= endTime {
            player.seek(to: startTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            trimmerView.seek(to: startTime)
        }
    }
    
    
}

extension VideoTrimmerVC: TrimmerViewDelegate {
    func positionBarStoppedMoving(_ playerTime: CMTime) {
        print("TrimmerViewDelegate positionBarStoppedMoving \(self.trimmerView.startTime?.seconds) *** \(self.trimmerView.endTime?.seconds)")
        setStartTimeEndTime()
        player?.seek(to: playerTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        player?.play()
        startPlaybackTimeChecker()
    }

    func didChangePositionBar(_ playerTime: CMTime) {
        print("TrimmerViewDelegate didChangePositionBar \(self.trimmerView.startTime?.seconds) *** \(self.trimmerView.endTime?.seconds)")
        setStartTimeEndTime()
        stopPlaybackTimeChecker()
        player?.pause()
        player?.seek(to: playerTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        let duration = (trimmerView.endTime! - trimmerView.startTime!).seconds
        print(duration)
    }
    
    func setStartTimeEndTime() {
        if let start = self.trimmerView.startTime?.seconds {
            self.startTimeLabel.text = formatSecondsToString(start)
        } else {
            self.startTimeLabel.text = "00:00"
        }
        if let end = self.trimmerView.endTime?.seconds {
            self.endTimeLabel.text = formatSecondsToString(end)
        } else {
            self.endTimeLabel.text = "00:00"
        }
    }
    
    func formatSecondsToString(_ seconds: TimeInterval) -> String {
        if seconds.isNaN {
            return "00:00"
        }
        let Min = Int(seconds / 60)
        let Sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }
    
}

extension AVPlayer {
    var isPlaying: Bool {
        return self.rate != 0 && self.error == nil
    }
    
}
