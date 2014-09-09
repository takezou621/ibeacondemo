//
//  DetailViewController.m
//  ibeacondemo
//
//  Created by KawaiTakeshi on 2014/09/07.
//  Copyright (c) 2014年 KawaiTakeshi. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
{
    NSUserDefaults *defaults;
    NSString *path;
    NSString *buttonTitle;
    UIColor  *buttonColor;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    NSLog(@"set minor %d",self.beacon.minor.intValue);
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.beacon.minor forKey:@"minor"];
    [defaults synchronize];
    //self.movieView.backgroundColor = [UIColor redColor];
    
    if ([self.beacon.minor isEqual:[NSNumber numberWithInt:1]]) {
        // 1の場合
        path = [[NSBundle mainBundle] pathForResource:@"micky" ofType:@"mp4"];
        buttonTitle = @"ミッキーからの贈り物をゲット!";
        buttonColor = [UIColor greenColor];
    }else if ([self.beacon.minor isEqual:[NSNumber numberWithInt:2]]) {
        // 2の場合
        path = [[NSBundle mainBundle] pathForResource:@"duck" ofType:@"mp4"];
        buttonTitle = @"ドナルドダックからの贈り物をゲット!";
        buttonColor = [UIColor redColor];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onVideoEnd)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    [self setupPlayer];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
  //  [defaults setObject:nil forKey:@"minor"];
  //  [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   // [defaults setObject:nil forKey:@"minor"];
   // [defaults synchronize];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"readyForDisplay"]) {
        [self.playerLayer removeObserver:self forKeyPath:@"readyForDisplay"];
        [self.player play];
    }
}

- (void)onVideoEnd
{
    NSLog(@"video end");
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, 400, 280, 80);
    button.backgroundColor = buttonColor;
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:button];
}

- (void)setupPlayer
{
    if (self.player == nil) {
        
        NSURL *url = [NSURL fileURLWithPath:path];
        self.player = [AVPlayer playerWithURL:url];
        
        if (self.playerLayer) {
            [self.playerLayer removeFromSuperlayer];
        }
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.movieView.bounds;
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.movieView.layer addSublayer:self.playerLayer];
        
        [self.playerLayer addObserver:self
                           forKeyPath:@"readyForDisplay"
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    }else{
        [self.player seekToTime:kCMTimeZero];
        [self.player play];
    }
    
}

- (IBAction)startPlay:(id)sender {
    [self setupPlayer];
}
@end
