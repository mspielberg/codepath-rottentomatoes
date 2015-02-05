//
//  MovieCell.m
//  RottenTomatoes
//
//  Created by Miles Spielberg on 2/2/15.
//  Copyright (c) 2015 OrionNet. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    // Initialization code
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.2 green:0.0 blue:0.0 alpha:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
