//
//  AppDelegate.m
//  Country
//
//  Created by Alexey Bukhtin on 29.03.16.
//  Copyright © 2016 The Mobile Company. All rights reserved.
//

#import <Realm/Realm.h>
#import "MCAppDelegate.h"
#import "MCCountryRealmObject.h"
#import "MCMapPresenter.h"
#import "MCRootViewController.h"

@implementation MCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupRealm];
    
    ((MCRootViewController *)self.window.rootViewController).presenter = [MCMapPresenter new];
    
    return YES;
}

- (void)setupRealm
{
    NSString *realmPath = [self realmPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:realmPath]) {
        NSString *bundleRealmPath = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"realm"];
        [[NSFileManager defaultManager] copyItemAtPath:bundleRealmPath toPath:realmPath error:nil];
    }
    
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
    configuration.path = realmPath;
    [RLMRealmConfiguration setDefaultConfiguration:configuration];
}

- (NSString *)realmPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    return [path stringByAppendingPathComponent:@"Countries.realm"];
}

@end
