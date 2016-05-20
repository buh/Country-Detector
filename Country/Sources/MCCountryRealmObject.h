//
//  MCCountryRealmObject.h
//  Country
//
//  Created by Alexey Bukhtin on 29.03.16.
//  Copyright © 2016 The Mobile Company. All rights reserved.
//

#import <Realm/Realm.h>
#import "MCMapRegionRealmObject.h"

@interface MCCountryRealmObject : RLMObject

@property NSString *name;
@property RLMArray <MCMapRegionRealmObject *> <MCMapRegionRealmObject> *regions;

@end

RLM_ARRAY_TYPE(MCCountryRealmObject)
