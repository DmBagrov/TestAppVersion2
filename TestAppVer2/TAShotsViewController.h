//
//  TAFirstViewController.h
//  TestAppVer2
//
//  Created by Дмитрий Багров on 03.10.13.
//  Copyright (c) 2013 Ramotion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TADataModel.h"

@interface TAShotsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{

}
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *imageCachingIndicator;

@property (retain) TADataModel *dataObject;

@end
