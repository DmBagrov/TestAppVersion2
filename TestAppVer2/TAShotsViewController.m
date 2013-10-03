//
//  TAFirstViewController.m
//  TestAppVer2
//
//  Created by Дмитрий Багров on 03.10.13.
//  Copyright (c) 2013 Ramotion. All rights reserved.
//

#import "TAShotsViewController.h"

@interface TAShotsViewController ()

@end

@implementation TAShotsViewController

@synthesize dataObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Shots", @"Shots");
        self.tabBarItem.image = [UIImage imageNamed:@"shots.png"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //create model object
    dataObject = [[TADataModel alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//draw table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataObject.shotsCount;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    cell.imageView.image = [dataObject getImageByIndex:indexPath.row];
    cell.textLabel.text = [dataObject getItemNameByIndex:indexPath.row];
    
    //add and catomize button
    UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteButton.frame = CGRectMake(250.0, 5.0, 60.0, 60.0);
    [cell addSubview:favoriteButton];
    //
    //add tag of the image
    favoriteButton.tag = indexPath.row;
    
    //add action listener to button
    [favoriteButton addTarget:self action:@selector(favoriteButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    
    //check - this image is added favorite list.
    if([dataObject isItemInFavoriteList:cellID])
    {
        [favoriteButton setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    }
    else
    {
        [favoriteButton setImage:[UIImage imageNamed:@"unfavorite.png"] forState:UIControlStateNormal];
    }
    
    return cell;
}
//

-(IBAction)favoriteButtonPressed:(id)sender
{
    //add image to favorite list
    NSString *tappedImage = [NSString stringWithFormat:@"%d",[sender tag]];
    if([dataObject isItemInFavoriteList:tappedImage])
    {
        [dataObject deleteItemFromFavoriteList:tappedImage];
        //and make icon grey
        [sender setImage:[UIImage imageNamed:@"unfavorite.png"] forState:UIControlStateNormal];
    }
    else
    {
        [dataObject addNewItemToFavoriteList:tappedImage];
        [sender setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
        
    }
    
}

//need reworked
-(void) threadRun
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        [self performSelectorOnMainThread:@selector(updateTable) withObject:nil waitUntilDone:false];
        [NSThread sleepForTimeInterval:0.2];
        //NSLog(@"Multi-threaded after? %@", [NSThread isMultiThreaded] ? @"Yes" : @"No");
    
    [pool release];
}

-(void)updateTable
{
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"updated");
    [super viewWillAppear:animated];
    
    [NSThread detachNewThreadSelector:@selector(threadRun) toTarget:self withObject:nil];
}
//


@end
