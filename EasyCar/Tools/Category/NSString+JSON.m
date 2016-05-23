//
//  NSString+JSON.m
//  Microteam
//
//  Created by Sandy on 15/3/4.
//  Copyright (c) 2015年 vsteam. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

+(NSString *) jsonStringWithString:(NSString *) string{
    
        return [NSString stringWithFormat:@"%@",
                [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\\\""withString:@"\""]
                ];
}

+(NSString *) jsonBracketWithString:(NSString *) string {
    
    return [NSString stringWithFormat:@"%@",
            [[string stringByReplacingOccurrencesOfString:@")" withString:@"]"] stringByReplacingOccurrencesOfString:@"(" withString:@"["]
            ];
}

+(NSString *) jsonSemicolonWithString:(NSString *) string {

    return [NSString stringWithFormat:@"%@",
            [string stringByReplacingOccurrencesOfString:@";" withString:@","]
            ];
}

+(NSString *) jsonEqualWithString:(NSString *) string {
    
    return [NSString stringWithFormat:@"%@",
            [string stringByReplacingOccurrencesOfString:@"=" withString:@":"]
            ];
}

+ (NSString *) jsonEqualWithStringByRed:(NSString *) string {
    
    return [NSString stringWithFormat:@"%@",
            [string stringByReplacingOccurrencesOfString:@"\"" withString:@""]
            ];
    
}

+(NSString *) jsonStringWithArray:(NSArray *)array{
    
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

+(NSString *) jsonStringWithObject:(id) object{

    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }
    return value;
}

@end