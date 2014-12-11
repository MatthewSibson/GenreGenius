//
//  FeedData.m
//  GenreGenius
//
//  Created by Matthew Sibson on 12/9/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import "FeedData.h"
#import "FeedEntry.h"

@implementation FeedData

+ (instancetype)feedDataWithDictionary:(NSDictionary *)dictionary
{
    FeedData *feedData = [[FeedData alloc] init];

    [feedData setValuesForKeysWithDictionary:dictionary[@"feed"]];

    return feedData;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    NSArray *ignoredKeys = @[
        @"author", @"updated", @"rights", @"title", @"icon", @"link", @"id"
    ];

    if ([ignoredKeys containsObject:key]) {
        // NOOP: In the interest of brevity here, ignore keys we don't need.
    } else if ([key isEqualToString:@"entry"]) {
        [self setEntriesWithValue:value];
    } else {
        [super setValue:value forKey:key];
    }
}

/**
* Take service array of dictionaries and transform into `FeedEntry` objects.
*
* @param value `NSArray` of `NSDictionary` objects from the service.
*/
- (void)setEntriesWithValue:(NSArray *)value
{
    NSMutableArray *feedEntries = [NSMutableArray arrayWithCapacity:[value count]];

    for (NSDictionary *entry in value) {
        FeedEntry *feedEntry = [FeedEntry feedEntryWithDictionary:entry];
        [feedEntries addObject:feedEntry];
    }

    self.entries = feedEntries;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString string];

    [description appendFormat:@"<FeedData %x: entries=[\n", (unsigned int)self];

    for (FeedEntry *entry in self.entries) {
        [description appendFormat:@"\t%@\n", entry];
    }

    [description appendString:@"]>"];

    return description;
}

@end
