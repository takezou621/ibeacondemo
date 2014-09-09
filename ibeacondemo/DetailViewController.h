//
//  DetailViewController.h
//  ibeacondemo
//
//  Created by KawaiTakeshi on 2014/09/07.
//  Copyright (c) 2014年 KawaiTakeshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@import AVFoundation;

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) CLBeacon *beacon;
@property (weak, nonatomic) IBOutlet UIView *movieView;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

- (IBAction)startPlay:(id)sender;
@end
