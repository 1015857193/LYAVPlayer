//
//  AppDelegate.m
//  LYVideoPlayer
//
//  Created by luyang on 2017/10/11.
//  Copyright © 2017年 Myself. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayerViewController.h"

#import "LYAVPlayerView.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    PlayerViewController *playerViewCtrl =(PlayerViewController *)[[UIStoryboard storyboardWithName:@"PlayerViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayerView"];
    
    self.window.rootViewController = playerViewCtrl;
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
