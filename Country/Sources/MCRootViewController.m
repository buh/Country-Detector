//
//  ViewController.m
//  Country
//
//  Created by Alexey Bukhtin on 29.03.16.
//  Copyright © 2016 The Mobile Company. All rights reserved.
//

#import "MCRootViewController.h"
#import "ReactiveCocoa.h"
#import "MCCountryViewModel.h"

@interface MCRootViewController () <MKMapViewDelegate>
@end

@implementation MCRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.crosshairView.hidden = YES;
    
    MKMapCamera *camera = [self.mapView.camera copy];
    camera.altitude = 1200000.;
    camera.centerCoordinate = CLLocationCoordinate2DMake(52.389894, 4.890826);
    [self.mapView setCamera:camera animated:NO];
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    self.crosshairView.hidden = NO;
    self.countryLabel.text = nil;
    [self.mapView removeOverlays:self.mapView.overlays];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.crosshairView.hidden = YES;
    [self.activityIndicator startAnimating];
    
    @weakify(self);
    [[self.presenter.searchCountryCommand execute:[_mapView.camera copy]] subscribeNext:^(MCCountryViewModel *viewModel) {
        @strongify(self);
        [self.activityIndicator stopAnimating];
        
        if (viewModel) {
            self.countryLabel.text = viewModel.name;
            
            if (viewModel.polygons.count) {
                [self.mapView addOverlays:viewModel.polygons level:MKOverlayLevelAboveLabels];
            }
        }
    }];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
    renderer.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.2];
    
    return renderer;
}

@end
