//
//  ProfileSetUp2.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 25/02/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ProfileSetUp2.h"
#import "ChildProfileController.h"
#import "AddPassCode.h"
#import "CreateParentProfile.h"
#import "ParentViewProfile.h"
#import "LogoutView.h"
#import "NeighbourhoodRad.h"
#import "HeaderView.h"
#import "StripView.h"
#import "SplitTextController_VC.h"
@interface ProfileSetUp2 ()<neighbourProtocol,HeaderViewProtocol,UIAlertViewDelegate>

@end


@implementation ProfileSetUp2
{
    UILabel *titleLabel;
    UITextField *flatNo,*street,*city,*country,*neighbourText;

    //MKMapView *mapView;
   
    GMSPanoramaView *panoView;
    UITableView *searchTableView;
     UIImageView *navBgBar, *centerIcon;
    GMSMarker *marker;
    
    UIButton *continueBtn;
    
    UIScrollView *scrollView;
    UIButton *arrowImageCity,*arrowImageCountry;
    BOOL isKeyBoard;
    
    CGRect keyboardBounds;
    UIView *lineView;
    PPPinPadViewController *ppinViewController;
  
    
    UISearchBar * searchBar;
    
    BOOL isExpanded;
    //NSString *checkString;
    NSArray *filterData;
    NSMutableArray *actualData;
    NSString *checkString;
    BOOL isSearchActive;
    
    NSString *cityId;
    NSString *countryId;
    UIButton *cancelButton, *doneButton;
    
     ParentProfileEntity *parentProfileEntity;
   

    //CreateParentProfile *createParentProfile;
    ShowActivityLoadingView *loaderView;
    
    
    NSMutableArray *animateArray;
    
    UITextField *activeField;
    //float scrnHt,scrnWd;
    
    
    BOOL isParentAddition;
    
    LogoutView *logout;
    
    NSMutableDictionary *neighbourDict;
    
    
    
    HeaderView *headerView;
    int  yy ;
    NSString *googleAdd;
    NSString *neighbourHoodId;
    
}
@synthesize locationManager,mapView;
@synthesize input, sensor, key, offset, location, radius, language;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])self.edgesForExtendedLayout = UIRectEdgeNone;

    
    [[PC_DataManager sharedManager]getWidthHeight];
    [[PC_DataManager sharedManager]profileSetUp2];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    parentProfileEntity =[[PC_DataManager sharedManager]getParentEntity];
    [self.view setBackgroundColor:appBackgroundColor];
    [self drawHeaderView];
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = appBackgroundColor;
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    [scrollView setAutoresizesSubviews:YES];
    [scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
        scrollView.contentSize = CGSizeMake(screenHeight,screenHeight*2);
        // code for landscape orientation
    }
    else
    {
        scrollView.frame=CGRectMake(0,yy, screenWidth, screenHeight-yy);
        //scrollView.contentSize = CGSizeMake(screenWidth, screenHeight*1.1);
    }
    [self.view addSubview:scrollView];
    [self setUpView];

    
        animateArray=[[NSMutableArray alloc]init];
    // self.navigationController.navigationBar.topItem.title = @"";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
       [self addKeyBoardNotification];
 //   self.navigationItem.hidesBackButton = YES;
    checkString=@"";

    street.text= [PC_DataManager sharedManager].streettext;
    flatNo.text= [PC_DataManager sharedManager].flatText;
    
    if(flatNo.text.length==0)
    {
        flatNo.text= [PC_DataManager sharedManager].parentObjectInstance.flatBuilding;
    }
    else if([[PC_DataManager sharedManager].parentObjectInstance.flatBuilding isEqualToString:@"Not Added"])
    {
        flatNo.text=@"";
    }
    if(street.text.length==0)
    {
        street.text= [PC_DataManager sharedManager].parentObjectInstance.streetLocality;
    }
    else if([[PC_DataManager sharedManager].parentObjectInstance.streetLocality isEqualToString:@"Not Added"])
    {
        street.text=@"";
    }
    if(mapView)
    {
        [mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
        [self performSelector:@selector(parseString) withObject:nil afterDelay:5];
    }
  //  [mapView observeValueForKeyPath:@"myLocation" ofObject:NSKeyValueObservingOptionNew change:nil context:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
   // [self.navigationController setNavigationBarHidden:YES animated:animated];
  
    [mapView removeObserver:self
                 forKeyPath:@"myLocation"
                    context:NULL];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(parseString) object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   [self.navigationController setNavigationBarHidden:YES animated:NO];
    [centerIcon removeFromSuperview];
    
    centerIcon=nil;
}
-(void)viewDidUnload
{
    [super viewDidUnload];
    [[PC_DataManager sharedManager].serviceDictionary removeAllObjects];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)setUpView
{
    [self setTextFields];
    [self drawArrowCity];
    [self drawArrowCountry];
    [self moreIcon];
    [self fillData];
    
    isExpanded=NO;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap1:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [scrollView addGestureRecognizer:singleTap];
    
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"MapNotification"]isEqualToString:@"1"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"MapNotification"];
        UIAlertView *basicInfoAlert=[[UIAlertView alloc]initWithTitle:@"Location Set Up" message:@"Knowing your Location helps us send you more targetted information. You may choose not to share your exact address, but we do need to know your city and locality.\n\nYou also have the option to search and Select Neighbourhood  you are comfortable operating in and around your home or office for your children's activity.\n\nAllowing the app to access your location ensures we stay relevant with our information at all times. " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        basicInfoAlert.tag=1;
        [basicInfoAlert show];
    }
    else
    {
        [self mapIntegration];
        [self addSearchBarField];
        [mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
        [self performSelector:@selector(parseString) withObject:nil afterDelay:5];
    }

    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1)
    {
        if(!mapView)
        {
        [self mapIntegration];
        [self addSearchBarField];
        [mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
        [self performSelector:@selector(parseString) withObject:nil afterDelay:5];
        }
    }
}


-(void)setTextFields
{
    country= [self setUptextField:country forString:[profileSetUp2Array objectAtIndex:0] withXpos:[[profileSetUpPosPXArray objectAtIndex:0]floatValue] withYpos:[[profileSetUpPosPYArray objectAtIndex:0]floatValue] withWidth:screenWidth*.5 withHieght:screenHeight*.05 isSecuretext:NO];
    country.userInteractionEnabled=YES;
    [country addTarget:self action:@selector(arrowTouchCountry) forControlEvents:UIControlEventEditingDidBegin];
//    if(parentProfileEntity)
//    {
//        country.text = [parentProfileEntity country];
//        countryId=[parentProfileEntity countryId];
//    }
//    else
//    {
        country.text=@"INDIA";
        countryId=@"1";
//
//    }
    [PC_DataManager sharedManager].parentObjectInstance.country=country.text;
    [PC_DataManager sharedManager].parentObjectInstance.countryID=countryId;
    
    
   city= [self setUptextField:city forString:[profileSetUp2Array objectAtIndex:1] withXpos:[[profileSetUpPosPXArray objectAtIndex:1]floatValue] withYpos:[[profileSetUpPosPYArray objectAtIndex:1]floatValue] withWidth:screenWidth*.5 withHieght:screenHeight*.05 isSecuretext:NO];
    city.userInteractionEnabled=YES;
    [city addTarget:self action:@selector(arrowTouchCity) forControlEvents:UIControlEventEditingDidBegin];
//    if(parentProfileEntity)
//    {
//        city.text = [parentProfileEntity city];
//        cityId=[parentProfileEntity cityId];
//    }

    street= [self setUptextField:street forString:[profileSetUp2Array objectAtIndex:2] withXpos:[[profileSetUpPosPXArray objectAtIndex:2]floatValue] withYpos:[[profileSetUpPosPYArray objectAtIndex:2]floatValue] withWidth:screenWidth*.5 withHieght:screenHeight*.05 isSecuretext:NO];
    [street addTarget:self action:@selector(openTextController:) forControlEvents:UIControlEventEditingDidBegin];
//    if(parentProfileEntity)
//    {
//        street.text = [parentProfileEntity streetLocality];
//    }
//    
    flatNo=  [self setUptextField:flatNo forString:[profileSetUp2Array objectAtIndex:3] withXpos:[[profileSetUpPosPXArray objectAtIndex:3]floatValue] withYpos:[[profileSetUpPosPYArray objectAtIndex:3]floatValue] withWidth:screenWidth*.5 withHieght:screenHeight*.05 isSecuretext:NO];
    [flatNo addTarget:self action:@selector(openTextController:) forControlEvents:UIControlEventEditingDidBegin];
    [self putOptionalLabel:flatNo];
    
   
    for(int i=0; i<4; i++)
    {
        UITextField *txtfield =[self setUptextField:country forString:[profileSetUp2Array objectAtIndex:i] withXpos:cellPaddingReg withYpos:[[profileSetUpPosPYArray objectAtIndex:i]floatValue] withWidth:screenWidth*.5 withHieght:screenHeight*.05 isSecuretext:NO];
        txtfield.text=[profileSetUp2Array objectAtIndex:i];
        txtfield.userInteractionEnabled=NO;
        txtfield.textAlignment=NSTextAlignmentLeft;
    }
    
    [country setTextColor:placeHolderReg];
    [city setTextColor:placeHolderReg];
    [flatNo setTextColor:placeHolderReg];
    [street setTextColor:placeHolderReg];
    country.textAlignment=NSTextAlignmentRight;
    flatNo.textAlignment=NSTextAlignmentRight;
    street.textAlignment=NSTextAlignmentRight;
    city.textAlignment=NSTextAlignmentRight;
    
    
    
    
    StripView *stripeView  =[[StripView alloc]initWithFrame:CGRectMake(0, flatNo.frame.origin.y+flatNo.frame.size.height+25*ScreenHeightFactor, screenWidth,ScreenHeightFactor*25)];
    [stripeView drawStrip:@"SELECT NEIGHBOURHOOD" color:[UIColor redColor]];
    [stripeView setBackgroundColor:activityHeading2Code];
    [stripeView.StripLabel setTextColor:activityHeading2FontCode];
    [stripeView.StripLabel setFrame:CGRectMake(cellPaddingReg,0, screenWidth-2*cellPaddingReg, 25*ScreenHeightFactor)];
    [stripeView.StripLabel setFont:[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor]];
    [scrollView addSubview:stripeView];
    
//    if(parentProfileEntity)
//    {
//        flatNo.text = [parentProfileEntity flatNum];
//    }
    
}

-(void)addSearchBarField
{
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(mapView.frame.origin.x,mapView.frame.origin.y, screenWidth-2*cellPaddingReg, screenHeight*.05)];
   // searchBar.center = CGPointMake(screenWidth/2, searchBar.center.y);
    [searchBar setShowsScopeBar:YES];
    searchBar.delegate = self;
    searchBar.placeholder=[profileSetUp2Array objectAtIndex:5];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    checkString=@"";
    [scrollView addSubview:searchBar];
    
   // [animateArray addObject:searchBar];
    
    
}

-(void)fillData
{
    if([self.parentClassName isEqualToString:PinWiGetProfileDetails])
    {
        country.text        = [[PC_DataManager sharedManager].parentObjectInstance country];
        countryId           = [[PC_DataManager sharedManager].parentObjectInstance countryID];
        city.text           = [[PC_DataManager sharedManager].parentObjectInstance city];
        cityId              = [[PC_DataManager sharedManager].parentObjectInstance cityID];
        street.text         = [[PC_DataManager sharedManager].parentObjectInstance streetLocality];
        flatNo.text         = [[PC_DataManager sharedManager].parentObjectInstance flatBuilding];
        neighbourText.text  = [[PC_DataManager sharedManager].parentObjectInstance neighourRad];
        neighbourHoodId     = [[PC_DataManager sharedManager].parentObjectInstance neighourID];
        googleAdd           = [[PC_DataManager sharedManager].parentObjectInstance googleAddress];
       
        [PC_DataManager sharedManager].flatText=flatNo.text;
        [PC_DataManager sharedManager].streettext=street.text;
        
        if([neighbourHoodId isEqualToString:@"0"])
        {
            neighbourText.text=@"";
        }
        if([street.text isEqualToString:@"Not Added"])
        {
            street.text=@"";
        }
        if([flatNo.text isEqualToString:@"Not Added"])
        {
            flatNo.text=@"";
        }
        [continueBtn setTitle:@"Save" forState:UIControlStateNormal];
    }
    else if(parentProfileEntity)
    {
        country.text        = [parentProfileEntity country];
        countryId           = [parentProfileEntity countryId];
        city.text           = [parentProfileEntity city];
        cityId              = [parentProfileEntity cityId];
        street.text         = [parentProfileEntity streetLocality];
        flatNo.text         = [parentProfileEntity flatNum];
        neighbourText.text  = [parentProfileEntity neighbourRad];
        neighbourHoodId     = [parentProfileEntity neighbourID];
        googleAdd           = [parentProfileEntity googleMapAdd];
        
        [PC_DataManager sharedManager].flatText=flatNo.text;
        [PC_DataManager sharedManager].streettext=street.text;
        
        if([neighbourHoodId isEqualToString:@"0"])
        {
            neighbourText.text=@"";
        }
        if([street.text isEqualToString:@"Not Added"])
        {
            street.text=@"";
        }
        if([flatNo.text isEqualToString:@"Not Added"])
        {
            flatNo.text=@"";
        }
    }
   
}


#pragma mark search bar delegates

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1
{
   [searchBar1 resignFirstResponder];
    [self Searchplace:searchBar1.text];
  //  searchBar.center = CGPointMake(screenWidth/2, searchBar.center.y);

    [self expandMapView];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar1
{
    [searchBar1 becomeFirstResponder];
}

//-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
//        [UIView animateWithDuration:0.25 animations:^{
//            for (UIView *subview in self.view.subviews)
//                subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
//        }];
//    }
//}
//
//-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        [UIView animateWithDuration:0.25 animations:^{
//            for (UIView *subview in self.view.subviews)
//                subview.transform = CGAffineTransformIdentity;
//        }];
//    }
//}


-(void)parseString
{
    if(![checkString isEqualToString:searchBar.text])
    {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self googleURLString:searchBar.text]]];
    mapConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    mapConnectionData = [[NSMutableData alloc] init];
    checkString=searchBar.text;
    }
    [self performSelector:@selector(parseString) withObject:nil afterDelay:5];
}


-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
    isSearchActive=YES;
    if(searchTableView.alpha==0.0)
    {
        [searchTableView setAlpha:1.0];
    }
//    if([text isEqualToString:@""])//for BackSpace
//    {
//        checkString= [checkString stringByReplacingCharactersInRange:range withString:text];
//    }
//    else
//    {
//        checkString=[checkString stringByAppendingString:text];
//    }
    
    
   // [self filterContentForSearchText:checkString];
    return YES;

}

-(void)searchBar:(UISearchBar *)searchBar1 textDidChange:(NSString *)searchText
{
    
    //[self performSelector:@selector(parseString) withObject:nil afterDelay:.5];
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar1
{
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    [searchBar1 resignFirstResponder];
   // searchBar.center = CGPointMake(screenWidth/2, searchBar.center.y);

}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   // scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y);
    activeField = textField;
}

#pragma mark filterArray According To TextEnter
- (void)filterContentForSearchText:(NSString*)searchText
{
    //beginswith[c]
    //contains
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    filterData = [actualData filteredArrayUsingPredicate:resultPredicate];
    NSLog(@"Filter  data=%@",filterData);
    [searchTableView reloadData];
}

#pragma mark TableView Specific Function
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isSearchActive)
    {
        return filterData.count;
    }
    else
    {
        return actualData.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AutoTextFieldCell";
    NSString *displayString=nil;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if(isSearchActive)
    {
        displayString=[filterData objectAtIndex:indexPath.row];
    }
    else
    {
        displayString=[actualData objectAtIndex:indexPath.row];
    }
    cell.textLabel.text=displayString;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    checkString=@"";
    if(isSearchActive)
    {
        searchBar.text= checkString=[filterData objectAtIndex:indexPath.row];
    }
    else
    {
        searchBar.text=checkString=[actualData objectAtIndex:indexPath.row];
    }
    [searchTableView setAlpha:0.0];
}


#pragma mark NSURLConnection Delegate

- (void)failWithError:(NSError *)error {
    NSLog(@"FAILED....");
}

- (void)succeedWithPlaces:(NSArray *)places {
    NSMutableArray *parsedPlaces = [NSMutableArray array];
    for (NSDictionary *place in places) {
       // actualData=[[NSArray alloc]initWithObjects:@"s",@"su",@"sun",@"sund",@"sunda",@"sunday", nil];
       // [parsedPlaces addObject:[SPGooglePlacesAutocompletePlace placeFromDictionary:place]];
        //actualData addObject:<#(id)#>
    }
   
   
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (connection == mapConnection) {
        [mapConnectionData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connnection didReceiveData:(NSData *)data {
    if (connnection == mapConnection) {
        [mapConnectionData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (connection == mapConnection) {
        [self failWithError:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (connection == mapConnection) {
        NSError *error = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:mapConnectionData options:kNilOptions error:&error];
        if (error) {
            [self failWithError:error];
            return;
        }
        if ([[response objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]) {
            [self succeedWithPlaces:[NSArray array]];
            return;
        }
        if ([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
            [self succeedWithPlaces:[response objectForKey:@"predictions"]];
            return;
        }
        
        // Must have received a status of OVER_QUERY_LIMIT, REQUEST_DENIED or INVALID_REQUEST.
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[response objectForKey:@"status"] forKey:NSLocalizedDescriptionKey];
        NSLog(@"userinfo....%@",userInfo);
       // [self failWithError:[NSError errorWithDomain:@"com.spoletto.googleplaces" code:kGoogleAPINSErrorCode userInfo:userInfo]];
    }
}

-(void)drawArrowCity
{
    arrowImageCity = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowImageCity setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    [arrowImageCity setBackgroundImage:[UIImage imageNamed: isiPhoneiPad(@"grayArrow.png") ]  forState:UIControlStateNormal];
    arrowImageCity.frame=CGRectMake(0, 0, .05*screenWidth, .05*screenWidth);
    arrowImageCity.center =CGPointMake(screenWidth-arrowImageCity.frame.size.width/2, .12*screenHeight);
    
    [arrowImageCity addTarget:self action:@selector(arrowTouchCity) forControlEvents:UIControlEventTouchUpInside];
       //[scrollView addSubview:arrowImageCity];
}

-(void)drawArrowCountry
{
    arrowImageCountry = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowImageCountry setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    [arrowImageCountry setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"grayArrow.png")]  forState:UIControlStateNormal];
    arrowImageCountry.frame=CGRectMake(0, 0, .05*screenWidth, .05*screenWidth);
    arrowImageCountry.center =CGPointMake(screenWidth-arrowImageCountry.frame.size.width/2, .05*screenHeight);
    
    [arrowImageCountry addTarget:self action:@selector(arrowTouchCountry) forControlEvents:UIControlEventTouchUpInside];
   // [scrollView addSubview:arrowImageCountry];
}

-(void) moreIcon
{
    
    UIImage* imageMore = [UIImage imageNamed: isiPhoneiPad (@"Flower_pinwii.png")];
    CGRect frameimg = CGRectMake(0, 0, imageMore.size.width, imageMore.size.height);
    UIButton *moreIcon = [[UIButton alloc] initWithFrame:frameimg];
    [moreIcon setBackgroundImage:imageMore forState:UIControlStateNormal];
    
    UIBarButtonItem *moreButton =[[UIBarButtonItem alloc] initWithCustomView:moreIcon];
    self.navigationItem.rightBarButtonItem=moreButton;
   // [moreIcon addTarget:self action:@selector(moreButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void) moreButtonTouched
{
    logout = [[LogoutView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    logout.logoutDelegate=self;
    [self.view addSubview:logout];
}

#pragma mark Country and City Selection
-(void) arrowTouchCity
{
    CityTableViewController *city1 =[[CityTableViewController alloc]init];
    city1.cityListDelegate=self;
    [self.navigationController pushViewController:city1 animated:YES];
}

-(void)selectedCity:(NSString *)citySelected andId:(NSString *)cityIdSelected
{
    city.text=citySelected;
    
    cityId=[NSString stringWithFormat:@"%@",cityIdSelected];
    [PC_DataManager sharedManager].parentObjectInstance.cityID=cityId;
    [[PC_DataManager sharedManager]writeParentObjToDisk];
    
    [self Searchplace:citySelected];
}

-(void) arrowTouchCountry
{
    CountryTableViewController *country1 =[[CountryTableViewController alloc]init];
    country1.countryListDelegate=self;
    [self.navigationController pushViewController:country1 animated:YES];
}

-(void)selectedCountry:(NSString *)countrySelected andId:(NSString *)countryIdSelected
{
    if(countryId!=countryIdSelected)// if([country.text isEqualToString:countrySelected])
    {
        city.text=@"";
        cityId=@"";
        [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:@"GetCityList"];
    }
    
    country.text=countrySelected;
    countryId=countryIdSelected;
    
     [PC_DataManager sharedManager].parentObjectInstance.country =countrySelected;
    [PC_DataManager sharedManager].parentObjectInstance.countryID=countryIdSelected;
    [[PC_DataManager sharedManager]writeParentObjToDisk];
}


-(void)addPswd
{
    AddPassCode *adpasscode=[[AddPassCode alloc]initwithEnablePswd:YES changePswd:NO deletePswd:NO key:kCAUserInfoUsernameKey] ;
    [self presentViewController:adpasscode animated:NO completion:nil];
}

-(UITextField*)setUptextField:(UITextField*)textField forString:(NSString*)str withXpos:(float)x withYpos:(float)y withWidth:(float)wd withHieght:(float)ht isSecuretext:(BOOL)secured
{
    textField=[[UITextField alloc]initWithFrame:CGRectMake(x,y,wd,ht)];
    textField.placeholder = str;
    [textField setValue:placeHolderReg forKeyPath:@"_placeholderLabel.textColor"];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [textField setFont:[UIFont fontWithName:RobotoRegular size:12*ScreenHeightFactor]];
    
    [scrollView addSubview:textField];
    textField.delegate=self;
    
    if(secured)
    {
        textField.secureTextEntry=secured;
    }
    
    
    lineView= [[PC_DataManager sharedManager] drawLineView_withXPos:textField.center.x andYPos:textField.center.y+.02*screenHeight withScrnWid:textField.frame.size.width withScrnHt:.001*screenHeight ofColor:lineTextColor];
    [scrollView addSubview:lineView];
   
    return textField;
}

-(void)addNeighbourhood
{
//    neighbourText= [self setUptextField:neighbourText forString:[profileSetUp2Array objectAtIndex:6] withXpos:[[profileSetUpPosPXArray objectAtIndex:6]floatValue] withYpos:(mapView.frame.origin.y+mapView.frame.size.height+.05*screenHeight) withWidth:screenWidth*.7 withHieght:screenHeight*.05 isSecuretext:NO];

     neighbourText= [self setUptextField:neighbourText forString:[profileSetUp2Array objectAtIndex:6] withXpos:[[profileSetUpPosPXArray objectAtIndex:6]floatValue] withYpos:.4*screenHeight withWidth:screenWidth-2*cellPaddingReg withHieght:screenHeight*.05 isSecuretext:NO];
    
    neighbourText.keyboardType=UIKeyboardTypeNumberPad;
    [self putOptionalLabel:neighbourText];
//    [animateArray addObject:neighbourText];
//    [animateArray addObject:lineView];

//    if(parentProfileEntity)
//    {
//        neighbourText.text = [parentProfileEntity neighbourRad];
//        neighbourHoodId = [parentProfileEntity neighbourID];
//        if([neighbourText.text isEqualToString:@"0"])
//        {
//            neighbourText.text=@"";
//        }
//    }
    
    

    
    NeighbourhoodRad *timePicker =[[NeighbourhoodRad alloc]initWithFrame:CGRectMake(0, screenHeight*.60f, screenWidth, screenHeight*.40f)];
    //[timePicker setBackgroundColor:[UIColor redColor]];
    [timePicker setTextField:neighbourText];
    timePicker.neibourRadDelegate=self;
    [timePicker pickerView:@"Radius"];
    [neighbourText setInputView:timePicker];
    
}


-(void)neighbourRad:(NSMutableDictionary *)neighbourDictData
{
    neighbourDict=neighbourDictData;
    neighbourHoodId =[NSString stringWithFormat:@"%@",[neighbourDict objectForKey:@"NeighbourhoodID"]];;

  //  [PC_DataManager sharedManager].parentObjectInstance.neighourID=[NSString stringWithFormat:@"%@",[neighbourDict objectForKey:@"NeighbourhoodID"]];;
}


-(void)addButton
{
    continueBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    
    [continueBtn setTitle:@"Continue" forState:UIControlStateNormal];
    continueBtn.tintColor=[[UIColor blackColor]colorWithAlphaComponent:0.8f];
    continueBtn.backgroundColor=buttonGreenColor;
    [continueBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    continueBtn.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.023*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [continueBtn sizeToFit];
    continueBtn.frame=CGRectMake(cellPaddingReg, screenHeight*.74, screenWidth-cellPaddingReg*2, screenHeight*.066);
    continueBtn.center=CGPointMake(screenWidth*.5,(mapView.frame.origin.y+mapView.frame.size.height+.07*screenHeight));
    
    [continueBtn addTarget:self action:@selector(continueBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:continueBtn];
    
    [animateArray addObject:continueBtn];
    
    [scrollView setContentSize:CGSizeMake(screenWidth, continueBtn.frame.size.height+continueBtn.frame.origin.y+20)];
    NSLog(@"Value  of content size Height = %f %f",scrollView.contentSize.height,screenHeight);
}

-(void)continueBtnTouch
{

//    ConfirmationProfileViewController *confirm=[[ConfirmationProfileViewController alloc]init];
//    [self.navigationController pushViewController:confirm animated:YES];
    
//   if([self validateParent2Data])

//    ConfirmationProfileViewController *confirm=[[ConfirmationProfileViewController alloc]init];
//    [self.navigationController pushViewController:confirm animated:YES];
//    return;
    
    if([self validateParent2Data])
    {
        isParentAddition = YES;
        if(flatNo.text.length==0)
        {
            flatNo.text=@"";
        }
         if(street.text.length==0)
        {
            street.text=@"";
        }
         if (neighbourText.text.length==0)
        {
            neighbourText.text=@"";
            neighbourHoodId=@"0";
        }

        if(parentProfileEntity)
        {
            ParentProfileObject *parent=[[ParentProfileObject alloc]init];
            parent.flatBuilding      =flatNo.text;
            parent.streetLocality    =street.text;
            parent.city              =city.text;
            parent.country           =country.text;// [NSNumber numberWithInt:autoLockTime.text];
            parent.latitude          =[NSString stringWithFormat:@"%f",marker.position.latitude];
            parent.longitute         =[NSString stringWithFormat:@"%f",marker.position.longitude];
            parent.googleAddress     =googleAdd;
            parent.neighourRad       =neighbourText.text;// [NSNumber numberWithInt:autoLockTime.text];
            
            //[[PC_DataManager sharedManager]writeParentObjToDisk];
        }
        
        
        
        [PC_DataManager sharedManager].parentObjectInstance.flatBuilding    =flatNo.text;
        [PC_DataManager sharedManager].parentObjectInstance.streetLocality  =street.text;
        [PC_DataManager sharedManager].parentObjectInstance.city            =city.text;
        [PC_DataManager sharedManager].parentObjectInstance.country         =country.text;// [NSNumber numberWithInt:autoLockTime.text];
        [PC_DataManager sharedManager].parentObjectInstance.latitude        =[NSString stringWithFormat:@"%f",marker.position.latitude];
        [PC_DataManager sharedManager].parentObjectInstance.longitute       =[NSString stringWithFormat:@"%f",marker.position.longitude];
        [PC_DataManager sharedManager].parentObjectInstance.googleAddress   =googleAdd;
        [PC_DataManager sharedManager].parentObjectInstance.neighourRad     =neighbourText.text; // [NSNumber numberWithInt:autoLockTime.text];
        [PC_DataManager sharedManager].parentObjectInstance.neighourID     = neighbourHoodId;
        //[NSString stringWithFormat:@"%@",[neighbourDict objectForKey:@"NeighbourhoodID"]];//[neighbourDict objectForKey:@"NeighbourhoodID"];
        [PC_DataManager sharedManager].parentObjectInstance.cityID          =cityId;
        [PC_DataManager sharedManager].parentObjectInstance.countryID       =countryId;
        
        [[PC_DataManager sharedManager]writeParentObjToDisk];
        
        
//        NSLog(@"parent object %@,%@,%@,%@ , %@" ,[PC_DataManager sharedManager].parentObjectInstance.flatBuilding,
//              [PC_DataManager sharedManager].parentObjectInstance.streetLocality,
//              [PC_DataManager sharedManager].parentObjectInstance.city,
//              [PC_DataManager sharedManager].parentObjectInstance.country,[PC_DataManager sharedManager].parentObjectInstance);
        
        NSLog(@"Device Token = %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@",[PC_DataManager sharedManager].parentObjectInstance.deviceToken,[PC_DataManager sharedManager].parentObjectInstance.image,[PC_DataManager sharedManager].parentObjectInstance.firstName,[PC_DataManager sharedManager].parentObjectInstance.lastName,[PC_DataManager sharedManager].parentObjectInstance.emailAdd,[PC_DataManager sharedManager].parentObjectInstance.passwd,[PC_DataManager sharedManager].parentObjectInstance.dob,[PC_DataManager sharedManager].parentObjectInstance.relation,[PC_DataManager sharedManager].parentObjectInstance.gender,[PC_DataManager sharedManager].parentObjectInstance.contactNo,[PC_DataManager sharedManager].parentObjectInstance.passcode,[PC_DataManager sharedManager].parentObjectInstance.autoLockID,[PC_DataManager sharedManager].parentObjectInstance.flatBuilding,[PC_DataManager sharedManager].parentObjectInstance.streetLocality,[PC_DataManager sharedManager].parentObjectInstance.cityID,[PC_DataManager sharedManager].parentObjectInstance.countryID,[PC_DataManager sharedManager].parentObjectInstance.googleAddress,[PC_DataManager sharedManager].parentObjectInstance.latitude,[PC_DataManager sharedManager].parentObjectInstance.longitute,[PC_DataManager sharedManager].parentObjectInstance.neighourID);
        
        
        
        NSMutableDictionary *dataDict=[[NSMutableDictionary alloc]init];
        [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.flatBuilding    forKey:@"FlatNoBuilding"];
        [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.streetLocality  forKey:@"StreetLocality"];
        [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.cityID          forKey:@"City"];
        [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.countryID       forKey:@"Country"];
        [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.googleAddress   forKey:@"GoogleMapAddress"];
        [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.latitude        forKey:@"Longitude"];
        [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.longitute       forKey:@"Latitude"];
        [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.neighourID      forKey:@"NeighbourhoodRad"];
        
        if([self.parentClassName isEqualToString:PinWiGetProfileDetails])
        {
            
            [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.parentId      forKey:@"ParentID"];
            
            UpdateLocationByParentID *createParentProfile = [[UpdateLocationByParentID alloc] init];
//            [createParentProfile initService:@{
//                                               
//                                               
//                                               @"ParentID"          :[PC_DataManager sharedManager].parentObjectInstance.parentId,
//                                               @"FlatNoBuilding"    :[PC_DataManager sharedManager].parentObjectInstance.flatBuilding,
//                                               @"StreetLocality"    :[PC_DataManager sharedManager].parentObjectInstance.streetLocality,
//                                               @"City"              :[PC_DataManager sharedManager].parentObjectInstance.cityID,
//                                               @"Country"           :[PC_DataManager sharedManager].parentObjectInstance.countryID,
//                                               @"GoogleMapAddress"  :[PC_DataManager sharedManager].parentObjectInstance.googleAddress,
//                                               @"Longitude"         :[PC_DataManager sharedManager].parentObjectInstance.latitude,
//                                               @"Latitude"          :[PC_DataManager sharedManager].parentObjectInstance.longitute,
//                                               @"NeighbourhoodRad"  :[PC_DataManager sharedManager].parentObjectInstance.neighourID,
//                                               }];
            [createParentProfile initService:dataDict];
            [createParentProfile setDelegate:self];
            createParentProfile.serviceName=PinWiUpdateParent;

        }
        else
        {
            [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.deviceToken     forKey:@"DeviceID"];
            [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.deviceToken     forKey:@"DeviceToken"];
            if(![[PC_DataManager sharedManager].parentObjectInstance.image isEqualToString:@"(null)"] && [PC_DataManager sharedManager].parentObjectInstance.image)
            {
            [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.image           forKey:@"ProfileImage"];
            }
            [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.firstName       forKey:@"FirstName"];
            [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.lastName        forKey:@"LastName"];
            [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.emailAdd        forKey:@"EmailAddress"];
            [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.passwd          forKey:@"Password"];
            [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.dob             forKey:@"DateOfBirth"];
            [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.relation        forKey:@"Relation"];
            [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.gender          forKey:@"Gender"];
            [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.contactNo       forKey:@"Contact"];
            [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.passcode        forKey:@"Passcode"];
            [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.autoLockID      forKey:@"AutolockTime"];
            
            
            
            CreateParentProfile *createParentProfile = [[CreateParentProfile alloc] init];
//            [createParentProfile initService:@{
//                                           
//                                           
//                                           // @"parentId"          :[PC_DataManager sharedManager].parentObjectInstance.parentId,
//                                           @"DeviceID"          :[PC_DataManager sharedManager].parentObjectInstance.deviceToken,
//                                           @"DeviceToken"       :[PC_DataManager sharedManager].parentObjectInstance.deviceToken,
//                                           @"ProfileImage"      :[PC_DataManager sharedManager].parentObjectInstance.image,
//                                           @"FirstName"         :[PC_DataManager sharedManager].parentObjectInstance.firstName,
//                                           @"LastName"          :[PC_DataManager sharedManager].parentObjectInstance.lastName,
//                                           @"EmailAddress"      :[PC_DataManager sharedManager].parentObjectInstance.emailAdd,
//                                           @"Password"          :[PC_DataManager sharedManager].parentObjectInstance.passwd,
//                                           @"DateOfBirth"       :[PC_DataManager sharedManager].parentObjectInstance.dob,
//                                           @"Relation"          :[PC_DataManager sharedManager].parentObjectInstance.relation,
//                                           @"Gender"            :[PC_DataManager sharedManager].parentObjectInstance.gender,
//                                           @"Contact"           :[PC_DataManager sharedManager].parentObjectInstance.contactNo,
//                                           @"Passcode"          :[PC_DataManager sharedManager].parentObjectInstance.passcode,
//                                           @"AutolockTime"      :[PC_DataManager sharedManager].parentObjectInstance.autoLockID,
//                                           @"FlatNoBuilding"    :[PC_DataManager sharedManager].parentObjectInstance.flatBuilding,
//                                           @"StreetLocality"    :[PC_DataManager sharedManager].parentObjectInstance.streetLocality,
//                                           @"City"              :[PC_DataManager sharedManager].parentObjectInstance.cityID,
//                                           @"Country"           :[PC_DataManager sharedManager].parentObjectInstance.countryID,
//                                           @"GoogleMapAddress"  :[PC_DataManager sharedManager].parentObjectInstance.googleAddress,
//                                           @"Longitude"         :[PC_DataManager sharedManager].parentObjectInstance.latitude,
//                                           @"Latitude"          :[PC_DataManager sharedManager].parentObjectInstance.longitute,
//                                           @"NeighbourhoodRad"  :[PC_DataManager sharedManager].parentObjectInstance.neighourID,
//                                           }];
            [createParentProfile initService:dataDict];
            [createParentProfile setDelegate:self];
            createParentProfile.serviceName=PinWiCreateParent;
        }
        [self addLoaderView];
        
        NSLog(@"date of Birth  = %@",[PC_DataManager sharedManager].parentObjectInstance.dob);
        NSLog(@"NeighourHoood Raidus =%@",[PC_DataManager sharedManager].parentObjectInstance.neighourID);
    }
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    NSLog(@"register: \n%@", dictionary);
    [self removeLoaderView];
    if([connection.serviceName isEqualToString:PinWiCreateParent])
    {
        
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"CreateParentProfileResponse" resultKey:@"CreateParentProfileResult"];
        if(!dict)
        {
            return;
        }
        for (NSDictionary *parentDict in dict)
        {
            // NSInteger val= [[parentDict objectForKey:@"ParentID"] integerValue];
            [LTHKeychainUtils storeUsername:kCAUserInfoUsernameKey
                                andPassword:[PC_DataManager sharedManager].parentObjectInstance.passcode
                             forServiceName:@"PCApp"
                             updateExisting:YES
                                      error:nil];
            [[NSUserDefaults standardUserDefaults]setObject:[PC_DataManager sharedManager].parentObjectInstance.passcode forKey:@"LocalPassword"];
//            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"doesPswdExist"];
//            [[NSUserDefaults standardUserDefaults]synchronize];

            
            [PC_DataManager sharedManager].parentObjectInstance.parentId= [NSString stringWithFormat:@"%@",[parentDict objectForKey:@"ParentID"] ] ;
            
            [[PC_DataManager sharedManager]writeParentObjToDisk];
            [[PC_DataManager sharedManager]retrieveDataAtLogin];
        }// Store in the dictionary using the data as the key
        
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"Confirmed"];
        ConfirmationProfileViewController *confirm=[[ConfirmationProfileViewController alloc]init];
        self.navigationController.navigationItem.hidesBackButton=NO;
        [self.navigationController pushViewController:confirm animated:YES];
    }
    else if ([connection.serviceName isEqualToString:PinWiUpdateParent])
    {
            [[PC_DataManager sharedManager]writeParentObjToDisk];
            [[PC_DataManager sharedManager]retrieveDataAtLogin];
            
//            NSUInteger numberOfViewControllersOnStack = [self.navigationController.viewControllers count];
//            UIViewController *parentViewController;
//            parentViewController  = self.navigationController.viewControllers[numberOfViewControllersOnStack - 3];
//            Class parentVCClass = [parentViewController class];
//            NSString *className = NSStringFromClass(parentVCClass);
        [[PC_DataManager sharedManager].serviceDictionary removeAllObjects];
        [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:@"GetNamesByParentID"];
            [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark MAPS
-(void)mapIntegration
{
    [GMSServices provideAPIKey:GoogleiOSMapKeyScheme];
    [self getLoc];
    NSLog(@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude zoom:13];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(cellPaddingReg, screenHeight*.49, screenWidth-cellPaddingReg*2, screenHeight*.4) camera:camera];
    
    
 // mapView.settings.compassButton = YES;
    mapView.myLocationEnabled = YES;
 
    
    mapView.settings.myLocationButton = YES;
    mapView.delegate=self;
   
    
    marker = [[GMSMarker alloc] init];
    marker.position = camera.target;
    // marker.position = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon = [UIImage imageNamed: isiPhoneiPad(@"default-marker.png")];
    marker.map = mapView;
    
    [scrollView addSubview:mapView];
    
    //[animateArray addObject:mapView];
    [self addNeighbourhood];
    [self addButton];
    
     [self Searchplace:city.text];
    
    
}


-(void)Searchplace:(NSString*)searchLoc
{
    // -(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
//    if(searchLoc.length==0)
//    {
//        [self contractMapView];
//        return;
//    }
    
    NSString *esc_addr =  [searchLoc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=true&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    [mapView animateToLocation:CLLocationCoordinate2DMake(latitude, longitude)];
    marker.position=CLLocationCoordinate2DMake(latitude,longitude);
    //mapView.camera= CLLocationCoordinate2DMake(latitude, longitude);
    
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    //return center;
    
}


-(void)getLoc
{
    locationManager = [[CLLocationManager alloc] init];
   
    locationManager.delegate=self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;//kCLLocationAccuracyHundredMeters; // 100 m
    
    if ([self.locationManager respondsToSelector:@selector
         (requestWhenInUseAuthorization)]) {
         //[locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];//ios 8
    }
    [self.locationManager startUpdatingLocation];
    
    
    
    NSString *req = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true", locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude];
   // NSDictionary *result=[NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:req]];
    
//    NSData *data = [errorCode dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error = nil;
//    NSDictionary *errorCodeDict  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//    errorCode = [errorCodeDict valueForKey:@"ErrorCode"];
//    if([errorCode isEqualToString:@"0"])
    
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:req]];
    
    NSString *result =[NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result)
    {
       // NSScanner *scanner = [NSScanner scannerWithString:result];
        NSArray *textStrArray = [result componentsSeparatedByString:@"],"];
      //  NSDictionary *addDict  = [textStrArray objectAtIndex:1];
       // NSString *addStr=[addDict objectForKey:@"formatted_address"];
        NSString *addStr=[textStrArray objectAtIndex:1];
        NSArray *addArr=[addStr componentsSeparatedByString:@":"];
        addStr=[addArr objectAtIndex:1];
        addArr=[addStr componentsSeparatedByString:@",\n"];
        googleAdd=[addArr objectAtIndex:0];
        [PC_DataManager sharedManager].parentObjectInstance.googleAddress=googleAdd;
        NSLog(@"AddStr--- %@",googleAdd);
    }
}


- (NSString *)googleURLString:(NSString*)str {
    NSMutableString *url = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&%@&key=%@",
                            [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            str, GoogleServerKey];
    
    
    if (offset != NSNotFound) {
        [url appendFormat:@"&offset=%lu",(unsigned long)offset];
    }
    if (location.latitude != -1) {
        [url appendFormat:@"&location=%f,%f", location.latitude, location.longitude];
    }
    if (radius != NSNotFound) {
        [url appendFormat:@"&radius=%f", radius];
    }
    if (language) {
        [url appendFormat:@"&language=%@", language];
    }
//    if (types != -1) {
//        [url appendFormat:@"&types=%@", SPPlaceTypeStringForPlaceType(types)];
//    }
    return url;
}



#pragma mark location manager delegates
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"didFailWithError: %@", error);
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    //NSLog(@"didUpdateToLocation: %@", newLocation);
//    CLLocation *currentLocation = newLocation;
//    
//    if (currentLocation != nil) {
////       NSLog(@"%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
////       NSLog(@"%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
//    }
//}
- (void)mapView:(GMSMapView *)mapView1
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}


- (void)mapView:(GMSMapView *)mapView1 willMove:(BOOL)gesture {
    //[mapView1 clear];
}

- (void)mapView:(GMSMapView *)mapView1
idleAtCameraPosition:(GMSCameraPosition *)cameraPosition {
    id handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
        if (error == nil) {
//            GMSReverseGeocodeResult *result = response.firstResult;
//            GMSMarker *marker1 = [GMSMarker markerWithPosition:cameraPosition.target];
//            marker1.title = result.lines[0];
//            marker1.snippet = result.lines[1];
//            marker1.map = mapView1;
//            mapView1.myLocationEnabled = YES;
        }
    };
    //[geocoder_ reverseGeocodeCoordinate:cameraPosition.target completionHandler:handler];
}


-(BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView1{
    NSLog(@"You tapped at my location button ");

    CLLocationCoordinate2D target =
    CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    
    [mapView1 animateToLocation:target];
    
    mapView1.selectedMarker = nil;
    marker.position= target;
    return true;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"myLocation"]) {
//        CLLocation *location1 = [object myLocation];
//        //...
//        NSLog(@"Location, %@,", location1);
//        
//        CLLocationCoordinate2D target =
//        CLLocationCoordinate2DMake(location1.coordinate.latitude, location1.coordinate.longitude);
//        
//        [mapView animateToLocation:target];
//        [mapView animateToZoom:17];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}





- (void) mapView:(MKMapView *)aMapView didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *view in views)
    {
        if ([[view annotation] isKindOfClass:[MKUserLocation class]])
        {
            [[view superview] bringSubviewToFront:view];
        }
        else
        {
            [[view superview] sendSubviewToBack:view];
        }
    }
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView1 regionDidChangeAnimated:(BOOL)animated
{
    for (NSObject *annotation in [mapView1 annotations])
    {
        if ([annotation isKindOfClass:[MKUserLocation class]])
        {
            NSLog(@"Bring blue location dot to front");
            MKAnnotationView *view = [mapView1 viewForAnnotation:(MKUserLocation *)annotation];
            [[view superview] bringSubviewToFront:view];
        }
    }
}

-(BOOL)mapView:(GMSMapView *)mapView1 didTapMarker:(GMSMarker *)markerTapped {
    
    
    CLLocationCoordinate2D target =
    CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);


   
    [mapView1 animateToLocation:target];
    
    marker.position= target;

    return YES;
}
#pragma mark ORIENTATION change frame set
/*-(void)potraitModeFrames
{
    mapView.frame=CGRectMake(screenWidth*.05, screenHeight*.35, screenWidth*.9, screenHeight*.4);
    neighbourAdd.frame=CGRectMake([[profileSetUpPosPXArray objectAtIndex:4]floatValue],[[profileSetUpPosPYArray objectAtIndex:4]floatValue],screenWidth*.9, screenHeight*.05);
    continueBtn.center=CGPointMake(screenWidth*.5,screenHeight*.92);
}

-(void)landScapeModeFrames
{
   
    mapView.frame=CGRectMake(screenWidth,-screenHeight*.01, screenHeight*.45, screenWidth);
    neighbourAdd.center=CGPointMake(neighbourAdd.center.x, screenHeight*.35);
    continueBtn.center=CGPointMake(continueBtn.center.x, screenHeight*.45);
    
}
*/
#pragma mark KEYBOARD delegates
-(BOOL)becomeFirstResponder
{
    return YES;
}

-(BOOL)resignFirstResponder
{
    return YES;
}

-(void)resignOnTap1:(id)sender
{
    [flatNo resignFirstResponder];
    [street resignFirstResponder];
    [city resignFirstResponder];
    [country resignFirstResponder];
    [neighbourText resignFirstResponder];
    
    if(searchBar)
    {
        [searchBar resignFirstResponder];
        [self contractMapView];
    }
    
}


#pragma mark
#pragma mark Keyboard notifications
/*
- (void)keyboardWillShow:(NSNotification *)note
{
    isKeyBoard=YES;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = scrollView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    scrollView.frame = containerFrame;
    [UIView commitAnimations];
    
    // iseditingtextField=YES;
    CGSize keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
}

- (void)keyboardWillHide:(NSNotification *)note
{
    isKeyBoard=NO;
    [self ResetToolBar:note];
    }

-(void)ResetToolBar:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = scrollView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    scrollView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
    
}
*/
#pragma mark textfield delegates
/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //NSLog(@"text  %i", Pinlabel.text.length);
    if(passcode)
    {
//        AddPassCode *adpasscode=[[AddPassCode alloc]initwithEnablePswd:YES changePswd:NO deletePswd:NO key:kCAUserInfoUsernameKey] ;
        [self.view addSubview:passcode];
    }
    
    
    return YES;
}*/


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [flatNo resignFirstResponder];
    [street resignFirstResponder];
    [city resignFirstResponder];
    [country resignFirstResponder];
    [neighbourText resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark keyboard functionalities

-(void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark KeyBoard Notification
-(void) keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = scrollView.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) )
    {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height-24);
        [scrollView setContentOffset:scrollPoint animated:YES];

    }
  
    
}
-(void) keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}


#pragma mark OTHER functionalities
-(void)expandMapView
{
//    
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if(!isExpanded)
                         {
//                             for(UIView *view in animateArray)
//                             {
//                                 view.center=CGPointMake(view.center.x, view.center.y+screenHeight*.4);
//                             }
                             continueBtn.center=CGPointMake(continueBtn.center.x, continueBtn.center.y+screenHeight*.4);
                         mapView.frame=CGRectMake(mapView.frame.origin.x, mapView.frame.origin.y, screenWidth-2*cellPaddingReg, screenHeight*.8);
                         searchBar.frame=CGRectMake(mapView.frame.origin.x, mapView.frame.origin.y, searchBar.frame.size.width, searchBar.frame.size.height);
                         scrollView.frame=CGRectMake( 0,scrollView.frame.origin.y,screenWidth, screenHeight);
                        scrollView.contentSize = CGSizeMake(screenWidth, screenHeight*1.6);
                       // searchBar.center = CGPointMake(screenWidth/2, searchBar.center.y);

                         }
                     }
                     completion:^(BOOL finished){
                         isExpanded=YES;
                     }];
}

-(void)contractMapView
{
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if(isExpanded)
                         {
//                             for(UIView *view in animateArray)
//                             {
//                                 view.center=CGPointMake(view.center.x, view.center.y-screenHeight*.4);
//                             }
                              continueBtn.center=CGPointMake(continueBtn.center.x, continueBtn.center.y-screenHeight*.4);
                             mapView.frame=CGRectMake(mapView.frame.origin.x, mapView.frame.origin.y, screenWidth-2*cellPaddingReg, screenHeight*.4);
                             searchBar.frame=CGRectMake(mapView.frame.origin.x, mapView.frame.origin.y, searchBar.frame.size.width, searchBar.frame.size.height);
                             scrollView.frame=CGRectMake(0,scrollView.frame.origin.y,screenWidth, screenHeight-headerView.frame.size.height);
                             //scrollView.backgroundColor = [UIColor redColor];
                             scrollView.contentSize = CGSizeMake(screenWidth, screenHeight*1.2);
                            // searchBar.center = CGPointMake(screenWidth/2, searchBar.center.y);
                         }
                     }
                     completion:^(BOOL finished){
                         isExpanded=NO;
                         
                     }];
}


#pragma mark Validation
-(BOOL)validateParent2Data
{
    if(city.text.length==0|| country.text.length==0)
    {
        [self showAlertWithTitle:@"Incomplete Data" andMsg:@"Oops! You left a few important fields blank."];
    }
    else
    {
        return YES;
    }
    return NO;
   
}

-(void)showAlertWithTitle:(NSString *)heading andMsg:(NSString*)msg
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:heading message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark ADD / REMOVE LOADER
-(void)addLoaderView
{
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [self.view addSubview:loaderView];
}

-(void)removeLoaderView
{
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}
#pragma mark customToolBarDelegate
-(void)touchAtCancelButton:(CustomToolBar *)cancelDoneToolBar
{
    
}
-(void)touchAtDoneButton:(CustomToolBar *)cancelDoneToolBar
{
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark HeaderViewSpecificFunctions
#pragma mark headerViewSpecificFunction
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:appBackgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:nil];
        [headerView setCentreImgName:@"Location_header.png"];
        [headerView drawHeaderViewWithTitle:@"Location Setup" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        [self.view bringSubviewToFront:headerView];
        
        
        if(screenWidth>700)
        {
            yy+=headerView.frame.size.height+30*ScreenHeightFactor;
        }
        else
        {
            yy+=headerView.frame.size.height+18*ScreenHeightFactor;
            
        }
    }
    [self.view addSubview:headerView];
}
#pragma mark BACK BUTTON DELEGATE
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark optional text
-(void)putOptionalLabel:(UITextField*)field
{
    UILabel *optlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, field.frame.origin.y+field.frame.size.height, ScreenWidthFactor*60, ScreenHeightFactor*15)];
    optlabel.text=@"(Optional)";
    optlabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenHeightFactor];
    optlabel.textColor=placeHolderReg;
    optlabel.textAlignment=NSTextAlignmentRight;
    optlabel.center=CGPointMake(screenWidth-optlabel.frame.size.width/2-cellPaddingReg,optlabel.center.y);
    [scrollView addSubview:optlabel];
}

#pragma mark textController Street/Flat
-(void)openTextController:(UITextField*)sender
{
    SplitTextController_VC *split=[[SplitTextController_VC alloc]init];
    split.headString=sender.placeholder;
    split.parentName=sender.placeholder;
    split.nameString=sender.text;
    [self.navigationController pushViewController:split animated:YES];
}



//-(void)viewWillLayoutSubviews
//{
//    if(self.searchDisplayController.isActive)
//    {
//        [UIView animateWithDuration:0.001 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//            [self.navigationController setNavigationBarHidden:NO animated:NO];
//        }completion:nil];
//    }
//    [super viewWillLayoutSubviews];
//}

@end
