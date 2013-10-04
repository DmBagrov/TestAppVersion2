//
//  TASecondViewController.m
//  TestAppVer2
//
//  Created by Дмитрий Багров on 03.10.13.
//  Copyright (c) 2013 Ramotion. All rights reserved.
//

#import "TAFavoriteViewController.h"

@interface TAFavoriteViewController ()

@end

@implementation TAFavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Favorite", @"Favorite");
        self.tabBarItem.image = [UIImage imageNamed:@"favorite.png"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //get link of model object 
    TAShotsViewController *shotsController = [self.tabBarController.childViewControllers objectAtIndex:0];
    dataObject = [[shotsController dataObject] retain];
    //

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%d",dataObject.favariteCount);
    return dataObject.favariteCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = [NSString stringWithFormat:@"%d",indexPath.row];
    //NSLog(cellID);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:cellID] init];
    }
    cell.imageView.image = [dataObject getFavoriteListImageByIndex:indexPath.row];
    cell.textLabel.text = [dataObject getFavoriteListItemNameByIndex:indexPath.row];
    
    //add and catomize button
    UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteButton.frame = CGRectMake(250.0, 5.0, 60.0, 60.0);
    [cell addSubview:favoriteButton];
    //
    //add tag of the image
    favoriteButton.tag = [dataObject getFavoriteIndexInShotsListByIndexInArray:indexPath.row];
    
    //add action listener to button
    [favoriteButton addTarget:self action:@selector(favoriteButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    [favoriteButton setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    
    return cell;
}

-(IBAction)favoriteButtonPressed:(id)sender
{
    //add image to favorite list
    NSString *tappedImage = [NSString stringWithFormat:@"%d",[sender tag]];
    
    [dataObject deleteItemFromFavoriteList:tappedImage];
    [sender setImage:[UIImage imageNamed:@"unfavorite.png"] forState:UIControlStateNormal];
    
}

//need to reworked----------------------

-(void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"updated");
    [super viewWillAppear:animated];
    
    //[NSThread detachNewThreadSelector:@selector(threadRun) toTarget:self withObject:nil];
    NSOperationQueue *queue = [NSOperationQueue new]; //autorelease
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(updateFavListRender) object:nil];
    [queue addOperation:operation];
    [operation release];
    //
}

-(void) updateFavListRender
{
    while (YES)
    {
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        [NSThread sleepForTimeInterval:0.1];
    }
}

//---------------------------------------

-(void)dealloc
{
    [dataObject release];
    [super dealloc];
}

@end
