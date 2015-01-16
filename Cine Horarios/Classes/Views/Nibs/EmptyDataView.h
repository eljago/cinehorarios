//
//  EmptyDataView.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 14-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyDataView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *labelButtonReload;
@property (nonatomic, weak) IBOutlet UILabel *labelButtonGoWebPage;
@property (nonatomic, weak) IBOutlet UIButton *buttonReload;
@property (nonatomic, weak) IBOutlet UIButton *buttonGoWebPage;

@end
