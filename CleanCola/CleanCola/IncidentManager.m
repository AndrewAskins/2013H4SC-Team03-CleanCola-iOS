//
//  IncidentManager.m
//  CleanCola
//
//  Created by Jason Rikard on 6/1/13.
//  Copyright (c) 2013 SCHackDay. All rights reserved.
//

#import "IncidentManager.h"

@implementation IncidentManager
@synthesize _reloading, delegate;

- (void)loadIncidentsWithLocation
{
    RKObjectMapping* incidentMapping = [RKObjectMapping mappingForClass:[Incident class]];
    [incidentMapping addAttributeMappingsFromDictionary:@{
     @"date_created": @"date_created",
     @"description": @"description",
     @"incident_id": @"incident_id",
     @"latitude": @"latitude",
     @"longitude": @"longitude"
     }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:incidentMapping pathPattern:nil keyPath:@"incidents" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:@"http://api.cleancola.org/incidents"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        RKLogInfo(@"Load collection of Articles: %@", mappingResult.array);
    
        [delegate didLoadIncidents:mappingResult.array];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
    }];
    [objectRequestOperation start];
}

-(void)refreshIncidents{
    [self loadIncidentsWithLocation];
}

-(void)makeNewReportWithIncident:(Incident *)inc
{
    RKObjectMapping *postObjectMapping = [RKObjectMapping requestMapping];
    [postObjectMapping addAttributeMappingsFromDictionary:@{
     @"date_created": @"date_created",
     @"description": @"description",
     @"incident_id": @"incident_id",
     @"latitude": @"latitude",
     @"longitude": @"longitude",
     @"category_id": @"category_id"
     }];
//    
//    RKObjectMapping* incidentMapping = [RKObjectMapping mappingForClass:[Incident class]];
//    [incidentMapping addAttributeMappingsFromDictionary:@{
//     @"date_created": @"date_created",
//     @"description": @"description",
//     @"incident_id": @"incident_id",
//     @"latitude": @"latitude",
//     @"longitude": @"longitude"
//     }];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:postObjectMapping
                                                                                   objectClass:[Incident class] rootKeyPath:nil];
    
    [[RKObjectManager sharedManager] addRequestDescriptor: requestDescriptor];
    
    Incident *inc2 = [[Incident alloc]init];
    inc2.description = @"This is my new article!";
    inc2.category_id = @"0";
    inc2.latitude = @"-81.1";
    inc2.longitude = @"34.0906";

    //RKLogConfigureByName("RestKit", RKLogLevelWarning);
    //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);

    [[RKObjectManager sharedManager] postObject:inc2 path:@"/incidents" parameters:nil success:nil failure:nil];
}
@end
