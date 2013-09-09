//
//  SearchViewController.m
//  TrafficSearch
//
//  Created by Daniel Eggert on 08/09/2013.
//  Copyright (c) 2013 objc.io. All rights reserved.
//

#import "SearchViewController.h"

#import "StopSearch.h"
#import "AppDelegate.h"
#import "TimeIntervalFormatter.h"



@import CoreLocation;



@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timePerSearchLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchesPerSecondLabel;
@property (nonatomic, strong) TimeIntervalFormatter *timeIntervalFormatter;
@property (nonatomic, strong) NSNumberFormatter *searchesPerSecondFormatter;
@property (nonatomic, copy) NSArray *names;

@end




@implementation SearchViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.timeIntervalFormatter = [[TimeIntervalFormatter alloc] init];
    self.searchesPerSecondFormatter = [[NSNumberFormatter alloc] init];
    self.searchesPerSecondFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.searchesPerSecondFormatter.maximumFractionDigits = 0;
    
    self.names = @[@"U Görli", @"Jüterboger Str", @"Jüdisches Museum", @"Spandauer Damm", @"Württembergallee", @"Hohenzollernring", @"Lüdenscheider Weg", @"Außenweg", @"Bismarckplatz", @"Museen", @"Steinstücken", @"U Wittenbergplatz", @"Göttinger", @"Rixdorfer", @"Goltzstr", @"Pfahlerstr", @"Maximiliankorso", @"S Hackescher", @"Simon-Dach-Str", @"Stadion Buschallee", @"Dorfstr", @"Marksburgstr", @"Beilsteiner", @"Rahnsdorfer", @"Spreestr", @"S Baumschulenweg", @"Wegedornstr", @"Velten", @"Mahlow", @"Petersdorf", @"Bützow", @"Birkenstr", @"Willy-Brandt-Haus", @"Goerdelerdamm", @"Dovebrücke",];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self startRandomLocationSearch];
    } else if (indexPath.row == 1) {
        [self startRandomLocationAndTimeSearch];
    } else if (indexPath.row == 2) {
        [self startNaiveStringSearch];
    } else if (indexPath.row == 3) {
        [self startStringSearch];
    }
}

- (void)startRandomLocationSearch;
{
    [self startSearchWithCount:1000 block:^{
        [self randomLocationSearch];
    }];
}

- (void)startRandomLocationAndTimeSearch;
{
    [self startSearchWithCount:30 block:^{
        [self randomLocationAndTimeSearch];
    }];
}

- (void)startNaiveStringSearch;
{
    [self startSearchWithCount:200 block:^{
        [self naiveStringSearch];
    }];
}

- (void)startStringSearch;
{
    [self startSearchWithCount:200 block:^{
        [self stringSearch];
    }];
}

- (void)startSearchWithCount:(int)count block:(dispatch_block_t)block;
{
    NSTimeInterval const start = [NSDate timeIntervalSinceReferenceDate];
    for (int i = 0; i < count; ++i) {
        block();
    };
    [[AppDelegate sharedDelegate].managedObjectContext performBlock:^{
        NSTimeInterval const end = [NSDate timeIntervalSinceReferenceDate];
        NSTimeInterval const timeInterval = (end - start) / count;
        
        self.timePerSearchLabel.text = [self.timeIntervalFormatter stringForObjectValue:@(timeInterval)];
        self.searchesPerSecondLabel.text = [self.searchesPerSecondFormatter stringFromNumber:@(1. / timeInterval)];
    }];
}

static double randomUnity(void)
{
    return (arc4random() / 2147483647.5) - 1;
}

- (void)randomLocationSearch;
{
    CLLocationDegrees latitude = 52.5221280;
    CLLocationDegrees longitude = 13.4146610;
    
    latitude += 0.15 * randomUnity();
    longitude += 0.1 * randomUnity();
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    StopSearch *search = [StopSearch stopSearchAtLocation:location timeOfDay:nil];
    
    __weak SearchViewController *weakSelf = self;
    NSManagedObjectContext *moc = [AppDelegate sharedDelegate].managedObjectContext;
    [search executeSearchInManagedObjectContext:moc completionHandler:^{
        // We're just discarding the result.
        SearchViewController *searchViewController = weakSelf;
        (void) searchViewController;
    }];
}

- (void)randomLocationAndTimeSearch;
{
    CLLocationDegrees latitude = 52.5221280;
    CLLocationDegrees longitude = 13.4146610;
    
    latitude += 0.15 * randomUnity();
    longitude += 0.1 * randomUnity();
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    NSDateComponents *timeOfDay = [[NSDateComponents alloc] init];
    timeOfDay.hour = arc4random_uniform(24);
    timeOfDay.minute = arc4random_uniform(60);
    timeOfDay.second = arc4random_uniform(60);
    StopSearch *search = [StopSearch stopSearchAtLocation:location timeOfDay:timeOfDay];
    
    __weak SearchViewController *weakSelf = self;
    NSManagedObjectContext *moc = [AppDelegate sharedDelegate].managedObjectContext;
    [search executeSearchInManagedObjectContext:moc completionHandler:^{
        // We're just discarding the result.
        SearchViewController *searchViewController = weakSelf;
        (void) searchViewController;
    }];
}

- (void)naiveStringSearch;
{
    NSString *name = self.names[arc4random_uniform([self.names count])];
    StopSearch *search = [StopSearch naiveStopSearchWithString:name];
    
    __weak SearchViewController *weakSelf = self;
    NSManagedObjectContext *moc = [AppDelegate sharedDelegate].managedObjectContext;
    [search executeSearchInManagedObjectContext:moc completionHandler:^{
        // We're just discarding the result.
        SearchViewController *searchViewController = weakSelf;
        (void) searchViewController;
    }];
}

- (void)stringSearch;
{
    NSString *name = self.names[arc4random_uniform([self.names count])];
    StopSearch *search = [StopSearch stopSearchWithString:name];
    
    __weak SearchViewController *weakSelf = self;
    NSManagedObjectContext *moc = [AppDelegate sharedDelegate].managedObjectContext;
    [search executeSearchInManagedObjectContext:moc completionHandler:^{
        // We're just discarding the result.
        SearchViewController *searchViewController = weakSelf;
        (void) searchViewController;
    }];
}

@end
