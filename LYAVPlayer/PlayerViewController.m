//
//  PlayerViewController.m
//  LYVideoPlayer
//
//  Created by luyang on 2017/10/11.
//  Copyright © 2017年 Myself. All rights reserved.
//

#import "PlayerViewController.h"
#import "SecondViewController.h"




@interface PlayerViewController ()<LYVideoPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;


@property (weak, nonatomic) IBOutlet UISlider *slider;


@property (nonatomic,assign)BOOL isSlidering;

@property (nonatomic,strong)LYAVPlayerView *playerView;

@property (nonatomic,strong)AVURLAsset *asset;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    //想实现后台播放使用sharedInstance
    self.playerView =[LYAVPlayerView sharedInstance];
    //先获取视频的宽高比
    CGFloat scale =[self.playerView getVideoScale:[NSURL URLWithString:VideoURL]];
    self.playerView.frame =CGRectMake(0,64,ScreenWidth,200);
    self.playerView.backgroundColor =[UIColor redColor];
    self.playerView.delegate =self;
    [self.view addSubview:self.playerView];
    [self.playerView setURL:[NSURL URLWithString:VideoURL]];
    [self.playerView play];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5
//                                                              * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [self.playerView seekToTime:30];
//        [self.playerView play];
//
//
//    });
    
    
    _imageView.image =[self.playerView getThumbnailImageFromVideoURL:[NSURL URLWithString:VideoURL] time:5];
    
    
}


- (IBAction)playAction:(id)sender {
    
    [self.playerView play];
}


- (IBAction)pauseAction:(id)sender {
    
    [self.playerView pause];
    
}

- (IBAction)valueChange:(id)sender {
    
    CGFloat seconds =_slider.value;
    
    CGFloat totalTime =[self.playerView getTotalPlayTime];
    
    CGFloat time =seconds*totalTime;
    
    [self.playerView seekToTime:time];
    
    
    
}

- (IBAction)valueEnd:(id)sender {
    
    _isSlidering =YES;
    
}
- (IBAction)valueBegin:(id)sender {
    
    _isSlidering =NO;
    
    
}
- (IBAction)turnAction:(id)sender {
    
     [self.playerView pause];
    
    CGFloat time =[self.playerView getCurrentPlayTime];
    
    SecondViewController *viewCtrl =[[SecondViewController alloc]init];
    viewCtrl.asset =self.playerView.urlAsset;
    viewCtrl.time =time;
    [self.navigationController pushViewController:viewCtrl animated:NO];
    
}

#pragma mark-----LYVideoPlayerDelegate-------
// 可播放／播放中
- (void)videoPlayerIsReadyToPlayVideo:(LYAVPlayerView *)playerView{
    
    NSLog(@"可播放");
    
}

//播放完毕
- (void)videoPlayerDidReachEnd:(LYAVPlayerView *)playerView{
    
     NSLog(@"播放完毕");
    
}
//当前播放时间
- (void)videoPlayer:(LYAVPlayerView *)playerView timeDidChange:(CGFloat )time{
    
    NSLog(@"当前播放时间:%f",time);
    
    if(!_isSlidering){
        
        _slider.value =[self.playerView getCurrentPlayTime]/[self.playerView getTotalPlayTime];
        
    }
    
    
}


//duration 当前缓冲的长度
- (void)videoPlayer:(LYAVPlayerView *)playerView loadedTimeRangeDidChange:(CGFloat )duration{
    
    NSLog(@"当前缓冲的长度%f",duration);
    
    
}

//进行跳转后没数据 即播放卡顿
- (void)videoPlayerPlaybackBufferEmpty:(LYAVPlayerView *)playerView{
    
     NSLog(@"卡顿了");
    
}

// 进行跳转后有数据 能够继续播放
- (void)videoPlayerPlaybackLikelyToKeepUp:(LYAVPlayerView *)playerView{
    
     NSLog(@"能够继续播放");
    
}

//加载失败
- (void)videoPlayer:(LYAVPlayerView *)playerView didFailWithError:(NSError *)error{
    
     NSLog(@"加载失败");
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
