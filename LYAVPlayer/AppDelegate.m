//
//  AppDelegate.m
//  LYVideoPlayer
//
//  Created by luyang on 2017/10/11.
//  Copyright © 2017年 Myself. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayerViewController.h"
#import "FirstViewController.h"


#import "LYAVPlayerView.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 后台播放音频设置,需要在Capabilities->Background Modes中勾选Audio,Airplay,and Picture in Picture
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    FirstViewController *first =[[FirstViewController alloc]init];
    
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:first];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    
    
    
}

//已经进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    LYAVPlayerView *playerView =[LYAVPlayerView sharedInstance];
    [playerView.playerLayer setPlayer:nil];

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

//已经激活
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    LYAVPlayerView *playerView =[LYAVPlayerView sharedInstance];
    AVPlayer *player =playerView.player;
    [playerView.playerLayer setPlayer:player];

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
