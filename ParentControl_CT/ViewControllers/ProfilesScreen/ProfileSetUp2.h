//
//  ProfileSetUp2.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 25/02/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileSetUp2.h"
#import "PC_DataManager.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PPPinPadViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "UrlConnection.h"
#import "CityTableViewController.h"
#import "CountryTableViewController.h"
#import "ShowActivityLoadingView.h"
#import "CustomToolBar.h"
#import "Constant.h"
#import "UpdateLocationByParentID.h"

@interface ProfileSetUp2 : UIViewController<UITextFieldDelegate,MKMapViewDelegate,CLLocationManagerDelegate,PinPadPassProtocol,GMSIndoorDisplayDelegate,GMSMapViewDelegate,UISearchBarDelegate,UISearchControllerDelegate, NSURLConnectionDataDelegate,NSURLConnectionDelegate,UITableViewDataSource,UITableViewDelegate,UrlConnectionDelegate, CityListDelegate, CountryListDelegate,CustomToolBarDelegate,FeaturedProtocol>
{
    NSURLConnection *mapConnection;
    NSMutableData *mapConnectionData;
}
@property  GMSMapView *mapView;
@property (nonatomic,retain)CLLocationManager *locationManager;
@property (nonatomic, retain) NSString *input;
@property (nonatomic) BOOL sensor;
@property (nonatomic, retain) NSString *key;

#pragma mark -
#pragma mark Optional parameters

@property (nonatomic) NSUInteger offset;

@property (nonatomic) CLLocationCoordinate2D location;

@property (nonatomic) CGFloat radius;

@property (nonatomic, retain) NSString *language;
@property NSString *parentClassName;
@property ParentProfileObject *parentObject;

@end
