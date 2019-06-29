//
//  AVPlayerView.swift
//  MiniProject
//
//  Created by yxyyxy on 2019/6/29.
//  Copyright © 2019 yxy. All rights reserved.
//


import AVKit
class AVPlayerView: UIView {
    private var avPlayer:AVPlayer = AVPlayer()
    private var avPlayerLayer:AVPlayerLayer!
    var isRepeat:Bool = true
    var urlString:String! {
        didSet {
            var url:URL!
            if self.urlString.components(separatedBy: ":").first == "http" {
                url = URL(string: self.urlString) // http 的url
            }else {
                url = URL(fileURLWithPath: self.urlString) // 本地url
            }
            self.avPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
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
