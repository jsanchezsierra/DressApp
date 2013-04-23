//
//  CalendarMonthViewController.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 12/5/11.
//  Copyright (c) 2011 Javier Sanchez Sierra. All rights reserved.
//
// This file is part of DressApp.

// DressApp is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// DressApp is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
//
// Permission is hereby granted, free of charge, to any person obtaining 
// a copy of this software and associated documentation files (the "Software"), 
// to deal in the Software without restriction, including without limitation the 
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
// sell copies of the Software, and to permit persons to whom the Software is furnished 
// to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//https://github.com/jsanchezsierra/DressApp


#import "CalendarMonthViewController.h"
#import "CalendarConjunto.h"
#import "Conjunto.h"
#import "CalendarDayDetailVC.h"
#import "StyleDressApp.h"

@implementation CalendarMonthViewController
@synthesize delegate,managedObjectContext;
@synthesize mainView;
@synthesize myViewActivity;
@synthesize backgroundImageView,monthLabel,monthYearImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withMonth:(NSInteger)mes
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currentMonth=mes;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
 
    [self.view setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorCalendarBackground]];
    [self.mainView setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorCalendarBackground]];
    self.backgroundImageView.image=[StyleDressApp imageWithStyleNamed:@"CalendarBackground"]; 
    
    self.monthYearImageView.image=[StyleDressApp imageWithStyleNamed:@"CA1MonthYear"]; 
    
    
    [nextMonthButton setImage: [StyleDressApp imageWithStyleNamed:@"CA1BtnNextMonth"] forState:UIControlStateNormal ];
    [prevMonthButton setImage: [StyleDressApp imageWithStyleNamed:@"CA1BtnPrevMonth"] forState:UIControlStateNormal ];
    
    
    UIFont *myFontMonthYear;
    
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        myFontMonthYear= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:23];
    else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        myFontMonthYear= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:20];
    
    
    
    //Prepare file manager && cachesDirectory
    cachesDirectory= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0 ];
    fileManager = [NSFileManager defaultManager];

    //My calendar
    myCalendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [myCalendar setFirstWeekday:2];

    
    unsigned unitFlags = NSWeekCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit;
    NSTimeInterval secondsPerDay= 24*60*60;

    currentYear=  [[[NSUserDefaults standardUserDefaults] objectForKey:@"calendarCurrentYear"] intValue];
    
    //First day of month properties
    NSDateComponents *compsFirstDay = [[NSDateComponents alloc] init];
    [compsFirstDay setDay:1];
    [compsFirstDay setMonth:currentMonth];
    [compsFirstDay setYear:currentYear];
    [compsFirstDay setHour:18];
    [compsFirstDay setMinute:30];
    firstDayOfMonth =[myCalendar dateFromComponents:compsFirstDay];
    weekdayOfFirstDayOfMonth = [myCalendar ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:firstDayOfMonth];
    NSDateComponents *weekOfComponentsFirst = [myCalendar components:unitFlags fromDate:firstDayOfMonth];
    NSInteger week1=[weekOfComponentsFirst week];
    if (currentMonth==1 && week1>50)
        week1=0;
    weekOfFirstDayOfMonth = 1;//[weekOfComponentsFirst weekOfMonth];

    
    //Last day of month properties
    NSDateComponents *compsLastDay = [[NSDateComponents alloc] init];
    [compsLastDay setDay:1];
    [compsLastDay setMonth:currentMonth+1];
    [compsLastDay setYear:currentYear];
    [compsLastDay setHour:18];
    [compsLastDay setMinute:30];
    if ( currentMonth+1==13  ) //Si el mes es diciembre
    {
        [compsLastDay setMonth:1];
        [compsLastDay setYear:currentYear+1];
    }
    lastDayOfMonth= [NSDate dateWithTimeInterval:-secondsPerDay sinceDate:[myCalendar dateFromComponents:compsLastDay] ];
    weekdayOfLastDayOfMonth = [myCalendar ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:lastDayOfMonth];
    NSDateComponents *weekOfComponentsLast = [myCalendar components:unitFlags fromDate:lastDayOfMonth];
    NSInteger week2=[weekOfComponentsLast week];
    weekOfLastDayOfMonth = week2-week1+1; //[weekOfComponentsLast weekOfMonth];
    if (weekOfLastDayOfMonth<0) {
        //REPASAR PARA TODOS LOS DICIEMBRES DE OTROS AÑOS 2012/13/14...
        week2 = [myCalendar ordinalityOfUnit:NSWeekCalendarUnit inUnit:NSYearCalendarUnit forDate:lastDayOfMonth];
        weekOfLastDayOfMonth = week2-week1+1; //[weekOfComponentsLast weekOfMonth];
    }
    
    //Number Of days in months
    numberOfDaysInCurrentMonth= [myCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:firstDayOfMonth].length  ;
    numberOfDaysInPrevMonth= [myCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate dateWithTimeInterval:-secondsPerDay sinceDate:firstDayOfMonth]].length  ;
    numberOfDaysInNextMonth= [myCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate dateWithTimeInterval:secondsPerDay sinceDate:lastDayOfMonth]].length  ;

    //firstDayForSecondRow
    firstDayForFirstRow= numberOfDaysInPrevMonth - weekdayOfFirstDayOfMonth+2;
    firstDayForSecondRow= 7 - weekdayOfFirstDayOfMonth+2;
    
    [self drawCalendarWeekDays];
    
    //dateFormatter for week days "E"-"lun mar mie jue vie sab dom" and month "MMMM"-"marzo"
    NSLocale *myLocale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"locale", @"")];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatStringMonth   = [NSDateFormatter dateFormatFromTemplate:@"MMMM" options:0 locale:myLocale]; 
    [dateFormatter setLocale:myLocale];
    [dateFormatter setDateFormat:formatStringMonth];
    monthLabel.font=myFontMonthYear;
    monthLabel.text=[NSString stringWithFormat:@"%@ %d", [dateFormatter stringFromDate:firstDayOfMonth],currentYear  ];
    [monthLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorCalendarMonthTitle]];

    
    //Add notification observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startCalendarActivityIndicators) name:@"startCalendarActivityIndicators" object:nil]; 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopCalendarActivityIndicators) name:@"stopCalendarActivityIndicators" object:nil]; 

    //Add UIActivityIndicator
    self.myViewActivity= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [myViewActivity setHidesWhenStopped:YES];
    myViewActivity.frame=CGRectMake(150,170,20,20);
    [self.mainView addSubview:myViewActivity];

    
    [self drawCalendar];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) drawCalendarWeekDays
{
    NSTimeInterval secondsPerDay= 24*60*60;

    //Labels for Lun-Mar-Mie-Jue-Vie-Sab-Dom
    NSDateComponents *compsWeekDayText = [[NSDateComponents alloc] init];
    //[compsWeekDayText setWeekday:2];
    [compsWeekDayText setDay:firstDayForFirstRow];
    if (firstDayForFirstRow>7) 
    {
        [compsWeekDayText setMonth:currentMonth-1];
        [compsWeekDayText setYear:currentYear];

        if ((currentMonth-1 )<1 ) {
            [compsWeekDayText setMonth:12];
            [compsWeekDayText setYear:currentYear-1];

        }
    }else
    {
        [compsWeekDayText setMonth:currentMonth];
        [compsWeekDayText setYear:currentYear];

    }
     
     [compsWeekDayText setHour:18];
     [compsWeekDayText setMinute:30];
     
     //dateFormatter for week days "E"-"lun mar mie jue vie sab dom" and month "MMMM"-"marzo"
    NSDate *firstDayOfWeek= [NSDate dateWithTimeInterval:0 sinceDate:[myCalendar dateFromComponents:compsWeekDayText] ];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *myLocale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"locale", @"")];
    //[dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setLocale:myLocale ];
    
    NSString *formatStringWeekDay = [NSDateFormatter dateFormatFromTemplate:@"E" options:0 locale:myLocale]; 
    
    //Draw WeekDay Text,  "lun mar mie jue vie sab dom"
    [dateFormatter setDateFormat:formatStringWeekDay];
    
    UIFont *myFontDays= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:19];

    weekDay1.font=myFontDays;
    weekDay2.font=myFontDays;
    weekDay3.font=myFontDays;
    weekDay4.font=myFontDays;
    weekDay5.font=myFontDays;
    weekDay6.font=myFontDays;
    weekDay7.font=myFontDays;
    
    weekDay1.text=[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:secondsPerDay*0 sinceDate:firstDayOfWeek ]  ]];
    weekDay2.text=[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:secondsPerDay*1 sinceDate:firstDayOfWeek ]  ]];
    weekDay3.text=[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:secondsPerDay*2 sinceDate:firstDayOfWeek ]  ]];
    weekDay4.text=[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:secondsPerDay*3 sinceDate:firstDayOfWeek ]  ]];
    weekDay5.text=[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:secondsPerDay*4 sinceDate:firstDayOfWeek ]  ]];
    weekDay6.text=[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:secondsPerDay*5 sinceDate:firstDayOfWeek ]  ]];
    weekDay7.text=[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:secondsPerDay*6 sinceDate:firstDayOfWeek ]  ]];
    
     [weekDay1 setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorCalendarWeekDayTitle]];
    [weekDay2 setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorCalendarWeekDayTitle]];
    [weekDay3 setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorCalendarWeekDayTitle]];
    [weekDay4 setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorCalendarWeekDayTitle]];
    [weekDay5 setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorCalendarWeekDayTitle]];
    [weekDay6 setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorCalendarWeekDayTitle]];
    [weekDay7 setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorCalendarWeekDayTitle]];


}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) goToPreviousMonth
{
    [self.delegate previousMonthAnimated:YES];
}

-(IBAction) goToNextMonth
{
    [self.delegate nextMonthAnimated:YES];
    
}

-(void) drawCalendar
{
    
    for (int i=0; i<[self.mainView.subviews count];i++  ) 
    {
        UIView *theView= [self.mainView.subviews objectAtIndex:i];
        if ( [theView isKindOfClass: [CalendarDayView class]] ) 
            [theView removeFromSuperview];
    }

    
    // Drawing code
    int y=100; //90 //70
    for (int i=0;i<weekOfLastDayOfMonth; i++) 
    {
         int x=3;
        for (int j=0;j<7;j++) 
        {
            CalendarDayView *tempDayView=[[CalendarDayView alloc] initWithFrame:CGRectMake(x,y,42, 42)];
            tempDayView.dayText=[self calculateDayOfMonthForRow:i andColumn:j forDay:tempDayView];
            //tempDayView.dayImage=[UIImage imageNamed:@"dressApp.png"];
            tempDayView.delegate=self;
            [tempDayView initView];
            [self.mainView addSubview:tempDayView];
            x+=45;
            
        }
        y+=45;

    }
     
    [self.mainView bringSubviewToFront:self.myViewActivity];
    
}

-(void) startCalendarActivityIndicators
{
    [self.myViewActivity startAnimating];
}

-(void) stopCalendarActivityIndicators
{
    [self.myViewActivity stopAnimating];
}

-(NSString*) calculateDayOfMonthForRow:(NSInteger)row andColumn:(NSInteger)column forDay:(CalendarDayView*)dayView
{
    NSString *day=@"";
    //row and column starts in 0:
    if (row==weekOfFirstDayOfMonth-1) //FIRST ROW OF MONTH
    {
        
        if (column>=weekdayOfFirstDayOfMonth-1) //this month first days 1-2-3-4
        {
            day= [NSString stringWithFormat:@"%d",  column-weekdayOfFirstDayOfMonth+2];
            [self dateAndImageForMonthDay:column-weekdayOfFirstDayOfMonth+2 forDayView:dayView];
            if (column<5)
                [dayView setDayTypeStyle:CalendarDayTypeStyleNormal];
            else
                [dayView setDayTypeStyle:CalendarDayTypeStyleWeekend];
            
            
        }else //previous month - last days  28-29-30
        {
            day= [NSString stringWithFormat:@"%d",  firstDayForFirstRow +column];
                [dayView setDayTypeStyle:CalendarDayTypeStyleOtherMonth];
        }

    } 
    else if (row==weekOfLastDayOfMonth-1) //LAST ROW OF MONTH
    {
        if (column<=weekdayOfLastDayOfMonth-1) // 29-30-31
        {
            day= [NSString stringWithFormat:@"%d", firstDayForSecondRow+ 7*(row-1) + column];
            [self dateAndImageForMonthDay:firstDayForSecondRow+ 7*(row-1) + column forDayView:dayView];
            if (column<5)
                [dayView setDayTypeStyle:CalendarDayTypeStyleNormal];
            else
                [dayView setDayTypeStyle:CalendarDayTypeStyleWeekend];
        }else //next month 1-2-3
        {
            day= [NSString stringWithFormat:@"%d", column- weekdayOfLastDayOfMonth+1];
                [dayView setDayTypeStyle:CalendarDayTypeStyleOtherMonth];
        }
        
    }else //SECOND ROW TO LAST ROW OF MONTH 
    {

        day= [NSString stringWithFormat:@"%d", firstDayForSecondRow+ 7*(row-1) + column];
        [self dateAndImageForMonthDay:firstDayForSecondRow+ 7*(row-1) + column forDayView:dayView];
        if (column<5)
            [dayView setDayTypeStyle:CalendarDayTypeStyleNormal];
        else
            [dayView setDayTypeStyle:CalendarDayTypeStyleWeekend];
        
    }

 
    return day;
    
}

-(void) dateAndImageForMonthDay:(NSInteger)dayMonth forDayView:(CalendarDayView*)dayView
{

    //First day of month properties
    NSDateComponents *compsDayMonth = [[NSDateComponents alloc] init];
    [compsDayMonth setDay:dayMonth];
    [compsDayMonth setMonth:currentMonth];
    [compsDayMonth setYear:currentYear];
    [compsDayMonth setHour:20];
    [compsDayMonth setMinute:00];
    NSDate *dayDate =[myCalendar dateFromComponents:compsDayMonth];

    dayView.dayDate=dayDate;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"CalendarConjunto" inManagedObjectContext:self.managedObjectContext];

    if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
        request.predicate = [NSPredicate predicateWithFormat:@" (fecha == %@) AND (usuario == %@)",dayDate,[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]  ];
    else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
        request.predicate = [NSPredicate predicateWithFormat:@" (fecha == %@) AND ((usuario == %@) OR (usuario == %@) OR (usuario == %@)  )",dayDate,[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]  ];
    
	NSError *error = nil;
    NSArray *fetchResults= [self.managedObjectContext executeFetchRequest:request error:&error] ;
	CalendarConjunto *calendarConjuntoItem = [fetchResults lastObject];
    
    if ([fetchResults count]>0)  //si hay un calendar item con fecha actual 
    {
        NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",calendarConjuntoItem.conjunto.urlPicture] ]; 
        if ( [fileManager fileExistsAtPath:imagePath] ) 
            dayView.dayImage= [ [UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePath] ] ;  

    }
    else
        dayView.dayImage=nil;
        
}

#pragma mark - CalendarDayViewDelegate methods
-(void) calendarDaySelectedForDate:(NSDate *)fecha
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"CalendarConjunto" inManagedObjectContext:self.managedObjectContext];

    if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
        request.predicate = [NSPredicate predicateWithFormat:@" (fecha == %@) AND (usuario == %@)",fecha,[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]  ];
    else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
        request.predicate = [NSPredicate predicateWithFormat:@" (fecha == %@) AND ((usuario == %@) OR (usuario == %@) OR (usuario == %@)  )",fecha,[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] ,DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"] ];

	NSError *error = nil;
    NSArray *fetchResults= [self.managedObjectContext executeFetchRequest:request error:&error] ;
    
	CalendarConjunto *calendarConjuntoItem = [fetchResults lastObject];
   
    if ([fetchResults count]==0)  //crea item a fecha actual 
        [self.delegate calendarCreateNewEntryForDay:fecha];
    else   //Open Calendar Details
        [self.delegate calendarEditEntryForDay:fecha];

}



@end
