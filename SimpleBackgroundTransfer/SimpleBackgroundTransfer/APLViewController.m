/*
     File: APLViewController.m
 Abstract: Main view controller; manages a URLSession.
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import "APLViewController.h"
#import "APLAppDelegate.h"
#include <sqlite3.h>

sqlite3 *db;


#warning To run this sample correctly, you must set an appropriate URL here.
static NSString *DownloadURLString = @"http://www.anibasdesign.com/images/website-design-normandy-france-manche-calvados-orne-eccommerce-blogs-wordpress-gite-websites1.png";


@interface APLViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSURLSessionDownloadTask *downloadTask;


@end


@implementation APLViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.session = [self backgroundSession];

    self.progressView.progress = 0;
    self.imageView.hidden = NO;
    self.progressView.hidden = YES;
    
    [self createDatabase];
}


- (IBAction)start:(id)sender
{
	if (self.downloadTask)
    {
        return;
    }

    /*
     Create a new download task using the URL session. Tasks start in the “suspended” state; to start a task you need to explicitly call -resume on a task after creating it.
     */
    NSURL *downloadURL = [NSURL URLWithString:DownloadURLString];
	NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
	self.downloadTask = [self.session downloadTaskWithRequest:request];
    [self.downloadTask resume];

    self.imageView.hidden = YES;
    self.progressView.hidden = NO;
    exit(0);
}


- (NSURLSession *)backgroundSession
{
/*
 Using disptach_once here ensures that multiple background sessions with the same identifier are not created in this instance of the application. If you want to support multiple background sessions within a single process, you should create each session with its own identifier.
 */
	static NSURLSession *session = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.example.apple-samplecode.SimpleBackgroundTransfer.BackgroundSession"];
		session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
	});
	return session;
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    BLog();

    /*
     Report progress on the task.
     If you created more than one task, you might keep references to them and report on them individually.
     */

    if (downloadTask == self.downloadTask)
    {
        double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        BLog(@"DownloadTask: %@ progress: %lf", downloadTask, progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = progress;
        });
    }
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)downloadURL
{
    BLog();

    /*
     The download completed, you need to copy the file at targetPath before the end of this block.
     As an example, copy the file to the Documents directory of your app.
    */
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [URLs objectAtIndex:0];

    NSURL *originalURL = [[downloadTask originalRequest] URL];
    NSURL *destinationURL = [documentsDirectory URLByAppendingPathComponent:[originalURL lastPathComponent]];
    NSError *errorCopy;

    // For the purposes of testing, remove any esisting file at the destination.
    [fileManager removeItemAtURL:destinationURL error:NULL];
    BOOL success = [fileManager copyItemAtURL:downloadURL toURL:destinationURL error:&errorCopy];
    
    if (success)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:[destinationURL path]];
            self.imageView.image = image;
            self.imageView.hidden = NO;
            self.progressView.hidden = YES;
        });
    }
    else
    {
        /*
         In the general case, what you might do in the event of failure depends on the error and the specifics of your application.
         */
        BLog(@"Error during the copy: %@", [errorCopy localizedDescription]);
    }
#warning insert imagedata into talbe
    NSData *imageData = [NSData dataWithContentsOfURL:downloadURL];
    [self insertIntoTable:originalURL :imageData :0];
    
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    BLog();

    if (error == nil)
    {
        NSLog(@"Task: %@ completed successfully", task);
    }
    else
    {
        NSLog(@"Task: %@ completed with error: %@", task, [error localizedDescription]);
    }
	
    double progress = (double)task.countOfBytesReceived / (double)task.countOfBytesExpectedToReceive;
	dispatch_async(dispatch_get_main_queue(), ^{
		self.progressView.progress = progress;
	});

    self.downloadTask = nil;
}


/*
 If an application has received an -application:handleEventsForBackgroundURLSession:completionHandler: message, the session delegate will receive this message to indicate that all messages previously enqueued for this session have been delivered. At this time it is safe to invoke the previously stored completion handler, or to begin any internal updates that will result in invoking the completion handler.
 */
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    APLAppDelegate *appDelegate = (APLAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }

    NSLog(@"All tasks are finished");
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    BLog();
}


#pragma mark sqlite3
-(void)createDatabase
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSLog(@"URLs : %@",URLs);
    NSURL *documentsDirectory = [URLs objectAtIndex:0];
    NSURL *dbURL = [documentsDirectory URLByAppendingPathComponent:@"image.sqlite"];
    
    sqlite3_open([[dbURL absoluteString] UTF8String],&db);
    if (sqlite3_open([[dbURL absoluteString] UTF8String],&db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"db creation failed!");
    }
#pragma mark imageTable segment: ID/originalURL/iamgeData/Selected
    char *error;
    NSString *sqlStatement = @"CREATE TABLE IF NOT EXISTS IMAGETABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, ORIGINALURL TEXT, IMAGEDATA BLOB, SELECTED INTEGER)";
    
    if (sqlite3_exec(db, [sqlStatement UTF8String], nil, nil, &error)!=SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"create table failed!");
    }
}


-(void)insertIntoTable:(NSURL *)originalURL :(NSData*)imageData :(int)selected
{
     const char* sqliteInsert = "INSERT INTO IMAGETABLE (ORIGINALURL, IMAGEDATA,SELECTED) VALUES (?, ?,?)";
    sqlite3_stmt *insertStatement;
    if (sqlite3_prepare_v2(db, sqliteInsert, -1, &insertStatement, NULL)==SQLITE_OK) {
        sqlite3_bind_text(insertStatement, 1, [[originalURL absoluteString] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_blob(insertStatement, 2, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
        sqlite3_bind_int(insertStatement, 3, selected);
        sqlite3_step(insertStatement);
    }else
    {
        NSLog(@"preperation failed!");
    }
    
    sqlite3_finalize(insertStatement);
}

-(NSData *)retrieveImageDataFromDatabase:(NSURL *)originalURL
{
    NSData *imageData;
    const char *sqliteQuery = "SELECT IMAGEDATA FROM IMAGETABLE WHERE ORIGINALURL=?";
    sqlite3_stmt *queryStatement;
    if (sqlite3_prepare_v2(db, sqliteQuery, -1, &queryStatement, NULL)!= SQLITE_OK) {
        sqlite3_bind_text(queryStatement, 1, [[originalURL absoluteString] UTF8String], -1, NULL);
        if (sqlite3_step(queryStatement) == SQLITE_ROW) {
            int length = sqlite3_column_bytes(queryStatement, 0);
            Byte *dataByte = (Byte *)sqlite3_column_blob(queryStatement, 0);
            imageData = [NSData dataWithBytes:dataByte length:length];
        }
    }
    sqlite3_finalize(queryStatement);
    return imageData;
}



@end
