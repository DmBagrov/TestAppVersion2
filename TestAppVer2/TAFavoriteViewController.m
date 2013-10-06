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
    //TAShotsViewController *shotsController = [self.tabBarController.childViewControllers objectAtIndex:0];
    dataObject = [TADataModel sharedObject];
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
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:cellID];
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
    
    //reload view
    [self.tableView reloadData];
    
}

 -(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //reload view - need to update after return
    [self.tableView reloadData];
}

//---------------------------------------

-(void)dealloc
{
    [dataObject release];
    [super dealloc];
}

@end
