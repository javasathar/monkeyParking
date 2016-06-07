//
//  Data.m
//
//  Created by 科技－18 易停 on 16/6/3
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "ParkingSpaceModel.h"


NSString *const kDataRenttype = @"renttype";
NSString *const kDataId = @"id";
NSString *const kDataParkArea = @"parkArea";
NSString *const kDataParkId = @"parkId";
NSString *const kDataHascharge = @"hascharge";
NSString *const kDataParkGarageno = @"parkGarageno";
NSString *const kDataParkname = @"parkname";
NSString *const kDataRelieveTime = @"relieveTime";
NSString *const kDataAppointtype = @"appointtype";
NSString *const kDataParkingNo = @"parkingNo";
NSString *const kDataType = @"type";
NSString *const kDataParkFloor = @"parkFloor";
NSString *const kDataParkNo = @"parkNo";
NSString *const kDataRentplate = @"rentplate";
NSString *const kDataResult = @"result";
NSString *const kDataStatus = @"status";
NSString *const kDataCarplate = @"carplate";


@interface ParkingSpaceModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ParkingSpaceModel

@synthesize renttype = _renttype;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize parkArea = _parkArea;
@synthesize parkId = _parkId;
@synthesize hascharge = _hascharge;
@synthesize parkGarageno = _parkGarageno;
@synthesize parkname = _parkname;
@synthesize relieveTime = _relieveTime;
@synthesize appointtype = _appointtype;
@synthesize parkingNo = _parkingNo;
@synthesize type = _type;
@synthesize parkFloor = _parkFloor;
@synthesize parkNo = _parkNo;
@synthesize rentplate = _rentplate;
@synthesize result = _result;
@synthesize status = _status;
@synthesize carplate = _carplate;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.renttype = [[self objectOrNilForKey:kDataRenttype fromDictionary:dict] doubleValue];
        self.dataIdentifier = [self objectOrNilForKey:kDataId fromDictionary:dict];
        self.parkArea = [self objectOrNilForKey:kDataParkArea fromDictionary:dict];
        self.parkId = [self objectOrNilForKey:kDataParkId fromDictionary:dict];
        self.hascharge = [[self objectOrNilForKey:kDataHascharge fromDictionary:dict] doubleValue];
        self.parkGarageno = [self objectOrNilForKey:kDataParkGarageno fromDictionary:dict];
        self.parkname = [self objectOrNilForKey:kDataParkname fromDictionary:dict];
        self.relieveTime = [[self objectOrNilForKey:kDataRelieveTime fromDictionary:dict] doubleValue];
        self.appointtype = [[self objectOrNilForKey:kDataAppointtype fromDictionary:dict] doubleValue];
        self.parkingNo = [self objectOrNilForKey:kDataParkingNo fromDictionary:dict];
        self.type = [[self objectOrNilForKey:kDataType fromDictionary:dict] doubleValue];
        self.parkFloor = [[self objectOrNilForKey:kDataParkFloor fromDictionary:dict] doubleValue];
        self.parkNo = [self objectOrNilForKey:kDataParkNo fromDictionary:dict];
        self.rentplate = [self objectOrNilForKey:kDataRentplate fromDictionary:dict];
        self.result = [self objectOrNilForKey:kDataResult fromDictionary:dict];
        self.status = [[self objectOrNilForKey:kDataStatus fromDictionary:dict] doubleValue];
        self.carplate = [self objectOrNilForKey:kDataCarplate fromDictionary:dict];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.renttype] forKey:kDataRenttype];
    [mutableDict setValue:self.dataIdentifier forKey:kDataId];
    [mutableDict setValue:self.parkArea forKey:kDataParkArea];
    [mutableDict setValue:self.parkId forKey:kDataParkId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.hascharge] forKey:kDataHascharge];
    [mutableDict setValue:self.parkGarageno forKey:kDataParkGarageno];
    [mutableDict setValue:self.parkname forKey:kDataParkname];
    [mutableDict setValue:[NSNumber numberWithDouble:self.relieveTime] forKey:kDataRelieveTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.appointtype] forKey:kDataAppointtype];
    [mutableDict setValue:self.parkingNo forKey:kDataParkingNo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kDataType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.parkFloor] forKey:kDataParkFloor];
    [mutableDict setValue:self.parkNo forKey:kDataParkNo];
    [mutableDict setValue:self.rentplate forKey:kDataRentplate];
    [mutableDict setValue:self.result forKey:kDataResult];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kDataStatus];
    [mutableDict setValue:self.carplate forKey:kDataCarplate];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.renttype = [aDecoder decodeDoubleForKey:kDataRenttype];
    self.dataIdentifier = [aDecoder decodeObjectForKey:kDataId];
    self.parkArea = [aDecoder decodeObjectForKey:kDataParkArea];
    self.parkId = [aDecoder decodeObjectForKey:kDataParkId];
    self.hascharge = [aDecoder decodeDoubleForKey:kDataHascharge];
    self.parkGarageno = [aDecoder decodeObjectForKey:kDataParkGarageno];
    self.parkname = [aDecoder decodeObjectForKey:kDataParkname];
    self.relieveTime = [aDecoder decodeDoubleForKey:kDataRelieveTime];
    self.appointtype = [aDecoder decodeDoubleForKey:kDataAppointtype];
    self.parkingNo = [aDecoder decodeObjectForKey:kDataParkingNo];
    self.type = [aDecoder decodeDoubleForKey:kDataType];
    self.parkFloor = [aDecoder decodeDoubleForKey:kDataParkFloor];
    self.parkNo = [aDecoder decodeObjectForKey:kDataParkNo];
    self.rentplate = [aDecoder decodeObjectForKey:kDataRentplate];
    self.result = [aDecoder decodeObjectForKey:kDataResult];
    self.status = [aDecoder decodeDoubleForKey:kDataStatus];
    self.carplate = [aDecoder decodeObjectForKey:kDataCarplate];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeDouble:_renttype forKey:kDataRenttype];
    [aCoder encodeObject:_dataIdentifier forKey:kDataId];
    [aCoder encodeObject:_parkArea forKey:kDataParkArea];
    [aCoder encodeObject:_parkId forKey:kDataParkId];
    [aCoder encodeDouble:_hascharge forKey:kDataHascharge];
    [aCoder encodeObject:_parkGarageno forKey:kDataParkGarageno];
    [aCoder encodeObject:_parkname forKey:kDataParkname];
    [aCoder encodeDouble:_relieveTime forKey:kDataRelieveTime];
    [aCoder encodeDouble:_appointtype forKey:kDataAppointtype];
    [aCoder encodeObject:_parkingNo forKey:kDataParkingNo];
    [aCoder encodeDouble:_type forKey:kDataType];
    [aCoder encodeDouble:_parkFloor forKey:kDataParkFloor];
    [aCoder encodeObject:_parkNo forKey:kDataParkNo];
    [aCoder encodeObject:_rentplate forKey:kDataRentplate];
    [aCoder encodeObject:_result forKey:kDataResult];
    [aCoder encodeDouble:_status forKey:kDataStatus];
    [aCoder encodeObject:_carplate forKey:kDataCarplate];
}

- (id)copyWithZone:(NSZone *)zone
{
    ParkingSpaceModel *copy = [[ParkingSpaceModel alloc] init];
    
    if (copy) {
        
        copy.renttype = self.renttype;
        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.parkArea = [self.parkArea copyWithZone:zone];
        copy.parkId = [self.parkId copyWithZone:zone];
        copy.hascharge = self.hascharge;
        copy.parkGarageno = [self.parkGarageno copyWithZone:zone];
        copy.parkname = [self.parkname copyWithZone:zone];
        copy.relieveTime = self.relieveTime;
        copy.appointtype = self.appointtype;
        copy.parkingNo = [self.parkingNo copyWithZone:zone];
        copy.type = self.type;
        copy.parkFloor = self.parkFloor;
        copy.parkNo = [self.parkNo copyWithZone:zone];
        copy.rentplate = [self.rentplate copyWithZone:zone];
        copy.result = [self.result copyWithZone:zone];
        copy.status = self.status;
        copy.carplate = [self.carplate copyWithZone:zone];
    }
    
    return copy;
}


@end
