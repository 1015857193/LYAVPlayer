//
//  SecondViewController.m
//  LYAVPlayer
//
//  Created by luyang on 2017/10/16.
//  Copyright © 2017年 Myself. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (nonatomic,strong)LYAVPlayerView *playerView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.playerView =[[LYAVPlayerView alloc]init];
    self.playerView.frame =CGRectMake(0, 64, ScreenWidth,200);
   // self.playerView.delegate =self;
    [self.view addSubview:self.playerView];
    [self.playerView setAsset:_asset];
    
    [self.playerView seekToTime:_time];
    [self.playerView play];
    

    
    
    
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
