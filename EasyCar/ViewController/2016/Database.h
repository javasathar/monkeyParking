//
//  Database.h
//  EasyCar
//
//  Created by 易停科技－18 on 16/3/16.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
@interface Database : NSObject
+(Database*)shareDatabase;
-(void)insertIntoData:(NSArray*)arr;
-(BOOL)isExistsOfData;
-(NSMutableArray *)getAllData;
@end
