LYAVPlayer视频播放器，AVPlayer的封装，继承UIView.LYAVPlaye旨在封装AVPlayer,无意于写控制页面，因此用户可自定义页面。功能强大，简单易用。
<<<<<<< HEAD
`self.playerView =[[LYAVPlayerView alloc]init];`
`self.playerView.frame =CGRectMake(0, 64, ScreenWidth,200);` `self.playerView.delegate =self;`
`[self.view addSubview:self.playerView];`
`[self.playerView setURL:[NSURL URLWithString:VideoURL]];` `[self.playerView play];`
博客地址：http://www.jianshu.com/p/fb55715f42d5
                 http://www.jianshu.com/p/0ee431c2c694
=======
self.playerView =[[LYAVPlayerView alloc]init];
self.playerView.frame =CGRectMake(0, 64, ScreenWidth,200);
self.playerView.delegate =self;
[self.view addSubview:self.playerView];
[self.playerView setURL:[NSURL URLWithString:VideoURL]];
[self.playerView play];
博客地址：http://www.jianshu.com/p/fb55715f42d5
        http://www.jianshu.com/p/0ee431c2c694




              
              
>>>>>>> origin/master
