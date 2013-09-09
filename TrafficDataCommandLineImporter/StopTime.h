//
//  StopTime.h
//  TrafficDataCommandLineImporter
//
//  Created by Florian on 17.08.13.
//  Copyright (c) 2013 Florian. All rights reserved.
//

#import "ManagedObject.h"

@class Stop;

typedef enum PickupType : int16_t {
    RegularlyScheduledPickup = 0,
    NoPickupAvailable,
    MustPhoneAgencyToArrangePickup,
    MustCoordinateWithDriverToArrangePickup,
} PickupType;

typedef enum DropOffType : int16_t {
    RegularlyScheduledDropOff,
    NoDropOffAvailable,
    MustPhoneAgencyToArrangeDropOff,
    MustCoordinateWithDriverToArrangeDropOff,
} DropOffType;




@interface StopTime : ManagedObject

@property (nonatomic, strong) NSDate *arrivalTime;
@property (nonatomic, strong) NSDate *departureTime;
@property (nonatomic, strong) Stop *stop;
@property (nonatomic) PickupType pickupType;
@property (nonatomic) DropOffType dropOffType;

@end
