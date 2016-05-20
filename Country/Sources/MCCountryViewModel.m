//
//  MCPlacemarkViewModel.m
//  Placemark
//
//  Created by Alexey Bukhtin on 29.03.16.
//  Copyright © 2016 The Mobile Company. All rights reserved.
//

@import MapKit;
#import "MCCountryViewModel.h"
#import "MCCountryRealmObject.h"

@implementation MCCountryViewModel

- (instancetype)initWithModel:(MCCountryRealmObject *)countryRealmObject
{
    self = [super init];
    
    if (self) {
        _name = countryRealmObject.name;
        
        NSMutableArray *polygons = [NSMutableArray array];
        
        for (MCMapRegionRealmObject *region in countryRealmObject.regions) {
            CLLocationCoordinate2D points[region.points.count];
            
            for (NSInteger i = 0; i < region.points.count; i++) {
                points[i] = CLLocationCoordinate2DMake([MCMapPointRealmObject integerToDegree:region.points[i].longitude],
                                                       [MCMapPointRealmObject integerToDegree:region.points[i].latitude]);
            }
            
            [polygons addObject:[MKPolygon polygonWithCoordinates:points count:region.points.count]];
        }
        
        _polygons = [polygons copy];
    }
    
    return self;
}

@end
