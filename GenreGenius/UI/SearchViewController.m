//
//  SearchViewController.m
//  GenreGenius
//
//  Created by Matthew Sibson on 12/9/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import "SearchViewController.h"
#import "FeedDataProvider.h"
#import "FeedData.h"
#import "FeedEntry.h"
#import "SearchService.h"
#import "ResultsViewController.h"

@interface SearchViewController () <UITextFieldDelegate>

@property (nonatomic, strong) FeedDataProvider *feedDataProvider;
@property (nonatomic, strong) SearchService *searchService;

@property (nonatomic, weak) IBOutlet UIView *emitterContainer;
@property (nonatomic, weak) CAEmitterLayer *emitterLayer;

@property (nonatomic, weak) IBOutlet UIView *fieldContainer;

@end

@implementation SearchViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Add star field emitter.
    [self setupEmitter];

    // Add perspective for Z axis.
    [self setupPerspective];

    // Style and setup initial field state ready for first appearance.
    [self setupField];

    // Kick off fetch of data feed.
    [self fetchStarFieldFeed];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    CABasicAnimation *zAnimation = [CABasicAnimation animationWithKeyPath:@"zPosition"];

    zAnimation.fromValue = @(-500.0f);
    zAnimation.toValue = @(0.0f);

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];

    opacityAnimation.fromValue = @(0.0f);
    opacityAnimation.toValue = @(1.0f);

    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];

    animationGroup.animations = @[
            zAnimation,
            opacityAnimation
    ];

    animationGroup.duration = 1.0;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    [self.fieldContainer.layer addAnimation:animationGroup forKey:@"animationGroup"];

    self.fieldContainer.layer.zPosition = 0.0f;
    self.fieldContainer.layer.opacity = 1.0f;
}

#pragma mark - Setup

- (void)setupPerspective
{
    // Set the perspective of the top layer so moving in Z affects the apparent scale of the sublayers.
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0f / 200.0f;
    self.view.layer.sublayerTransform = perspective;
}

- (void)setupEmitter
{
    // Create emitter layer for album star field.
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];

    // Position emitter layer in middle of container as a point source set back from the viewer in Z.
    emitterLayer.position = CGPointMake(CGRectGetMidX(self.emitterContainer.bounds), CGRectGetMidY(self.emitterContainer.bounds));
    emitterLayer.emitterMode = kCAEmitterLayerPoint;
    emitterLayer.emitterShape = kCAEmitterLayerPoint;
    emitterLayer.emitterZPosition = -100.0f;

    // Add emitter layer to the container. The container ensures that the emitter will
    // stay centered on the screen by taking advantage of autolayout.
    [self.emitterContainer.layer addSublayer:emitterLayer];
    self.emitterLayer = emitterLayer;
}

- (void)setupField
{
    // Position field far away in Z, so we can fly the field in from the distance.
    self.fieldContainer.layer.zPosition = -500.0f;

    // And at full transparency, so the field materializes in space.
    self.fieldContainer.layer.opacity = 0.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper

- (void)showError:(NSString *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (nil != textField.text && ![textField.text isEqualToString:@""]) {
        [self searchForTerm:textField.text];
    }

    return YES;
}

#pragma mark - Data Feed

- (FeedDataProvider *)feedDataProvider
{
    if (nil == _feedDataProvider) {
        _feedDataProvider = [[FeedDataProvider alloc] init];
    }

    return _feedDataProvider;
}

- (void)fetchStarFieldFeed
{
    [self.feedDataProvider fetchTopAlbumsFromGenre:GenreAll limit:15 onCompletion:^(FeedData *feedData, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (nil != error) {
                [self showError:error.localizedDescription];
            } else {
                for (FeedEntry *feedEntry in feedData.entries) {
                    [self fetchAndDisplayStarFieldImageForFeedEntry:feedEntry];
                }
            }
        });
    }];
}

- (void)fetchAndDisplayStarFieldImageForFeedEntry:(FeedEntry *)feedEntry
{
    [self.feedDataProvider fetchImageForFeedEntry:feedEntry size:FeedEntryImageSizeMedium onCompletion:^(UIImage *image, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (nil != error) {
                [self showError:error.localizedDescription];
            } else {
                CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
                emitterCell.contents = (__bridge id)image.CGImage;

                emitterCell.emissionRange = (CGFloat)(2.0 * M_PI);
                emitterCell.birthRate = 1.0f;
                emitterCell.lifetime = 3.0f;
                emitterCell.lifetimeRange = 0.5f;

                emitterCell.velocity = 100.0f;

                // Cells should accelerate towards the viewer.
                emitterCell.zAcceleration = 1.0f;

                // Cells should gradually fade to black while moving nearer.
                emitterCell.blueSpeed = -0.3f;
                emitterCell.redSpeed = -0.3f;
                emitterCell.greenSpeed = -0.3f;

                // If this is the first cell create new array otherwise append to existing cells.
                if (nil == self.emitterLayer.emitterCells) {
                    self.emitterLayer.emitterCells = @[ emitterCell ];
                } else {
                    NSArray *emitterCells = self.emitterLayer.emitterCells;
                    self.emitterLayer.emitterCells = [emitterCells arrayByAddingObject:emitterCell];
                }
            }
        });
    }];
}

#pragma mark - Search Service

- (SearchService *)searchService
{
    if (nil == _searchService) {
        _searchService = [[SearchService alloc] init];
    }

    return _searchService;
}

- (void)searchForTerm:(NSString *)term
{
    [self.searchService searchGenreForTerm:term onCompletion:^(Genre genre, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (nil == error && genre != GenreInvalid) {
                ResultsViewController *viewController = [[ResultsViewController alloc] initWithNibName:nil bundle:nil];

                [viewController displayResultsForGenre:genre];

                [self.navigationController pushViewController:viewController animated:YES];
            } else {
                if (nil != error) {
                    [self showError:error.localizedDescription];
                } else {
                    [self showError:@"Invalid or mising genre."];
                }
            }
        });
    }];
}

@end
