//
//  ViewController.m
//  Parser
//
//  Created by Alexey Bukhtin on 29.03.16.
//  Copyright © 2016 The Mobile Company. All rights reserved.
//

#import <Realm/Realm.h>
#import "MCPViewController.h"
#import "CXMLDocument.h"
#import "CXMLElement.h"
#import "MCCountryRealmObject.h"
#import "MCMapRegionRealmObject.h"
#import "MCMapPointRealmObject.h"

@implementation MCPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *title = @"DB file exists";
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self realmPath]]) {
        [self parseFile];
        title = @"Done";
    }
    
    [[[UIAlertView alloc] initWithTitle:title
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)parseFile
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"world-stripped" ofType:@"kml"];
    NSData *XMLData   = [NSData dataWithContentsOfFile:filePath];
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:XMLData options:0 error:nil];
    CXMLElement *rootElement = [doc rootElement];
    __block CXMLNode *documentNode = nil;
    
    [[rootElement children] enumerateObjectsUsingBlock:^(CXMLNode *child, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([child kind] == CXMLElementKind) {
            documentNode = child;
            *stop = YES;
        }
    }];
    
    if (documentNode) {
        NSArray <CXMLNode *> *placemarks = [self placemarkNodeInNode:documentNode];
        
        if (placemarks.count) {
            [[RLMRealm defaultRealm] transactionWithBlock:^{
                [placemarks enumerateObjectsUsingBlock:^(CXMLNode *placemark, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self parsePlacemark:placemark];
                }];
            }];
            
            [self copyRealm];
        }
    }
}

- (NSArray <CXMLNode *> *)placemarkNodeInNode:(CXMLNode *)node
{
    NSMutableArray <CXMLNode *> *placemarks = [NSMutableArray array];
    
    [[node children] enumerateObjectsUsingBlock:^(CXMLNode *child, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([child kind] == CXMLElementKind) {
            if ([[child name] isEqualToString:@"Placemark"]) {
                [placemarks addObject:child];
            } else {
                [placemarks addObjectsFromArray:[self placemarkNodeInNode:child]];
            }
        }
    }];
    
    return [placemarks copy];
}

- (void)parsePlacemark:(CXMLNode *)placemark
{
    //    RLMRealm *realm = [RLMRealm defaultRealm];
    __block NSString *name;
    __block NSMutableArray <NSString *> *regions = [NSMutableArray array];
    
    [[placemark children] enumerateObjectsUsingBlock:^(CXMLNode *child, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([child kind] == CXMLElementKind) {
            if ([[child name] isEqualToString:@"name"]) {
                name = [child stringValue];
                
            } else if ([[child name] isEqualToString:@"MultiGeometry"]) {
                [[child children] enumerateObjectsUsingBlock:^(CXMLNode *polygon, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *coordinates = [self coordinatesFromPolygonNode:polygon];
                    
                    if (coordinates.length) {
                        [regions addObject:coordinates];
                    }
                }];
            } else if ([[child name] isEqualToString:@"Polygon"]) {
                NSString *coordinates = [self coordinatesFromPolygonNode:child];
                
                if (coordinates.length) {
                    [regions addObject:coordinates];
                }
            }
        }
    }];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    MCCountryRealmObject *country = [MCCountryRealmObject new];
    country.name = name;
    [realm addObject:country];
    
    [regions enumerateObjectsUsingBlock:^(NSString *coordinates, NSUInteger idx, BOOL *stop) {
        MCMapRegionRealmObject *region = [MCMapRegionRealmObject new];
        [realm addObject:region];
        [country.regions addObject:region];
        
        NSArray *coordinatesPairs = [coordinates componentsSeparatedByString:@",0 "];
        
        [coordinatesPairs enumerateObjectsUsingBlock:^(NSString *coordinatesPair, NSUInteger idx, BOOL * _Nonnull stop) {
            if (coordinatesPair.length) {
                NSArray *pointData = [coordinatesPair componentsSeparatedByString:@","];
                
                if (pointData.count == 2 || pointData.count == 3) {
                    MCMapPointRealmObject *point = [MCMapPointRealmObject new];
                    point.latitude = [MCMapPointRealmObject degreeToInteger:[pointData[0] doubleValue]];
                    point.longitude = [MCMapPointRealmObject degreeToInteger:[pointData[1] doubleValue]];
                    [realm addObject:point];
                    [region.points addObject:point];
                    
                } else {
                    NSLog(@"Bad point %@ -> %@", pointData, coordinates);
                }
            }
        }];
    }];
}

- (NSString *)coordinatesFromPolygonNode:(CXMLNode *)polygonNode
{
    __block NSString *coordinates = nil;
    
    [[polygonNode children] enumerateObjectsUsingBlock:^(CXMLNode *child, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([child kind] == CXMLElementKind) {
            if ([[child name] isEqualToString:@"coordinates"]) {
                coordinates = [child stringValue];
            } else {
                coordinates = [self coordinatesFromPolygonNode:child];
            }
        }
    }];
    
    return [coordinates stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)copyRealm
{
    [[RLMRealm defaultRealm] writeCopyToPath:[self realmPath] error:nil];
}

- (NSString *)realmPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    return [path stringByAppendingPathComponent:@"Countries.realm"];
}

@end
