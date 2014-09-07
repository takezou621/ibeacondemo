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
    
    if ([self.beacon.minor isEqual:[NSNumber numberWithInt:1]]) {
        self.imageView.image = [UIImage imageNamed:@"apple.jpg"];
    }else if ([self.beacon.minor isEqual:[NSNumber numberWithInt:2]]) {
        self.imageView.image = [UIImage imageNamed:@"mouse.jpg"];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
  //  [defaults setObject:nil forKey:@"minor"];
  //  [defaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   // [defaults setObject:nil forKey:@"minor"];
   // [defaults synchronize];
    
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
