//
//  MovieDetailViewController.h
//  RottenTomatoes
//
//  Created by Miles Spielberg on 2/3/15.
//  Copyright (c) 2015 OrionNet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController
@property (strong, nonatomic) NSDictionary *movie;
@property (strong, nonatomic) UIImage *thumbnail;
@end
