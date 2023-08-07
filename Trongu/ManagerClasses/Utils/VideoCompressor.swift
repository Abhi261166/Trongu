//
//  VideoCompressor.swift
//  meetwise
//
//  Created by Amandeep on 19/10/21.
//  Copyright © 2021 Nitin Kumar. All rights reserved.
//

import UIKit
import AVKit



enum VideoQuality {
    case heigh
    case medium
    case low
    
    var value: String {
        switch self {
        case .heigh: return AVAssetExportPresetHighestQuality
        case .medium: return AVAssetExportPresetMediumQuality
        case .low: return AVAssetExportPresetLowQuality
        }
    }
    
}

class VideoCompressor: NSObject {
    
    class func validateVideoSize(from url: URL, complition: @escaping(_ url: URL) -> ()) {
        print("value is 1 \(url)")
        let inputVideoURL: URL = url
        let sourceAsset = AVURLAsset(url: inputVideoURL)
        let sourceVideoTrack: AVAssetTrack? = sourceAsset.tracks(withMediaType: AVMediaType.video).first
        let sourceAudioTrack: AVAssetTrack? = sourceAsset.tracks(withMediaType: AVMediaType.audio).first
        let composition : AVMutableComposition = AVMutableComposition()
        let compositionVideoTrack: AVMutableCompositionTrack? = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let compositionAudioTrack: AVMutableCompositionTrack? = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
//        print("duration is \(CMTimeGetSeconds(sourceAsset.duration))    *****   \(sourceAsset.duration)")
//        let time = CMTime(value: CMTimeValue(20*sourceAsset.duration.timescale), timescale: sourceAsset.duration.timescale, flags: .init(rawValue: 1), epoch: 0)
//        let time = CMTime(value: CMTimeValue(20), timescale: sourceAsset.duration.timescale)
//        let duration = CMTimeGetSeconds(sourceAsset.duration) > 20 ? time : sourceAsset.duration
        
        let duration = sourceAsset.duration
//        print("duration is \(duration)")
        let x: CMTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: duration)
        if let sourceVideoTrack = sourceVideoTrack {

            _ = try? compositionVideoTrack?.insertTimeRange(x, of: sourceVideoTrack, at: CMTime.zero)
            
        }
        
        if let sourceAudioTrack = sourceAudioTrack {
            _ = try? compositionAudioTrack?.insertTimeRange(x, of: sourceAudioTrack, at: CMTime.zero)
        }
        
        let mutableVideoURL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/\(Date().timeIntervalSince1970).MOV")
        
        
        let exporter: AVAssetExportSession = AVAssetExportSession(asset: composition, presetName: VideoQuality.medium.value)!
        exporter.outputFileType = AVFileType.mov
        exporter.outputURL = mutableVideoURL
//        exporter.timeRange = x
        print("url is ---- \(mutableVideoURL)")
        
        exporter.exportAsynchronously(completionHandler: {
            DispatchQueue.main.async {
                switch exporter.status {
                case AVAssetExportSession.Status.failed:
                    print("AVAssetExportSession.Status.failed ***   failed \(exporter.error)")
                    complition(inputVideoURL)
                case AVAssetExportSession.Status.cancelled:
                    print("AVAssetExportSession.Status.failed ***   cancelled \(exporter.error)")
                case AVAssetExportSession.Status.unknown:
                    print("AVAssetExportSession.Status.failed ***   unknown\(exporter.error)")
                case AVAssetExportSession.Status.waiting:
                    print("AVAssetExportSession.Status.failed ***   waiting\(exporter.error)")
                case AVAssetExportSession.Status.exporting:
                    print("AVAssetExportSession.Status.failed ***   exporting\(exporter.error)")
                case .completed:
                    print("AVAssetExportSession.Status.failed ***   completed")
                    complition(mutableVideoURL)
                default:
                    print("-----Mutable video exportation complete.")
                }
            }
        })
    }
    
    
    class func compressVideo(inputURL: URL, quality: String = AVAssetExportPreset960x540,  handler: @escaping (_ url: URL?) -> Void) {
        
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputURL = directory.appendingPathComponent("cl_\(Date().timeIntervalSince1970).mp4")
        
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: quality) else {
            handler(nil)
            return
        }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        print("exportSession starts ***   \(exportSession.error)")
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case AVAssetExportSession.Status.failed:
                print("AVAssetExportSession.Status.failed ***   failed \(exportSession.error)")
                handler(inputURL)
            case AVAssetExportSession.Status.cancelled:
                print("AVAssetExportSession.Status.failed ***   cancelled \(exportSession.error)")
            case AVAssetExportSession.Status.unknown:
                print("AVAssetExportSession.Status.failed ***   unknown\(exportSession.error)")
            case AVAssetExportSession.Status.waiting:
                print("AVAssetExportSession.Status.failed ***   waiting\(exportSession.error)")
            case AVAssetExportSession.Status.exporting:
                print("AVAssetExportSession.Status.failed ***   exporting\(exportSession.error)")
            case .completed:
                print("AVAssetExportSession.Status.failed ***   completed")
                handler(outputURL)
                
                do {
                    let data = try Data(contentsOf: outputURL)
                    print(" ***************     ***************     \(data.count)  ***************    ")
                } catch {
                    print(" ***************    \(error)  ****  \(error.localizedDescription)    **************** ")
                }
            default:
                print("-----Mutable video exportation complete.")
            }
        }
    }
    
    
    
}

extension URL {
    func verboseFileSizeInMB() -> Float {
        let p = self.path
        let attr = try? FileManager.default.attributesOfItem(atPath: p)
        if let attr = attr {
            let fileSize = Float(attr[FileAttributeKey.size] as! UInt64) / (1024.0 * 1024.0)
            print(String(format: "FILE SIZE: %.2f MB", fileSize))
            return fileSize
        } else {
            return Float.zero
        }
    }
}


////Below update if any issue in library at SDAVAssetExportSession library changes below at m file:(changes as per your requirement)
//——   CGAffineTransform matrix = CGAffineTransformMakeTranslation(transx / xratio, transy / yratio - transform.ty);
//
//——//fix Orientation - 1
//UIImageOrientation videoAssetOrientation = UIImageOrientationUp;
//BOOL isVideoAssetPortrait = NO;
//CGAffineTransform videoTransform = videoTrack.preferredTransform;
//if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
//    videoAssetOrientation = UIImageOrientationRight;
//    isVideoAssetPortrait = YES;
//}
//if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
//    videoAssetOrientation =  UIImageOrientationLeft;
//    isVideoAssetPortrait = YES;
//}
//if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
//    videoAssetOrientation =  UIImageOrientationUp;
//}
//if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
//    videoAssetOrientation = UIImageOrientationDown;
//}
//// [passThroughLayer setTransform:transform atTime:kCMTimeZero];
//if ((videoAssetOrientation = UIImageOrientationDown) || (videoAssetOrientation = UIImageOrientationLeft)){
//    [passThroughLayer setTransform:videoTrack.preferredTransform atTime:kCMTimeZero];
//}else{
//    [passThroughLayer setTransform:transform atTime:kCMTimeZero];
//}
