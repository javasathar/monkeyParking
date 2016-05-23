//
//  FileData.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/4/8.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "FileData.h"
#import <UIImageView+WebCache.h>
@implementation FileData
#pragma mark 检查文件是否存在
-(BOOL)checkupFile:(NSString *)pathStr
{
    if (!pathStr) {
        return NO;
    }
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    path = [path stringByAppendingPathComponent:pathStr];
    NSLog(@"path:%@",path);
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}
#pragma mark 返回map版本号
-(NSString *)checkupMapVersion
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    path = [path stringByAppendingPathComponent:@"map.json"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
        NSLog(@"当前地图版本号：%@",dic[@"version"]);
        return dic[@"version"];

    }
    return @"0";

}
#pragma mark 下载最新地图
-(void)updatedMap
{
    NSString *urlStr = [APP_APIHOST stringByAppendingString:@"map.json"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        path = [path stringByAppendingPathComponent:@"map.json"];
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"mapJson:%@",dic);
        if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
        [dic writeToFile:path atomically:YES];
        [self downloadMapImage:dic];
        NSLog(@"updated map success");
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"updated map failed");
    }];
}
#pragma mark 下载地图图片
-(void)downloadMapImage:(NSDictionary *)dic
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    for (NSDictionary *dict in dic[@"allMap"]) {
        NSString *imageUrl = dict[@"imageUrl"];
        NSString *imagePath = [path stringByAppendingPathComponent:dict[@"imageName"]];
//        NSLog(@"%@",imageUrl);
        [manager downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (finished) {
                if ([[NSFileManager defaultManager]fileExistsAtPath:imagePath]) {
                    if ([[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil]) {
//                        NSLog(@"remove success :%@",imagePath);

                    }else
                    {
//                        NSLog(@"remove failed :%@",imagePath);

                    }
                }
                [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
                NSLog(@"%@",dict[@"imageName"]);
            }
        }];
    }
}
#pragma mark 返回当前WIFI地图数据
-(NSDictionary *)checkupMap
{
    NSDictionary* _wifi = [[CGTool shareInitial]fetchSSIDInfo];
//    NSLog(@"%@",_wifi);
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    path = [path stringByAppendingPathComponent:@"map.json"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
//        NSLog(@"%@",dic);
        for (NSDictionary *dict in dic[@"allMap"]) {
            if ([_wifi[@"BSSID"] isEqualToString:dict[@"wifiMac"]]) {
                return dict;
            }
        }
        
    }
    return nil;
}
#pragma mark 返回指定车库地图数据
-(NSDictionary *)checkupMapForMapName:(NSString *)mapName
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    path = [path stringByAppendingPathComponent:@"map.json"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
        //        NSLog(@"%@",dic);
        for (NSDictionary *dict in dic[@"allMap"]) {
            if ([mapName isEqualToString:dict[@"parkName"]]) {
                return dict;
            }
        }
        
    }
    return nil;
}
@end
