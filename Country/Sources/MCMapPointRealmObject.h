//
//  MCMapPointRealmObject.h
//  Country
//
//  Created by Alexey Bukhtin on 29.03.16.
//  Copyright © 2016 The Mobile Company. All rights reserved.
//

#import <Realm/Realm.h>

@class MCMapRegionRealmObject;

@interface MCMapPointRealmObject : RLMObject

@property NSInteger latitude;
@property NSInteger longitude;
@property (nonatomic, readonly) MCMapRegionRealmObject *region;

+ (NSInteger)degreeToInteger:(double)degree;
+ (double)integerToDegree:(NSInteger)integer;

@end

RLM_ARRAY_TYPE(MCMapPointRealmObject)
