//
//  MCPlacemarkViewModel.h
//  Placemark
//
//  Created by Alexey Bukhtin on 29.03.16.
//  Copyright © 2016 The Mobile Company. All rights reserved.
//

@import MapKit;

@class MCCountryRealmObject;

@interface MCCountryViewModel : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSArray <MKPolygon *> *polygons;

- (instancetype)initWithModel:(MCCountryRealmObject *)countryRealmObject;

@end
