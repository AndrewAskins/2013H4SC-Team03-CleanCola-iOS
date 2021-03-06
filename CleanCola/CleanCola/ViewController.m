//
//  ViewController.m
//  CleanCola
//
//  Created by Marvin on 6/1/13.
//  Copyright (c) 2013 SCHackDay. All rights reserved.
//

#import "ViewController.h"
#import "IncidentViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //init Core Location
    CLController = [[CLLocationManager alloc] init];
    CLController.delegate = self;
    CLController.desiredAccuracy = kCLLocationAccuracyKilometer;
    CLController.distanceFilter = 500;
    
    RMMapBoxSource *source = [[RMMapBoxSource alloc] initWithMapID:@"cleancola.map-rmhk6v1q"];
    
    self.mapView = [[RMMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-_mybutton.frame.size.height) andTilesource:source];
    [self.view addSubview:self.mapView];
    [self.mapView setDelegate:self];
    self.mapView.zoom = 12;
    self.mapView.userTrackingMode = RMUserTrackingModeFollow;
    
    RMPointAnnotation *ann = [[RMPointAnnotation alloc] initWithMapView:self.mapView
                                                             coordinate:CLLocationCoordinate2DMake(48.839238, 2.337383)
                                                               andTitle:@"Here it is"];
    [self.mapView addAnnotation:ann];
    
    CLLocationDegrees latitude = 34.002;
    CLLocationDegrees longitude = -81.03;
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude, longitude);
    
    self.mapView.centerCoordinate = location;
    
    NSLog(@"%f", self.mapView.centerCoordinate.latitude);
    NSLog(@"%f", self.mapView.centerCoordinate.longitude);
    
    _mybutton.buttonColor = [UIColor emerlandColor];
    _mybutton.shadowColor = [UIColor nephritisColor];
    _mybutton.shadowHeight = 3.0f;
    _mybutton.cornerRadius = 0.0f;
    _mybutton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [_mybutton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_mybutton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];

    _refineButton.buttonColor = [UIColor peterRiverColor];
    _refineButton.shadowColor = [UIColor belizeHoleColor];
    _refineButton.shadowHeight = 3.0f;
    _refineButton.cornerRadius = 0.0f;
    _refineButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [_refineButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_refineButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    IManager = [[IncidentManager alloc]init];
    IManager.delegate = self;
    [IManager refreshIncidents];
    [self startLocatingUser];
    
    self.mapView.delegate = self;
}

-(void) viewDidAppear:(BOOL)animated
{
    [IManager refreshIncidents];
}

-(RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation {
    NSLog(@"Marker is called!"); //Is not outputted so this method is never called.
    RMMarker *marker = [[RMMarker alloc] initWithMapBoxMarkerImage:@"marker/pin-l-bus+48a.png"];
    return marker;
}

-(void)startLocatingUser
{
    //Find user's location
    if([CLLocationManager locationServicesEnabled] == YES && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
        [CLController startUpdatingLocation];
    }
    else{
        //rm._reloading = NO;
        noLocation = YES;
        //[self.specialTable reloadData];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        
       // [HUD show:YES];
        CGPoint location = CGPointMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        NSLog(@"%@", NSStringFromCGPoint(location));
        lastLocation = location;
        //[rm loadSpecialsWithLocation:location distance:self.filterDistance day:self.filterDay];
        //rm._reloading = YES;
        [CLController stopUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Location error");
   // rm._reloading = NO;
    noLocation = YES;
  //  [HUD hide:YES];
    //[self.specialTable reloadData];
}

- (void)locationError:(NSError *)error {
	NSLog(@"Encountered an error: %@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openReportView:(id)sender {
    ReportViewController *RVC = [[ReportViewController alloc]init];
    RVC.lastLocation = lastLocation;
    [self presentViewController:RVC animated:TRUE completion:nil];
}


- (IBAction)refineMapItems:(id)sender{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [self.mapView removeAllAnnotations];
    [IManager refreshIncidents];
    RMMapBoxSource *source = [[RMMapBoxSource alloc] initWithMapID:@"cleancola.map-rmhk6v1q"];
    [self.mapView reloadTileSource:source];
}

-(void) pushReportView
{
    if (![self.presentedViewController isBeingDismissed]) {
        
        ReportViewController *RVC = [[ReportViewController alloc]init];
        RVC.lastLocation = lastLocation;
        [self presentViewController:RVC animated:TRUE completion:nil];
    }
}


- (void)startCamera
{
    UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
    imagePickController.sourceType=UIImagePickerControllerSourceTypeCamera;
    imagePickController.delegate=self;
    imagePickController.allowsEditing=NO;
    //[self presentModalViewController:imagePickController animated:true];
    [self presentViewController:imagePickController animated:TRUE completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    //NSData* imageData = UIImagePNGRepresentation(image);
    
    //Chalkboard *newBoard = [[Chalkboard alloc]init];
    
    //[newBoard PostNewChalkboardWithImage:image];
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self pushReportView];
    }];
    
    [self pushReportView];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self pushReportView];
    }];
    
}

- (void)didLoadWithError:(NSError *)error{
    
}

- (void)didLoadIncidents:(NSArray *)incidents{
    for (Incident *In in incidents) {
        NSLog(@"%@",In.longitude);
        NSLog(@"%@",In.latitude);
//        RMPointAnnotation *ann = [[RMPointAnnotation alloc] initWithMapView:mapView
//                                                                 coordinate:CLLocationCoordinate2DMake(48.839238, 2.337383)
//                                                                   andTitle:@"Here it is"];
//        [mapView addAnnotation:ann];
        
        RMPointAnnotation *annotation01 = [[RMPointAnnotation alloc]initWithMapView:self.mapView coordinate:CLLocationCoordinate2DMake([In.latitude floatValue], [In.longitude floatValue])  andTitle:In.description];
        
        CCMarker *marker = [[CCMarker alloc] initWithMapView:self.mapView coordinate:CLLocationCoordinate2DMake([In.latitude floatValue], [In.longitude floatValue]) andTitle:In.description];
        marker.incident_id = In.incident_id;
        
        RMMarker *image = [[RMMarker alloc] initWithMapBoxMarkerImage:@"garden" tintColor:[UIColor redColor]];
        
        [marker setLayer:image];
        
        [self.mapView addAnnotation: marker];
    }
    //NSLog(@"%@",incidents);
}

- (void)mapView:(RMMapView *)mapView didSelectAnnotation:(RMAnnotation *)annotation
{
    CCMarker *marker = annotation;
    
    IncidentViewController *icViewController = [[IncidentViewController alloc] initWithNibName:@"IncidentViewController" bundle:nil incident_id:marker.incident_id];
    
    [self presentViewController:icViewController animated:YES completion:nil];
}

@end
