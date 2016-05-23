//
//  FileData.h
//  EasyCar
//
//  Created by 易停科技－18 on 16/4/8.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileData : NSObject
//检查文件是否存在
-(BOOL)checkupFile:(NSString *)pathStr;
//返回map版本号
-(NSString *)checkupMapVersion;
//下载最新地图
-(void)updatedMap;
//返回当前WIFI地图数据
-(NSDictionary *)checkupMap;
//返回指定车库地图数据
-(NSDictionary *)checkupMapForMapName:(NSString *)mapName;
@end
