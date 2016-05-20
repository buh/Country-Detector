//
//  MCMapRegionRealmObject.h
//  Country
//
//  Created by Alexey Bukhtin on 29.03.16.
//  Copyright © 2016 The Mobile Company. All rights reserved.
//

#import <Realm/Realm.h>
#import "MCMapPointRealmObject.h"

@class MCCountryRealmObject;

@interface MCMapRegionRealmObject : RLMObject

@property RLMArray <MCMapPointRealmObject *> <MCMapPointRealmObject> *points;
@property (nonatomic, readonly) MCCountryRealmObject *country;

@end

RLM_ARRAY_TYPE(MCMapRegionRealmObject)
