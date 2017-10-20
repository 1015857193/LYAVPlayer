//
//  LYPlayerView.m
//  LYPlayer
//
//  Created by luyang on 2017/10/10.
//  Copyright © 2017年 Myself. All rights reserved.
//

#import "LYAVPlayerView.h"

static const CGFloat TimeObserverInterval = 0.01f;

static void *VideoPlayer_PlayerItemStatusContext = &VideoPlayer_PlayerItemStatusContext;

static void *VideoPlayer_PlayerItemPlaybackLikelyToKeepUp = &VideoPlayer_PlayerItemPlaybackLikelyToKeepUp;
static void *VideoPlayer_PlayerItemPlaybackBufferEmpty = &VideoPlayer_PlayerItemPlaybackBufferEmpty;
static void *VideoPlayer_PlayerItemLoadedTimeRangesContext = &VideoPlayer_PlayerItemLoadedTimeRangesContext;

NSString * const LYVideoPlayerErrorDomain = @"VideoPlayerErrorDomain";

@interface LYAVPlayerView()

//播放时为YES 暂停时为NO
@property (nonatomic, assign) BOOL isPlaying;

//播放属性
@property (nonatomic, strong) AVPlayer      *player;
@property (nonatomic, strong) AVPlayerItem  *item;
@property (nonatomic, strong) AVURLAsset    *urlAsset;
@property (nonatomic, strong) AVPlayerLayer  *playerLayer;

@property (nonatomic, strong) id timeObserverToken;

@property (nonatomic,assign)CGFloat rate;


@end


@implementation LYAVPlayerView

-(void)dealloc{
    
    NSLog(@"LYPlayerView销毁了");
    
    [self resetPlayerItemIfNecessary];
    
}

+ (instancetype)sharedInstance{
        
        static id sharedInstance =nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            sharedInstance =[[self alloc] init];
        });
        return sharedInstance;
        
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self =[super initWithCoder:aDecoder];
    if (self)
    {
        
        [self setupAudioSession];
    }
    
    return self;
    
    
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
     [self setupAudioSession];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self =[super initWithFrame:frame];
    
    if (self) {
        
        [self setupAudioSession];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
       
        [self setupAudioSession];
    }
    
    return self;
}

- (void)setupAudioSession
{
    //先设置rate为1.0
    _rate =1.0f;
    
    NSError *categoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&categoryError];
    if (!success)
    {
        NSLog(@"Error setting audio session category: %@", categoryError);
    }
    
    NSError *activeError = nil;
    success = [[AVAudioSession sharedInstance] setActive:YES error:&activeError];
    if (!success)
    {
        NSLog(@"Error setting audio session active: %@", activeError);
    }
}

//懒加载
- (NSString *)videoGravity{
    
    if(!_videoGravity){
        
        _videoGravity =AVLayerVideoGravityResizeAspect;
    }
    
    return _videoGravity;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(self.playerLayer){
    
    self.playerLayer.frame =self.bounds;
        
    }
    
}

//跳到xx秒播放视频
- (void)seekToTime:(CGFloat )time{
    
    if (self.player){
    
       [self.player.currentItem cancelPendingSeeks];
       
        CMTime cmTime =CMTimeMakeWithSeconds(time, 1);
//        if (CMTIME_IS_INVALID(cmTime) || self.player.currentItem.status != AVPlayerStatusReadyToPlay){
//
//            return;
//        }
        
        if (CMTIME_IS_INVALID(cmTime)) return;
        [self.player seekToTime:cmTime toleranceBefore:CMTimeMake(1,1)  toleranceAfter:CMTimeMake(1,1) completionHandler:^(BOOL finished) {
            
            
            
        }];
        
   }
    
}



//设置播放URL
- (void)setURL:(NSURL *)URL{
    
    //如果有正在播放的视频 先释放掉
    [self resetPlayerItemIfNecessary];
    
    self.urlAsset =[AVURLAsset assetWithURL:URL];
    
    [self creatPlayerWithAsset:self.urlAsset];
    
}

- (void)setAsset:(AVURLAsset *)asset{
    
    //如果有正在播放的视频 先释放掉
    [self resetPlayerItemIfNecessary];
    
    [self creatPlayerWithAsset:asset];
    
    
}

- (void)creatPlayerWithAsset:(AVURLAsset *)urlAsset{
    
    // 初始化playerItem
    self.item =[AVPlayerItem playerItemWithAsset:urlAsset];
    
    //判断
    if(!self.item){
        
        [self reportUnableToCreatePlayerItem];
        
        return;
        
    }
    
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    self.player =[AVPlayer playerWithPlayerItem:self.item];
    
    self.playerLayer =[AVPlayerLayer playerLayerWithPlayer:self.player];
    
    // 此处为默认视频填充模式
    self.playerLayer.videoGravity = self.videoGravity;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    // 添加playerLayer到self.layer
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    
    //添加播放时间观察
    [self enableTimeUpdates];
    //添加观察
    [self preparePlayerItem:self.item];
    
    
    
}

- (void)preparePlayerItem:(AVPlayerItem *)playerItem{
    
    [self addPlayerItemObservers:playerItem];
}

- (void)addPlayerItemObservers:(AVPlayerItem *)playerItem
{
    [playerItem addObserver:self
                 forKeyPath:@"status"
                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                    context:VideoPlayer_PlayerItemStatusContext];
    
    [playerItem addObserver:self
                 forKeyPath:@"playbackLikelyToKeepUp"
                    options:NSKeyValueObservingOptionNew
                    context:VideoPlayer_PlayerItemPlaybackLikelyToKeepUp];
    
    [playerItem addObserver:self
                 forKeyPath:@"playbackBufferEmpty"
                    options:NSKeyValueObservingOptionNew
                    context:VideoPlayer_PlayerItemPlaybackBufferEmpty];
    
    [playerItem addObserver:self
                 forKeyPath:@"loadedTimeRanges"
                    options:NSKeyValueObservingOptionNew
                    context:VideoPlayer_PlayerItemLoadedTimeRangesContext];
    
    //播放完毕的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidPlayToEndTime:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    //耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    
    
}

- (void)playerItemDidPlayToEndTime:(NSNotification *)notification
{
    if ([self.delegate respondsToSelector:@selector(videoPlayerDidReachEnd:)])
    {
        [self.delegate videoPlayerDidReachEnd:self];
    }
    
}

//耳机插入、拔出事件
 - (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            
            // 拔掉耳机继续播放
            if (self.isPlaying) {
                
                [self.player play];
            }
            
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            
            break;
    }
}


//移除player属性观察
- (void)removePlayerItemObservers:(AVPlayerItem *)playerItem
{
    [playerItem cancelPendingSeeks];
    
    [playerItem removeObserver:self forKeyPath:@"status" context:VideoPlayer_PlayerItemStatusContext];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:VideoPlayer_PlayerItemLoadedTimeRangesContext];
    [playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty" context:VideoPlayer_PlayerItemPlaybackBufferEmpty];
    [playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:VideoPlayer_PlayerItemPlaybackLikelyToKeepUp];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}


//播放时间 观察
- (void)addTimeObserver{
    
    if (self.timeObserverToken || !self.player) return;
    
    __weak typeof (self) weakSelf = self;
    self.timeObserverToken = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(TimeObserverInterval, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf)
        {
            return;
        }
        
        if ([strongSelf.delegate respondsToSelector:@selector(videoPlayer:timeDidChange:)])
        {
            [strongSelf.delegate videoPlayer:strongSelf timeDidChange:CMTimeGetSeconds(time)];
        }
        
        
        
    }];
    
    
}

//移除时间观察
- (void)removeTimeObserver{
    
    if (!self.timeObserverToken)
    {
        return;
    }
   
    
    if (self.player)
    {
        [self.player removeTimeObserver:self.timeObserverToken];
    }
    
    self.timeObserverToken = nil;
    
    
}

- (void)enableTimeUpdates{
    
    [self addTimeObserver];
    
    
}

- (void)disableTimeUpdates{
    
    [self removeTimeObserver];
    
}

- (void)reportUnableToCreatePlayerItem{
    
    if ([self.delegate respondsToSelector:@selector(videoPlayer:didFailWithError:)])
    {
        NSError *error = [NSError errorWithDomain:LYVideoPlayerErrorDomain
                                             code:100
                                         userInfo:@{NSLocalizedDescriptionKey : @"Unable to create AVPlayerItem."}];
        
        [self.delegate videoPlayer:self didFailWithError:error];
    }
    
    
    
    
}


//释放
- (void)resetPlayerItemIfNecessary{
    
    if (self.item )
    {
        [self removePlayerItemObservers:self.item];
        
       
    }
    
    //移除时间观察
    [self disableTimeUpdates];
    
    if (self.playerLayer) {
        
         [self.playerLayer removeFromSuperlayer];
    }
   
    
    if (self.item){
       
        self.item = nil;
    }
    
    if (self.player) {
        
        [self.player replaceCurrentItemWithPlayerItem:nil];
        self.player =nil;
    }
    
    if (self.urlAsset) {
        self.urlAsset =nil;
    }
    
    if (self.playerLayer) {
        
        self.playerLayer =nil;
    }
    
    
    
}

//播放
- (void)play{
    
    if(!self.isPlaying){
        
        self.isPlaying =YES;
        self.player.rate = _rate;
        
    }
    
}

//暂停
- (void)pause{
    
    if(self.isPlaying){
    
    self.isPlaying =NO;
    self.player.rate =0.0f;
        
    }
    
}

//停止播放
- (void)stop{
    
    [self.player pause];
    
    //item置为nil相关
    [self resetPlayerItemIfNecessary];
    
}

//设置播放倍速 0.5-2.0
- (void)setPlayerRate:(CGFloat )rate{
    
    _rate =rate;
    
    if(self.player) self.player.rate =rate;
    
    
}

//获取当前播放的时间
- (CGFloat )getCurrentPlayTime{
    
    if(self.player) return CMTimeGetSeconds([self.player currentTime]);
        
    return 0.0f;
}

//获取视频的总时间长
- (CGFloat)getTotalPlayTime{
    
  if(self.player) return CMTimeGetSeconds(self.player.currentItem.duration);
    
   return 0.0f;
}

#pragma mark - Observer Response
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //player状态
    if (context == VideoPlayer_PlayerItemStatusContext){
        
        AVPlayerStatus newStatus = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        AVPlayerStatus oldStatus = [[change objectForKey:NSKeyValueChangeOldKey] integerValue];
        
        if (newStatus != oldStatus) {
            
            switch (newStatus) {
                case AVPlayerItemStatusUnknown:
                    
                    NSLog(@"Video player Status Unknown");
                    
                    break;
                    
                  case AVPlayerItemStatusReadyToPlay:
                    
                    if ([self.delegate respondsToSelector:@selector(videoPlayerIsReadyToPlayVideo:)])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.delegate videoPlayerIsReadyToPlayVideo:self];
                            
                      });
                        
                        
                    }
                    
                    
                    break;
                    
                    
                
                case AVPlayerStatusFailed:{
                    
                   
                NSError *error = [NSError errorWithDomain:LYVideoPlayerErrorDomain code:100 userInfo:@{NSLocalizedDescriptionKey : @"unknown player error, status == AVPlayerItemStatusFailed"}];
                    
                    if ([self.delegate respondsToSelector:@selector(videoPlayer:didFailWithError:)])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate videoPlayer:self didFailWithError:error];
                        });
                    }
                    
                
                }
                    break;
            }
            
        }
        
        
        
    }else if (context == VideoPlayer_PlayerItemPlaybackBufferEmpty){
     //缓冲为空
        if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            
            if (self.player.currentItem.playbackBufferEmpty) {
                
                if ([self.delegate respondsToSelector:@selector(videoPlayerPlaybackBufferEmpty:)])
                {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        [self.delegate videoPlayerPlaybackBufferEmpty:self];
                        
                    });
                    
                }
                
            }
            
            
        }
        
        
    }else if (context == VideoPlayer_PlayerItemPlaybackLikelyToKeepUp){
        
        if([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            
            if (self.player.currentItem.playbackLikelyToKeepUp){
                
                if ([self.delegate respondsToSelector:@selector(videoPlayerPlaybackLikelyToKeepUp:)]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        [self.delegate videoPlayerPlaybackLikelyToKeepUp:self];
                        
                    });
                    
                }
                
                
            }
            
        }
        
        
    }else if (context == VideoPlayer_PlayerItemLoadedTimeRangesContext){
        
        if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            
            if ([self.delegate respondsToSelector:@selector(videoPlayer:loadedTimeRangeDidChange:)])
            {
                
                CGFloat loadedDuration =[self calcLoadedDuration];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    [self.delegate videoPlayer:self loadedTimeRangeDidChange:loadedDuration];
                    
                });
                
            }
            
            
        }
        
        
        
    }else{
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
    }
    
    
    
    
}

- (CGFloat )calcLoadedDuration
{
    CGFloat loadedDuration = 0.0f;
    
    if (self.player && self.player.currentItem)
    {
        NSArray *loadedTimeRanges = self.player.currentItem.loadedTimeRanges;
        
        if (loadedTimeRanges && [loadedTimeRanges count])
        {
            CMTimeRange timeRange = [[loadedTimeRanges firstObject] CMTimeRangeValue];
            CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
            CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
            
            loadedDuration = startSeconds + durationSeconds;
        }
    }
    
    return loadedDuration;
}


@end
