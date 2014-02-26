//
//  VideoCell.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 18-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *videoNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *showCoverButton;
@property (nonatomic, weak) IBOutlet UIButton *videoCoverButton;
@property (nonatomic, weak) IBOutlet UIImageView *showCoverImageView;
@property (nonatomic, weak) IBOutlet UIImageView *videoCoverImageView;

@end
