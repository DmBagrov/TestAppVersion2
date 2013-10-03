//
//  TASecondViewController.h
//  TestAppVer2
//
//  Created by Дмитрий Багров on 03.10.13.
//  Copyright (c) 2013 Ramotion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TADataModel.h"
#import "TAShotsViewController.h"

@interface TAFavoriteViewController: UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    TADataModel *dataObject;
}
@end
