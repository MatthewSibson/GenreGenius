//
//  TransitionAnimator.m
//  GenreGenius
//
//  Created by Matthew Sibson on 12/11/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import "TransitionAnimator.h"

@implementation TransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Obtain the view controllers involved in the transition.
    UIViewController *s = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *d = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    // Get the container and set a transform on the layer to apply to the coordinates of sublayers
    // so that the apparent scale of layers change as the move in Z.
    UIView *container = [transitionContext containerView];

    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0f / 200.0f;
    container.layer.sublayerTransform = perspective;

    [container addSubview:d.view];

    // The animation itself, which consists of the existing view falling away and fading out
    // and the new view fading in and appearing to fall from "behind" the screen and into place
    [CATransaction begin];
    [CATransaction setAnimationDuration:[self transitionDuration:transitionContext]];

    // Set completion block to signal when the animations end and the transition is completed.
    [CATransaction setCompletionBlock:^{
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];

    // Source or "from" fades out and drops away.
    CABasicAnimation *sOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    sOpacity.fromValue = @(1.0f);
    sOpacity.toValue = @(0.0f);
    [s.view.layer addAnimation:sOpacity forKey:@"opacity"];

    CABasicAnimation *sZoom = [CABasicAnimation animationWithKeyPath:@"zPosition"];
    sZoom.fromValue = @(0.0f);
    sZoom.toValue = @(-300.0f);
    [s.view.layer addAnimation:sZoom forKey:@"zPosition"];

    // Destination or "to" fades in and drops in.
    CABasicAnimation *dOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    dOpacity.fromValue = @(0.0f);
    dOpacity.toValue = @(1.0f);
    [d.view.layer addAnimation:dOpacity forKey:@"opacity"];

    CABasicAnimation *dZoom = [CABasicAnimation animationWithKeyPath:@"zPosition"];
    dZoom.fromValue = @(300.0f);
    dZoom.toValue = @(0.0f);
    [d.view.layer addAnimation:dZoom forKey:@"zPosition"];

    [CATransaction commit];
}

@end
