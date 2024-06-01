//
//  HomeViewController.swift
//  csk
//
//  Created by Arvind K on 19/02/24.
//

import UIKit
import AVKit
class HomeViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
   
    let news=newsData
    var currentIndex = 0
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isPlaying = false
    var timeObserverToken: Any?
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if isPlaying {
                   pauseVideo()
         } else {
                playVideo()
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**Gallery Collection View**/
        collectionView.dataSource=self
        collectionView.delegate=self
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "galleryCell")
        startTimer()
        
        /**Whistlepodu Anthem Video**/
        if let videoUrl = Bundle.main.url(forResource: "whistles", withExtension: "mp4") {
            self.player = AVPlayer(url: videoUrl)
            self.player?.actionAtItemEnd = .none
            videoContainerView.clipsToBounds = true
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            playerLayer.frame = videoContainerView.bounds
            self.videoContainerView.layer.addSublayer(playerLayer)
            self.videoContainerView.bringSubviewToFront(playButton)
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(videoTapped))
                       videoContainerView.addGestureRecognizer(tapGesture)
            //seekbar
            seekBar.minimumValue = 0
            seekBar.value = 0
            player?.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.new], context: nil)
            player?.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.duration), options: [.new], context: nil)
            seekBar.addTarget(self, action: #selector(seekBarValueChanged(_:)), for: .valueChanged)
            self.videoContainerView.bringSubviewToFront(seekBar)
            self.videoContainerView.bringSubviewToFront(timeLabel)
            setupTimeObserver()

               }
               else {
                   print("File not exists")
               }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoContainerView.bounds
      }
    
    /**Segue**/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="news1Segue"){
            let destination=segue.destination as! NewsViewController
            let target=newsData[0]
            destination.loadView()
            destination.imageOutlet?.image=UIImage(named:target.image)
            destination.headlineOutlet?.text=target.headline
            destination.descriptionOutlet?.text=target.description
           
        }
        else if(segue.identifier=="news2Segue"){
            let destination=segue.destination as! NewsViewController
            let target=newsData[1]
            destination.loadView()
            destination.imageOutlet?.image=UIImage(named:target.image)
            destination.headlineOutlet?.text=target.headline
            destination.descriptionOutlet?.text=target.description
           
        }
    }
    /**Gallery Collection view**/
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCollection.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*0.8, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath)as! GalleryCollectionViewCell
        cell.data = imageCollection[indexPath.row]
        return cell
    }
    @objc func scrollToNextImage() {
        currentIndex = (currentIndex + 1) % imageCollection.count
        let indexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        // Calculate the centered content offset
        let centerX = collectionView.frame.width
        let cellAttributes = collectionView.layoutAttributesForItem(at: indexPath)
        let cellCenterX = cellAttributes?.center.x ?? 0
        let offsetX = cellCenterX - centerX
        // Set the centered content offset
        collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x + offsetX, y: 0), animated: true)
    }
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextImage), userInfo: nil, repeats: true)
    }

    /**Whistlepodu Anthem Video**/
    @objc func videoTapped() {
            if isPlaying {
                playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                playButton.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.playButton.isHidden = true
                }
            }
        else{
            self.playButton.isHidden = false
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }
        func playVideo() {
            player.play()
            isPlaying = true
            playButton.isHidden = true
        }
        func pauseVideo() {
            player.pause()
            isPlaying = false
            playButton.isHidden = false
        }
    @objc func playerItemStatusDidChange() {
        if player?.currentItem?.status == .readyToPlay {
            seekBar.maximumValue = Float(player?.currentItem?.duration.seconds ?? 0)
        }
    }
    @objc func seekBarValueChanged(_ sender: UISlider) {
        let seekTime = CMTime(seconds: Double(sender.value), preferredTimescale: 1000)
        player?.seek(to: seekTime)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            if player?.currentItem?.status == .readyToPlay {
                seekBar.maximumValue = Float(player?.currentItem?.duration.seconds ?? 0)
            }
        }
    }
    func updateSeekBar() {
        guard let player = player, let currentItem = player.currentItem else { return }

        let currentTime = Float(player.currentTime().seconds)
        let totalTime = Float(currentItem.duration.seconds)

        // Format the current and total time as a string
        let currentMinutes = Int(currentTime) / 60
        let currentSeconds = Int(currentTime) % 60
        let totalMinutes = Int(totalTime) / 60
        let totalSeconds = Int(totalTime) % 60

        timeLabel.text = String(format: "%02d:%02d / %02d:%02d", currentMinutes, currentSeconds, totalMinutes, totalSeconds)
    }

    func setupTimeObserver() {
        guard let player = player, let currentItem = player.currentItem else { return }

        let interval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            self?.updateSeekBar()
        }
    }

    deinit {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
        }
    }

    @objc func playerItemDidReachEnd(notification: NSNotification) {
           self.player?.seek(to: CMTime.zero)
           playButton.isHidden = false
           isPlaying = false
       }


}
