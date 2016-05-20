//
//  MCMapPresenter.m
//  Country
//
//  Created by Alexey Bukhtin on 29.03.16.
//  Copyright © 2016 The Mobile Company. All rights reserved.
//

#import "MCMapPresenter.h"
#import "MCCountryViewModel.h"
#import "MCCountryRealmObject.h"

@implementation MCMapPresenter

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        @weakify(self);
        _searchCountryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(MKMapCamera *camera) {
            return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                [subscriber sendNext:[self searchCountryAtCoordinate:camera.centerCoordinate]];
                [subscriber sendCompleted];
                
                return nil;
            }] subscribeOn:[RACScheduler scheduler]]
                    deliverOnMainThread];
        }];
    }
    
    return self;
}

- (MCCountryViewModel *)searchCountryAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    CLLocationDegrees latitude = coordinate.longitude;
    CLLocationDegrees longitude = coordinate.latitude;
    CLLocationDegrees epsilon = 0.;
    RLMResults *results;
    NSUInteger iterationsCount = 0;
    CLLocationDegrees delta = 0.01;
    
    while (!results.count) {
        iterationsCount++;
        
        if (!(iterationsCount % 3)) {
            delta *= 2.;
        }
        
        epsilon += delta;
        
        results = [MCMapPointRealmObject objectsWhere:@"latitude > %i AND latitude < %i AND longitude > %i AND longitude < %i",
                   [MCMapPointRealmObject degreeToInteger:(latitude - epsilon)],
                   [MCMapPointRealmObject degreeToInteger:(latitude + epsilon)],
                   [MCMapPointRealmObject degreeToInteger:(longitude - epsilon)],
                   [MCMapPointRealmObject degreeToInteger:(longitude + epsilon)]];
    }
    
    MCMapRegionRealmObject *region = [self findRegionWithPointsResults:results latitude:latitude longitude:longitude];
    
    return region ? [[MCCountryViewModel alloc] initWithModel:region.country] : nil;
}

- (MCMapRegionRealmObject *)findRegionWithPointsResults:(RLMResults *)results
                                               latitude:(CLLocationDegrees)latitude
                                              longitude:(CLLocationDegrees)longitude
{
    if (results.count < 2) {
        MCMapPointRealmObject *point = [results lastObject];
        
        return point.region;
    }
    
    MKMapPoint originalMapPoint = MKMapPointForCoordinate(CLLocationCoordinate2DMake(latitude, longitude));
    CGPoint mapPoint = CGPointMake(originalMapPoint.x, originalMapPoint.y);
    NSMutableArray *filteredRegions = [NSMutableArray array];
    
    for (MCMapPointRealmObject *point in results) {
        MCMapRegionRealmObject *region = point.region;
        
        if (![filteredRegions containsObject:region]) {
            BOOL firstPoint = YES;
            CGMutablePathRef mutablePath = CGPathCreateMutable();
            
            for (MCMapPointRealmObject *point in region.points) {
                MKMapPoint mapPoint =
                MKMapPointForCoordinate(CLLocationCoordinate2DMake([MCMapPointRealmObject integerToDegree:point.latitude],
                                                                   [MCMapPointRealmObject integerToDegree:point.longitude]));
                
                if (firstPoint) {
                    firstPoint = NO;
                    CGPathMoveToPoint(mutablePath, NULL, mapPoint.x, mapPoint.y);
                } else {
                    CGPathAddLineToPoint(mutablePath, NULL, mapPoint.x, mapPoint.y);
                }
            }
            
            if (CGPathContainsPoint(mutablePath, NULL, mapPoint, FALSE)) {
                return region;
            }
            
            [filteredRegions addObject:region];
        }
    }
    
    return nil;
}

@end
