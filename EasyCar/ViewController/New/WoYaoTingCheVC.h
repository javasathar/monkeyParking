//
//  WoYaoTingCheVC.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/26.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface WoYaoTingCheVC : baseVC

@property (nonatomic,assign) CLLocationCoordinate2D selectedCoordinate;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,assign) NSInteger pageNo;

@property (nonatomic ) NSInteger mapType;
@property (nonatomic ,strong) NSString *selectPark;
@property (nonatomic ,strong) UIViewController *lastVC;
- (void)startNavigate;
- (void)stopCarAction;
- (void)carZhengZu;
- (void)controlParking;

- (void)requestParkListWithCoordinate:(CLLocationCoordinate2D)coordinate page:(NSInteger)page tableView:(UITableView *)tableView;
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view;
@end
