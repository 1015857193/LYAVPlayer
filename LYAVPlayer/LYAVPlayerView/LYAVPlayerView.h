//
//  LYPlayerView.h
//  LYPlayer
//
//  Created by luyang on 2017/10/10.
//  Copyright © 2017年 Myself. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class LYAVPlayerView;

@protocol LYVideoPlayerDelegate <NSObject>

@optional

/*
 *
 *AVPlayerItem的三种状态
 *AVPlayerItemStatusUnknown,
 *AVPlayerItemStatusReadyToPlay,
 *AVPlayerItemStatusFailed
 */

//所有的代理方法均已回到主线程 可直接刷新UI
// 可播放／播放中
- (void)videoPlayerIsReadyToPlayVideo:(LYAVPlayerView *)playerView;
//播放完毕
- (void)videoPlayerDidReachEnd:(LYAVPlayerView *)playerView;
//当前播放时间
- (void)videoPlayer:(LYAVPlayerView *)playerView timeDidChange:(CGFloat )time;
//duration 当前缓冲的长度
- (void)videoPlayer:(LYAVPlayerView *)playerView loadedTimeRangeDidChange:(CGFloat )duration;
//进行跳转后没数据 即播放卡顿
- (void)videoPlayerPlaybackBufferEmpty:(LYAVPlayerView *)playerView;
// 进行跳转后有数据 能够继续播放
- (void)videoPlayerPlaybackLikelyToKeepUp:(LYAVPlayerView *)playerView;
//加载失败
- (void)videoPlayer:(LYAVPlayerView *)playerView didFailWithError:(NSError *)error;

@end


@interface LYAVPlayerView : UIView

/**
 
 AVPlayerLayer的videoGravity属性设置
 AVLayerVideoGravityResize,       // 非均匀模式。两个维度完全填充至整个视图区域
 AVLayerVideoGravityResizeAspect,  // 等比例填充，直到一个维度到达区域边界
 AVLayerVideoGravityResizeAspectFill, // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
 */
@property (nonatomic, copy) NSString         *videoGravity;

//播放时为YES 暂停时为NO
@property (nonatomic, assign,readonly) BOOL isPlaying;

//播放属性
@property (nonatomic, strong,readonly) AVPlayer      *player;
@property (nonatomic, strong,readonly) AVPlayerItem  *item;
@property (nonatomic, strong,readonly) AVURLAsset    *urlAsset;
@property (nonatomic, strong,readonly) AVPlayerLayer  *playerLayer;

@property (nonatomic,weak) id<LYVideoPlayerDelegate> delegate;

//单例
+ (instancetype)sharedInstance;

//设置播放URL
- (void)setURL:(NSURL *)URL;

//跳到xx秒播放视频
- (void)seekToTime:(CGFloat )time;

//播放
- (void)play;

//暂停
- (void)pause;

//停止播放
- (void)stop;

//设置播放倍速 0.5-2.0
- (void)setPlayerRate:(CGFloat )rate;

//获取当前播放的时间
- (CGFloat )getCurrentPlayTime;

//获取视频的总时间长
- (CGFloat)getTotalPlayTime;




@end
