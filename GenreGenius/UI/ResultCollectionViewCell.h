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

- (void)displayFeedEntry:(FeedEntry *)feedEntry fromFeedDataProvider:(FeedDataProvider *)feedDataProvider;

@end
