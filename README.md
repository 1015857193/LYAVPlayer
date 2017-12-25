LYAVPlayer视频播放器，AVPlayer的封装，继承UIView.LYAVPlaye旨在封装AVPlayer,无意于写控制页面，因此用户可自定义页面。功能强大，简单易用。几行代码即可实现播放功能：
```
         LYAVPlayerView *playerView =[LYAVPlayerView alloc]init];         
         playerView.frame =CGRectMake(0, 64, ScreenWidth,200);
         playerView.delegate =self;//设置代理
         [self.view addSubview:playerView];
         [playerView setURL:[NSURL URLWithString:VideoURL]];//设置播放的URL
         [playerView play];//开始播放
```
支持`cocoa pods 工程中pod 'LYAVPlayer','~> 1.0.1'`

博客地址：https://juejin.im/user/585b4586128fe1006b95bd7b
