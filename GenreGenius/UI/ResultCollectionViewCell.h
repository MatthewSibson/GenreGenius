//
//  ResultCollectionViewCell.h
//  GenreGenius
//
//  Created by Matthew Sibson on 12/11/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedEntry;
@class FeedDataProvider;

@interface ResultCollectionViewCell : UICollectionViewCell

/**
* Display a feed entry given a feed data provider from which to load an image to represent the feed entry.
*
* @param feedEntry A `FeedEntry` instance that this cell will represent.
* @param feedDataProvider A `FeedDataProvider` from which a representative image can be loaded.
*/
- (void)displayFeedEntry:(FeedEntry *)feedEntry fromFeedDataProvider:(FeedDataProvider *)feedDataProvider;

@end
