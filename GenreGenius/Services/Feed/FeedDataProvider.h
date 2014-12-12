//
//  FeedDataProvider.h
//  GenreGenius
//
//  Created by Matthew Sibson on 12/9/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Genre.h"

@class FeedData;
@class FeedEntry;

/** A block that takes `FeedData` and `NSError` to handle the results of a fetch. */
typedef void (^FeedDataProviderResult)(FeedData *feedData, NSError *error);

@interface FeedDataProvider : NSObject

#pragma mark - Fetches

/**
* Convenience method to fetch top albums across all genres.
*
* @param limit `NSUInteger` maximum number of results to request.
* @param block `FeedDataProviderResult` block to handle data fetched.
*/
- (void)fetchTopAlbumsLimit:(NSUInteger)limit onCompletion:(FeedDataProviderResult)block;

/**
* Fetch top albums in a given genre with maximum number of results.
*
* @param genre A genre specified by the `Genre` enumeration.
* @param limit `NSUInteger` maximum number of results to request.
* @param block `FeedDataProviderResult` block to handle data fetched.
*/
- (void)fetchTopAlbumsFromGenre:(Genre)genre limit:(NSUInteger)limit onCompletion:(FeedDataProviderResult)block;

/**
* Fetch representative image for entry at given size.
*
* @param feedEntry `FeedEntry` object for which to obtain the image.
* @param size One of `FeedEntryImageSizeSmall`, `FeedEntryImageSizeMediuml` or `FeedEntryImageSizeLarge`.
* @param block Block that takes the fetched image and any error that occurred.
*/
- (void)fetchImageForFeedEntry:(FeedEntry *)feedEntry size:(NSString *)size onCompletion:(void (^)(UIImage *image, NSError *error))block;

@end
