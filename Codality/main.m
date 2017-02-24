//
//  main.m
//  Codality
//
//  Created by Daniel Broad on 25/10/2016.
//  Copyright © 2016 Dorada App Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

int solution_pivot(NSArray *A) {
    // write your code in Objective-C 2.0
    
    // get the array total
    long arrayTotal = 0;
    for (NSNumber *num in A) {
        arrayTotal += [num integerValue];
    }
    
    // iterate through
    long leftHandSide = 0;
    for (int i = 0; i < A.count; i++) {
        NSNumber *num = A[i];
        
        long rightHandSide = arrayTotal - [num integerValue] - leftHandSide;
        NSLog(@"%ld %ld",leftHandSide,rightHandSide);
        if (rightHandSide == leftHandSide) {
            // bingo
            return i;
        }
        
        leftHandSide += [num integerValue];
    }
    
    return -1;
}

int solution_distancespan(NSArray * A, NSUInteger N) {
    NSArray *sorted = [A sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
                       
    for (NSInteger i = 0; i<N/2; i++) {
        for (NSInteger j = N-1; j>=N/2; j--) {
            NSInteger index1 = [sorted indexOfObject:A[i]];
            NSInteger index2 = [sorted indexOfObject:A[j]];
            
            if (labs(index2-index1) == 1) {
                printf("%ld %ld %ld\n",i,j, labs(i-j));
                return (int)labs(i-j);
            }
        }
    }
    return -1;
}

int solution_splitdif(NSArray * A) {
    NSArray *sorted = [A sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSNumber *min = [sorted lastObject];
    NSNumber *max = [sorted firstObject];
    
    return (int) labs(max.integerValue - min.integerValue);
    
}

NSArray *randomTestData() {
    NSMutableArray *array = [NSMutableArray array];
    for (int i =0; i < 99; i++) {
        [array addObject:[NSNumber numberWithInteger:rand() % INT_MAX]];
    }
    return array;
}

void solutionFizzBuzz(int N) {
    // write your code in Objective-C 2.0
    NSDictionary *FizBuzWuf = @{
                               @3: @"Fizz",
                               @5: @"Buzz",
                               @7: @"Woof"
                               };
    for (int i = 1; i<=N; i++) {
        NSMutableString *output = [NSMutableString string];
        for (NSNumber *mod in FizBuzWuf.allKeys) {
            if (i % (mod.integerValue) == 0) {
                [output appendString:[FizBuzWuf objectForKey:mod]];
            }
        }
        if (!output.length) {
            [output appendFormat:@"%d",i];
        }
        printf("%d: %s\n", i, [output cStringUsingEncoding:NSUTF8StringEncoding]);
    }
}

NSString *const kCommand_POP = @"POP";
NSString *const kCommand_DUP = @"DUP";
NSString *const kCommand_Add = @"+";
NSString *const kCommand_Subtract = @"-";

NSInteger const MAX_NUMBER = 1048575; // pow(2,20)-1;
NSInteger const kMachineDidError = -1;

NSInteger pop(NSMutableArray *array) {
    if (!array.count) {
        @throw [NSException exceptionWithName:@"EmptyStack" reason:@"Stack is Empty, cannot Pop" userInfo:nil];
    }
    NSNumber *toPop = [array lastObject];
    [array removeObjectAtIndex:array.count-1];
    NSInteger val = [toPop integerValue];
    if (val < 0) { @throw [NSException exceptionWithName:@"Negative" reason:@"Negative value error" userInfo:nil]; };
    if (val > MAX_NUMBER) { @throw [NSException exceptionWithName:@"Bounds" reason:@"Max bounds error" userInfo:nil]; };
    return val;
};

void push(NSMutableArray *array, NSInteger value) {
    NSNumber *numeric = [NSNumber numberWithInteger:value];
    [array addObject:numeric];
}

NSInteger peek(NSMutableArray *array) {
    if (!array.count) {
        @throw [NSException exceptionWithName:@"EmptyStack" reason:@"Stack is Empty, cannot Peek" userInfo:nil];
    }
    return [[array lastObject] integerValue];
}

int solutionStackMachine(NSString *S) {
    @try {
        NSMutableArray *theStack = [NSMutableArray array];
        NSArray *supportedCommands = @[kCommand_Add,kCommand_Subtract,kCommand_DUP,kCommand_POP];
        
        NSArray *commands = [S componentsSeparatedByString:@" "];
        
        for (NSString *command in commands) {
            NSUInteger index = [supportedCommands indexOfObject:command];
            
            switch (index) {
                case 0: // kCommand_Add
                    if (theStack.count > 1) { // give better error messages than just throwing inside pop
                        NSInteger op1 = pop(theStack);
                        NSInteger op2 = pop(theStack);
                        push(theStack, op1 + op2);
                    } else {
                        @throw [NSException exceptionWithName:@"Add2" reason:@"Addition requires 2 operands" userInfo:nil];
                    }
                    break;
                case 1: // kCommand_Subtract
                    if (theStack.count > 1) { // give better error messages than just throwing inside pop
                        NSInteger op1 = pop(theStack);
                        NSInteger op2 = pop(theStack);
                        push(theStack, op1 - op2);
                    } else {
                        @throw [NSException exceptionWithName:@"Sub2" reason:@"Subtraction requires 2 operands" userInfo:nil];
                    }
                    break;
                case 2: // kCommand_DUP
                    if (theStack.count) {
                        push(theStack, peek(theStack));
                    } else {
                        @throw [NSException exceptionWithName:@"DUP" reason:@"DUP on an empty stack!" userInfo:nil];
                    }
                    
                    break;
                case 3: // kCommand_POP
                    if (theStack.count) { // give better error messages than just throwing inside pop
                        pop(theStack);
                    } else {
                        @throw [NSException exceptionWithName:@"POP" reason:@"POP on empty stack!" userInfo:nil];
                    }
                    
                    break;
                default:
                    push(theStack,[command integerValue]);
                    
            }
            
            // NSLog(@"%@",theStack);
        }
        
        return (int) pop(theStack);
    }
    @catch (NSException *ex) {
        printf("%s\n\n",[ex.description cStringUsingEncoding:NSUTF8StringEncoding]);
        return kMachineDidError;
    }

}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
         printf("Answer is %d\n",solution_pivot(@[@-1,@3,@-4,@5,@1,@-6,@2,@1]));
         printf("Answer is %d\n",solution_pivot(@[@-1,@3,@-4,@5,@1,@-6,@2,@INT_MAX]));
        printf("Answer is %d\n",solution_distancespan(@[@1,@4,@7,@3,@3,@5],@[@1,@4,@7,@3,@3,@5].count));
        printf("Answer is %d\n",solution_distancespan(@[@1,@4,@7,@3,@3,@INT_MAX],@[@1,@4,@7,@3,@3,@INT_MAX].count));
        printf("Answer is %d\n",solution_distancespan(@[@1,@2,@7,@3,@3],@[@1,@2,@7,@3,@3].count));
        
        printf("Answer is %d\n",solution_splitdif(@[@1,@3,@-3]));
        printf("Answer is %d\n",solution_splitdif(@[@4,@3,@2,@5,@1,@1]));
        
        solutionFizzBuzz(INT_MAX);
        randomTestData();
        
        printf("Answer is %d\n",solutionStackMachine(@"DUP 4 POP 5 DUP + DUP + -"));
        printf("Answer is %d\n",solutionStackMachine(@"POP 4 POP 5 DUP + DUP + -"));
        printf("Answer is %d\n",solutionStackMachine(@"4 +"));
        printf("Answer is %d\n",solutionStackMachine(@"4 -"));
        printf("Answer is %d\n",solutionStackMachine(@"3 DUP 5 - -"));
        printf("Answer is %d\n",solutionStackMachine(@"13 DUP 4 POP 5 DUP + DUP + -"));
        printf("Answer is %d\n",solutionStackMachine(@"4 POP"));
    }
    return 0;
}


