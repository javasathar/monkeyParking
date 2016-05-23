//
//  MapCarViewController.h
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "ZKAnnotation.h"

@interface MapCarViewController : baseVC<
    MKMapViewDelegate,
    CLLocationManagerDelegate
>

@end
