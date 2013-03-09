#ifndef UTIL_H_GUARD
#define UTIL_H_GUARD

#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include "coneOS.h"

void tic(void); 
float toc(void); 
float tocq(void); 
void printConeData(Data * d,Cone * k);
void printData(Data * d);
void printAll(Data * d, Work * w);

// y += A*x
void accumByA(const cs *A, const double *x, double *y);
// y += A'*x
void accumByATrans(const cs *A, const double *x, double *y);


#endif