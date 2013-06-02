//
//  ViewController.h
//  CleanCola
//
//  Created by Marvin on 6/1/13.
//  Copyright (c) 2013 SCHackDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ReportViewController.h"
#import <MapBox/MapBox.h>
#import <FlatUIKit/FUIButton.h>
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FlatUIKit/UIFont+FlatUI.h>
#import <FlatUIKit/UIImage+FlatUI.h>
#import "IncidentManager.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, IncidentDelegate, RMMapViewDelegate>{
    CLLocationManager *CLController;
    BOOL noLocation;
    BOOL useNearbyLocation;
    CGPoint lastLocation;
    IncidentManager *IManager;
}

@property (nonatomic, strong) RMMapView *mapView;
//@property (nonatomic, strong) FUIButton *myButton;
@property (weak, nonatomic) IBOutlet FUIButton *mybutton;

- (IBAction)openReportView:(id)sender;

@end