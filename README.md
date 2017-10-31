LYAVPlayer视频播放器，AVPlayer的封装，继承UIView.LYAVPlaye旨在封装AVPlayer,无意于写控制页面，因此用户可自定义页面。功能强大，简单易用。几行代码即可实现播放功能：
```
         LYAVPlayerView *playerView =[LYAVPlayerView alloc]init];         
         playerView.frame =CGRectMake(0, 64, ScreenWidth,200);
         playerView.delegate =self;//设置代理
         [self.view addSubview:playerView];
         [playerView setURL:[NSURL URLWithString:VideoURL]];//设置播放的URL
         [playerView play];//开始播放
```
博客地址：http://www.jianshu.com/u/e36a07f5dc7b
