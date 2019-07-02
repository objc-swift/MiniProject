//
//  AVPlayerView.swift
//  MiniProject
//
//  Created by yxyyxy on 2019/6/29.
//  Copyright © 2019 yxy. All rights reserved.
//


import AVKit
class AVPlayerView: UIView,AVAssetResourceLoaderDelegate{
    private var avPlayer:AVPlayer = AVPlayer()
    private var avPlayerLayer:AVPlayerLayer!
    var isRepeat:Bool = true
    var urlString:String! {
        didSet {
            var url:URL!
            let urlHead = self.urlString.components(separatedBy: ":").first!
            if urlHead == "http" || urlHead == "https" {
                url = URL(string: self.urlString) // http 的url
            }else {
                url = URL(fileURLWithPath: self.urlString) // 本地url
            }
            /*
             AVURLAsset *asset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
             AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
             AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
             */
            let asset = AVURLAsset(url: url)
            //asset.resourceLoader.setDelegate(self, queue:DispatchQueue.main)
            let playerItem = AVPlayerItem(asset: asset)
            self.avPlayer.replaceCurrentItem(with:playerItem)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeSubViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeSubViews()
    }
    override func layoutSubviews() {
        self.avPlayerLayer.frame = self.bounds
    }
    deinit {
        
    }
  
//    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
//        print("#######")
//        return true
//    }
//    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
//
//    }
}

// MARK: - Private Methods
extension AVPlayerView {
    private func initializeSubViews() {
        self.avPlayerLayer = AVPlayerLayer(player: avPlayer)
        self.avPlayerLayer.videoGravity = .resizeAspectFill
        self.layer.addSublayer(self.avPlayerLayer)
    }

}

// MARK: - Public Methods
extension AVPlayerView {
    public func play() {
        self.avPlayer.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.avPlayer.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                self.avPlayer.seek(to: CMTime.zero)
                self.avPlayer.play()
            }
        })
    }
}
