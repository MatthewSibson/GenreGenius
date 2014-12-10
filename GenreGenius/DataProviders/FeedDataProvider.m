//
//  FeedDataProvider.m
//  GenreGenius
//
//  Created by Matthew Sibson on 12/9/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import "FeedDataProvider.h"
#import "FeedData.h"

@interface FeedDataProvider ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation FeedDataProvider

- (instancetype)init
{
    if (self = [super init]) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }

    return self;
}

#pragma mark - Fetches

- (void)fetchTopAlbumsLimit:(NSUInteger)limit
{
    [self fetchTopAlbumsFromGenre:GenreAll limit:limit];
}

- (void)fetchTopAlbumsFromGenre:(Genre)genre limit:(NSUInteger)limit
{
    NSURL *URL = [self URLForTopAlbumsInGenre:genre limit:limit];

    NSURLSessionDataTask *task = [self.session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        FeedData *feedData = [FeedData feedDataWithDictionary:dictionary];

        NSLog(@"%@", feedData);
    }];

    [task resume];
}

#pragma mark - Helpers

/**
* Build URL for top albums in a given genre with a limit on returned results.
*
* @param genre A genre specified by the `Genre` enumeration.
* @param limit `NSUInteger` maximum number of results to request.
*
* @return `NSURL` for specified feed.
*/
- (NSURL *)URLForTopAlbumsInGenre:(Genre)genre limit:(NSUInteger)limit
{
    // Hard code to US top albums for now.
    NSMutableString *path = [@"/us/rss/topalbums" mutableCopy];

    // Limit the results given back to a fixed number.
    [path appendFormat:@"/limit=%lu", (unsigned long)limit];

    // Leaving out the genre predicate returns overall summary for all genres.
    if (genre != GenreAll) {
        [path appendFormat:@"/genre=%lu", (unsigned long)genre];
    }

    // JSON format please.
    [path appendFormat:@"/json"];

    return [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:@"https://itunes.apple.com"]];
}

@end
