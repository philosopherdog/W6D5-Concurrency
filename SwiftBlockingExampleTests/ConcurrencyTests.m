//
//  ConcurrencyTests.m
//  ConcurrencyTests
//
//  Created by steve on 2016-05-24.
//  Copyright © 2016 steve. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ConcurrencyTests : XCTestCase

@end

@implementation ConcurrencyTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

// Concurrent Q == Numerous background Qs
// sync == Blocking

- (void)testSyncOnConcurrentQ {
  dispatch_queue_t backgroundQ = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);
  dispatch_sync(backgroundQ, ^{
    printf("%d: 1\n", __LINE__);
  });
  dispatch_sync(backgroundQ, ^{
    printf("%d: 2\n", __LINE__);
  });
  printf("%d mainQ: 3\n", __LINE__);
}


// Serial Q == Single Background Q
// async == Non blocking, next line executes immediately

- (void)testAsyncOnUserCreatedSerialQ {
  dispatch_queue_t backgroundQ = dispatch_queue_create("com.lighthouse.concurrency.2", DISPATCH_QUEUE_SERIAL);
  
  dispatch_async(backgroundQ, ^{
    printf("%d: ~~~~>>>4\n", __LINE__);
  });
  
  printf("%d: 5\n", __LINE__);
  
  dispatch_async(backgroundQ, ^{
    printf("%d: ~~~~>> 6\n", __LINE__);
  });
  
  for (NSInteger i = 0; i < 100; ++i) {
    printf("%d: 7\n", __LINE__);
  }
  
  printf("%d: ENDED\n", __LINE__);
}

// Concurrent Q == Numerous background Qs
// sync == Blocking

- (void)testSyncOnUserCreatedConcurrentQ {
  dispatch_queue_t backgroundQ = dispatch_queue_create("com.lighthouse.concurrency.3", DISPATCH_QUEUE_CONCURRENT);
  
  dispatch_sync(backgroundQ, ^{
    printf("%d: bgQ 4\n", __LINE__);
  });
  printf("%d: mainQ 5\n", __LINE__);
  
  dispatch_sync(backgroundQ, ^{
    printf("%d: bgQ 6\n", __LINE__);
  });
  
  printf("%d: mainQ 7\n", __LINE__);
}


- (void)testDispatchOnce {
  static dispatch_once_t onceToken;
  __block int num = 0;
  
  void (^block)(void) = ^ {
    num += 1;
    printf("%d 8 is %d\n", __LINE__, num);
  };
  
  dispatch_once(&onceToken, block);
  
  XCTAssertTrue(num == 1);
  
  dispatch_once(&onceToken, block);
  
  XCTAssertFalse(num == 2);
}

// NSOperationQueue
- (void)testAddExecutionBlock {
  NSOperationQueue *backgroundQ = [[NSOperationQueue alloc] init];
  // optional settings
  backgroundQ.maxConcurrentOperationCount = 100;
  backgroundQ.qualityOfService = NSQualityOfServiceUserInitiated;
  // NSOperationQueue needs an NSOperation subclass to run
  NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
    NSLog(@"%d: ==>>  <<<===",__LINE__);
  }];
  [block addExecutionBlock:^{
    NSLog(@"%d: ==>> ",__LINE__);
  }];
  [backgroundQ addOperation:block];
}

- (void)testCurrentQIsTheMainQ {
  // prove the current queue is the main queue
  NSOperationQueue *mainQ = [NSOperationQueue mainQueue];
  XCTAssertTrue([mainQ isEqual:[NSOperationQueue currentQueue]]);
}

- (void)testBackgroundQIsNotTheMainQ {
  NSOperationQueue *backgroundQ = [[NSOperationQueue alloc] init];
  XCTAssertFalse([backgroundQ isEqual:[NSOperationQueue mainQueue]]);
}

- (void)testOperationQueueDependency {
  typedef NS_ENUM(NSUInteger, Order) {
    OrderUndetermined,
    OrderFirst,
    OrderSecond,
  };
  
  __block Order order = OrderUndetermined;
  
  NSOperationQueue *backgroundQ = [[NSOperationQueue alloc] init];
  NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
    printf("%d ===>>> first block\n",__LINE__);
    if (order == OrderUndetermined) {
      order = OrderFirst;
    }
  }];
  NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
    printf("%d ===>>> second block\n", __LINE__);
    if (order == OrderUndetermined) {
      order = OrderSecond;
    }
  }];
  [blockOperation1 addDependency:blockOperation2];
  // adding multiple operations
  [backgroundQ addOperations:@[blockOperation1, blockOperation2] waitUntilFinished:YES];
  XCTAssertTrue(order == OrderSecond, @"blockOperation1 should depend on blockOperation2, and should only run after blockOperation2 runs");
}


@end
