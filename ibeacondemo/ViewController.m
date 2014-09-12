//
//  ViewController.m
//  ibeacondemo
//
//  Created by KawaiTakeshi on 2014/09/07.
//  Copyright (c) 2014年 KawaiTakeshi. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AGPushNoteView.h"
#import "DetailViewController.h"

@interface ViewController () <CLLocationManagerDelegate>
    @property (nonatomic) CLLocationManager *locationManager;
    @property (nonatomic) NSUUID            *proximityUUID;
    @property (nonatomic) CLBeaconRegion    *beaconRegion;
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        // CLLocationManagerの生成とデリゲートの設定
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        
        // UUID
        /*
        self.proximityUUID = [[NSUUID alloc] initWithUUIDString:@"5431B16E-02B5-1801-86F6-001C4D269B5F"];
        
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID
                                                          identifier:@"jp.co.uxf.ibeacontest"];
        [self.locationManager startMonitoringForRegion:self.beaconRegion];
         */
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"1234" forKey:@"minor"];
        [defaults synchronize];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    // UUID
    self.proximityUUID = [[NSUUID alloc] initWithUUIDString:@"5431B16E-02B5-1801-86F6-001C4D269B5F"];
    
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID
                                                           identifier:@"jp.co.uxf.ibeacontest"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
}

- (IBAction)buttonPushAction:(id)sender {
    
}

#pragma mark - CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
   // [AGPushNoteView showWithNotificationMessage:@"start monitor for region"];
    [self.locationManager requestStateForRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    //[AGPushNoteView showWithNotificationMessage:@"enter region"];
    
    if ([region isMemberOfClass:[CLBeaconRegion class]] &&
        [CLLocationManager isRangingAvailable]) {
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    //[AGPushNoteView showWithNotificationMessage:@"exit region"];
    
    if ([region isMemberOfClass:[CLBeaconRegion class]] &&
        [CLLocationManager isRangingAvailable]) {
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        switch (state) {
            case CLRegionStateInside:
                if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
                    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
                }
                
                break;
            case CLRegionStateOutside:
                break;
            case CLRegionStateUnknown:
                break;
                
            default:
                break;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count > 0) {
        // CLProximityUnknown以外のビーコンだけを取り出す
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"proximity != %d", CLProximityUnknown];
        NSArray *validBeacons = [beacons filteredArrayUsingPredicate:predicate];
        CLBeacon *nearestBeacon = validBeacons.firstObject;
        NSString *rangeMessage;
        
        switch (nearestBeacon.proximity) {
            case CLProximityImmediate:{
                rangeMessage = @"近い";
                //[self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSNumber *minor = [defaults objectForKey:@"minor"];
                NSLog(@"%d , %d",minor.intValue,nearestBeacon.minor.intValue);
                if (minor.intValue != nearestBeacon.minor.intValue) {
                    //[self performSegueWithIdentifier:@"detailSegue" sender:nearestBeacon];
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    DetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"detailVC"];
                    vc.beacon = nearestBeacon;
                    [self.navigationController popViewControllerAnimated:NO];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                break;
            }
            case CLProximityNear:{
                rangeMessage = @"やや近い";
                ///
                
                //[self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSNumber *minor = [defaults objectForKey:@"minor"];
                NSLog(@"%d , %d",minor.intValue,nearestBeacon.minor.intValue);
                if (minor.intValue != nearestBeacon.minor.intValue) {
                    //[self performSegueWithIdentifier:@"detailSegue" sender:nearestBeacon];
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    DetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"detailVC"];
                    vc.beacon = nearestBeacon;
                    [self.navigationController popViewControllerAnimated:NO];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                ///
                break;
            }
            case CLProximityFar:{
                rangeMessage = @"遠い";
                ///
                
                //[self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSNumber *minor = [defaults objectForKey:@"minor"];
                NSLog(@"%d , %d",minor.intValue,nearestBeacon.minor.intValue);
                if (minor.intValue != nearestBeacon.minor.intValue) {
                    //[self performSegueWithIdentifier:@"detailSegue" sender:nearestBeacon];
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    DetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"detailVC"];
                    vc.beacon = nearestBeacon;
                    [self.navigationController popViewControllerAnimated:NO];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                ///
                break;
            }
            default:
                break;
        }
        
        
        NSString *message = [NSString stringWithFormat:@"%@ major:%@, minor:%@, accuracy:%f,rssi:%d",
                             rangeMessage,
                             nearestBeacon.major,nearestBeacon.minor,nearestBeacon.accuracy,nearestBeacon.rssi];
        self.titleLabel.text = message;
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    //[AGPushNoteView showWithNotificationMessage:@"Exit Region"];
}

#pragma mark - 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detailSegue"]) {
        DetailViewController *vc = [segue destinationViewController];
        CLBeacon *beacon = (CLBeacon *)sender;
        vc.beacon = beacon;
    }
}
@end