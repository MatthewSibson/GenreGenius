//
//  ResultsViewController.m
//  GenreGenius
//
//  Created by Matthew Sibson on 12/11/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import "ResultsViewController.h"
#import "FeedDataProvider.h"
#import "ResultCollectionViewCell.h"
#import "FeedData.h"
#import "FeedEntry.h"

@interface ResultsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) FeedDataProvider *feedDataProvider;
@property (nonatomic, assign) Genre displayedGenre;
@property (nonatomic, strong) NSArray *feedEntries;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Tell collection view to use our custom cell subclass for creating cells.
    [self.collectionView registerClass:[ResultCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    // Start a fetch of albums related to the requested genre, that was set before we appeared.
    [self fetchAlbumsFromGenre:self.displayedGenre];
}

- (void)displayResultsForGenre:(Genre)genre
{
    // View will never be loaded in this app when this is set, so store it for pick up later.
    self.displayedGenre = genre;
}

#pragma mark - Data Feed

- (FeedDataProvider *)feedDataProvider
{
    if (nil == _feedDataProvider) {
        _feedDataProvider = [[FeedDataProvider alloc] init];
    }

    return _feedDataProvider;
}

/**
* Fetches albums relevant to the passed genre and reloads the data shown by the collection view.
*
* On reload a cell is produced for each feed entry and the album image is loaded by the cell.
*
* @param genre `Genre` to search for albums in.
*/
- (void)fetchAlbumsFromGenre:(Genre)genre
{
    [self.feedDataProvider fetchTopAlbumsFromGenre:genre limit:15 onCompletion:^(FeedData *feedData, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (nil != error) {
                [self showError:error.localizedDescription];

                [self.navigationController popViewControllerAnimated:YES];
            } else {
                self.feedEntries = feedData.entries;

                [self.collectionView reloadData];
            }
        });
    }];
}

#pragma mark - Helper

/**
* Display generic error alert.
*
* @param error `NSString` for message to display.
*/
- (void)showError:(NSString *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.feedEntries count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Create a cell to display the feed entry, passing a feed data provider so that it can load an album image.
    //
    // I'd have liked to subclass UICollectionViewFlowLayout to animate in cells as images loaded instead of
    // having them all put in place here, but I'm short on time: Using initialLayoutAttributesForAppearingItemAtIndexPath:
    // to specify somewhere off screen and have the cells fly in as images were loaded.
    ResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    [cell displayFeedEntry:self.feedEntries[(NSUInteger)indexPath.item] fromFeedDataProvider:self.feedDataProvider];

    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
#if TARGET_IPHONE_SIMULATOR
    // Nothing we can do on simulator at this point since there is no iTunes store.
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"iTunes Store is not supported on the iOS simulator." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
#else
    // Once the user taps on an album link out to the iTunes store.
    FeedEntry *feedEntry = self.feedEntries[(NSUInteger)indexPath.item];

    [[UIApplication sharedApplication] openURL:feedEntry.link];
#endif
    
    // Just to make the demo easier, pop back to the initial screen so we can start over.
    [self.navigationController popViewControllerAnimated:YES];
}

@end
