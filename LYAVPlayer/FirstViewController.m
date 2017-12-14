//
//  FirstViewController.m
//  LYAVPlayer
//
//  Created by luyang on 2017/11/29.
//  Copyright © 2017年 Myself. All rights reserved.
//

#import "FirstViewController.h"
#import "PlayerViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(100, 100, 60, 60);
    btn.layer.cornerRadius =5;
    btn.layer.masksToBounds =YES;
    [btn setTitle:@"播放" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font =[UIFont systemFontOfSize:18];
    [btn addTarget:self action:@selector(inputDeviceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)inputDeviceAction{
    
     PlayerViewController *playerViewCtrl =(PlayerViewController *)[[UIStoryboard storyboardWithName:@"PlayerViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayerView"];
    
    [self.navigationController pushViewController:playerViewCtrl animated:NO];
    
    
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
