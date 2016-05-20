//
//  MCMapPointRealmObject.m
//  Country
//
//  Created by Alexey Bukhtin on 29.03.16.
//  Copyright © 2016 The Mobile Company. All rights reserved.
//

#import "MCMapPointRealmObject.h"
#import "MCMapRegionRealmObject.h"

static NSInteger const degreeMultiplyer = 1e7;

@implementation MCMapPointRealmObject

+ (NSDictionary *)defaultPropertyValues
{
    return @{ @"latitude":@0, @"longitude":@0 };
}

+ (NSArray <NSString *> *)indexedProperties
{
    return @[ @"latitude", @"longitude" ];
}

- (MCMapRegionRealmObject *)region
{
    return [[self linkingObjectsOfClass:NSStringFromClass([MCMapRegionRealmObject class])
                            forProperty:NSStringFromSelector(@selector(points))] lastObject];
}

+ (NSInteger)degreeToInteger:(double)degree
{
    return degree * degreeMultiplyer;
}

+ (double)integerToDegree:(NSInteger)integer
{
    return ((double)integer) / ((double)degreeMultiplyer);
}

@end
