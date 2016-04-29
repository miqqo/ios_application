//
//  CollectionViewController.m
//  FrostMobileTest
//
//  Created by Mikaela Koller on 2016-04-28.
//  Copyright © 2016 Mikaela Koller. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"

@interface CollectionViewController ()
@property (nonatomic) NSMutableArray *puffs;
@property (nonatomic, strong) NSMutableDictionary *jsonDictionary;



#define GREEN [UIColor colorWithRed:62.0/255 green:171.0/255 blue:150.0/255 alpha:1.0]
#define CREAMWHITE [UIColor colorWithRed:254.0/255 green:249.0/255 blue:224.0/255 alpha:1.0]


@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self readFromJson];
    
    self.navigationController.navigationBar.barTintColor = GREEN;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:CREAMWHITE}];
    
   // self.webView.hidden = YES;

    
}


-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
   

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) readFromJson{
    NSURL *URL = [NSURL URLWithString:@"http://fake-api.frostcloud.se/api"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if(error == nil)
                                      {
                                          self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          
                                          self.puffs = [self.jsonDictionary objectForKey:@"puffs"];
                                          NSLog(@"puffs = %@",self.jsonDictionary[@"puffs"]);
                                      }
                                  }];
    
    [task resume];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *buttonText = [[self.puffs objectAtIndex:indexPath.row] objectForKey:@"buttonText"];
    [cell.button setTitle:buttonText forState:UIControlStateNormal];
    [cell.button setTintColor:CREAMWHITE];
    
    NSString *path = [[self.puffs objectAtIndex:indexPath.row] objectForKey:@"image"];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    cell.image.image = image;
    cell.backgroundColor = GREEN;
    
    cell.button.tag = indexPath.row;
    [cell.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];


    
    return cell;
}

-(void)buttonClicked:(UIButton*)sender
{
    //open url in webview

    NSString *currentUrlString = [[self.puffs objectAtIndex:sender.tag] objectForKey:@"url"];
    NSURL *url = [NSURL URLWithString:currentUrlString];
  //  [self setUpWebView:url];
        
}

-(void)setUpWebView:(NSURL*)url
{
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
   // [self.webView loadRequest:requestObj];
    
  //  self.webView.hidden = YES;
}



#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/



@end
