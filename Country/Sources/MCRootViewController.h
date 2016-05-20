//
//  ViewController.h
//  Country
//
//  Created by Alexey Bukhtin on 29.03.16.
//  Copyright © 2016 The Mobile Company. All rights reserved.
//

@import UIKit;
@import MapKit;
#import "MCMapPresenter.h"

@interface MCRootViewController : UIViewController

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UILabel *countryLabel;
@property (nonatomic, weak) IBOutlet UIView *crosshairView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) MCMapPresenter *presenter;

@end

