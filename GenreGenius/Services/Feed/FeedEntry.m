//
// Created by Matthew Sibson on 12/9/14.
// Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import "FeedEntry.h"

NSString * const FeedEntryImageSizeSmall = @"55";
NSString * const FeedEntryImageSizeMedium = @"60";
NSString * const FeedEntryImageSizeLarge = @"170";

@implementation FeedEntry {

}

+ (instancetype)feedEntryWithDictionary:(NSDictionary *)dictionary
{
    FeedEntry *feedEntry = [[FeedEntry alloc] init];

    [feedEntry setValuesForKeysWithDictionary:dictionary];

    return feedEntry;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    NSArray *ignoredKeys = @[
            @"im:itemCount", @"im:price", @"im:contentType", @"rights", @"title",
            @"id", @"category", @"im:releaseDate", @"link"
    ];

    if ([ignoredKeys containsObject:key]) {
        // NOOP: In the interest of brevity here, ignore keys we don't need.
    } else if ([key isEqualToString:@"im:name"]) {
        self.name = value[@"label"];
    } else if ([key isEqualToString:@"im:artist"]) {
        self.artist = value[@"label"];
    } else if ([key isEqualToString:@"im:image"]) {
        [self setImagesWithValue:value];
    } else {
        [super setValue:value forKey:key];
    }
}

/**
* Take service array of dictionaries and transform into lookup from image size to URL.
*
* @param value `NSArray` of `NSDictionary` objects from the service.
*/
- (void)setImagesWithValue:(NSArray *)value
{
    NSMutableDictionary *images = [NSMutableDictionary dictionaryWithCapacity:[value count]];

    for (NSDictionary *dictionary in value) {
        images[dictionary[@"attributes"][@"height"]] = [NSURL URLWithString:dictionary[@"label"]];
    }

    self.images = images;
}

- (NSURL *)URLForImageWithSize:(NSString *)size
{
    return self.images[size];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<FeedEntry: %x: name=%@; artist=%@>", (unsigned int)self, self.name, self.artist];
}

@end