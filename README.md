LYAVPlayer视频播放器，AVPlayer的封装，继承UIView.LYAVPlaye旨在封装AVPlayer,无意于写控制页面，因此用户可自定义页面。功能强大，简单易用。几行代码即可实现视频播放：
              LYAVPlayerView *playerView =[[LYAVPlayerView alloc]init];
              playerView.frame =CGRectMake(0, 64, ScreenWidth,200);
              playerView.delegate =self;
              [self.view addSubview:playerView];
              [playerView setURL:[NSURL URLWithString:VideoURL]];
              [playerView play];
              
 具体详情参见demo。
 博客地址：http://www.jianshu.com/p/fb55715f42d5</br>
         http://www.jianshu.com/p/fb55715f42d5
              
              
