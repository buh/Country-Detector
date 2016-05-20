//
//  MCMapRegionRealmObject.m
//  Country
//
//  Created by Alexey Bukhtin on 29.03.16.
//  Copyright © 2016 The Mobile Company. All rights reserved.
//

#import "MCMapRegionRealmObject.h"
#import "MCCountryRealmObject.h"

@implementation MCMapRegionRealmObject

- (MCCountryRealmObject *)country
{
    return [[self linkingObjectsOfClass:NSStringFromClass([MCCountryRealmObject class])
                            forProperty:NSStringFromSelector(@selector(regions))] lastObject];
}

@end
