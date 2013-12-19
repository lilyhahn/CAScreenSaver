//
//  CAScreenSaverView.m
//  CAScreenSaver
//
//  Created by Tobi Hahn on 12/18/13.
//  Copyright (c) 2013 Tobi Hahn. All rights reserved.
//

#import "CAScreenSaverView.h"

@implementation CAScreenSaverView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/3.00];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
    
    NSSize size = [self bounds].size;
    field.resize(size.width / 4);
    for(int i = 0; i < field.size(); i++){
        field[i].resize(size.height / 4); // make field the size of the screen
    }
    unsigned long seedPosX = field.size() / 2;
    unsigned long seedPosY = field[0].size() / 2;
    field[seedPosX][seedPosY] = 1;
    field[seedPosX][seedPosY-1] = 1;
}

- (void)stopAnimation
{
    [super stopAnimation];
}


- (void)animateOneFrame
{
    //first step: render
    for(int i = 0; i < field.size(); i++){
        for(int j = 0; j < field[0].size(); j++){
            //if(field[i][j]){
                NSRect cell;
                cell.size = NSMakeSize(4, 4);
                cell.origin = NSMakePoint(CGFloat(i * 4),CGFloat(j * 4));
                NSBezierPath *path;
                path = [NSBezierPath bezierPathWithRect:cell];
                NSColor *color;
                switch (field[i][j]) {
                    case 1:
                        color = [NSColor colorWithCalibratedRed:1 green:1 blue:1 alpha: 1];
                        break;
                    case 2:
                        color = [NSColor colorWithCalibratedRed:1 green:0 blue:0 alpha: 1];
                        break;
                    default:
                        color = [NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha: 1];
                        break;
                }
                [color set];
                [path fill];
            //}
        }
    }
    std::vector<std::vector<int> > nextField = field;
    for(int i = 0; i < field.size(); i++){
        for(int j = 0; j < field[0].size(); j++){
            if(j < field[0].size()-1 && i < field.size()-1 && j > 1 && i > 1){ //if we are not at the edge
                int neighborhoodSum = 0;
                if(field[i-1][j] == 1) neighborhoodSum++;
                if(field[i+1][j] == 1) neighborhoodSum++;
                if(field[i][j-1] == 1) neighborhoodSum++;
                if(field[i][j+1] == 1) neighborhoodSum++;
                if(field[i-1][j+1] == 1) neighborhoodSum++;
                if(field[i+1][j+1] == 1) neighborhoodSum++;
                if(field[i-1][j-1] == 1) neighborhoodSum++;
                if(field[i+1][j-1] == 1) neighborhoodSum++;
                
                if(field[i][j] == 2) nextField[i][j] = 0;
                if(field[i][j] == 1){
                    nextField[i][j] = 2;
                }
                
                /*neighborhoodSum += field[i-1][j];
                neighborhoodSum += field[i+1][j];
                neighborhoodSum += field[i][j-1];
                neighborhoodSum += field[i][j+1];
                neighborhoodSum += field[i-1][j+1];
                neighborhoodSum += field[i+1][j+1];
                neighborhoodSum += field[i-1][j-1];
                neighborhoodSum += field[i+1][j-1];*/
                if(neighborhoodSum == 2 && !field[i][j]){ // is there nothing here? if so, reproduce
                    nextField[i][j] = 1;
                }
            }
        }
    }
    field = nextField;
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
