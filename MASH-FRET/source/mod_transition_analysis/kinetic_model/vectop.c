/*
 * =============================================================
 * vectop.c 
 * Lists functions used for matrices and vectors operations.
 *
 * Written by Mélodie C.A.S Hadzic, 24.11.2020
 * =============================================================
 */
 
#include <stdio.h>
#include <stdlib.h>
#include "vectop.h"

 
void setVect(double* v, double* v0, int sz){
	int i = 0;
	for (i=0; i<sz; i++){
		v[i] = v0[i];
	}
	return;
}


int linid(int r, int c, int l, int R, int C){
	int id = 0;
	id = l*R*C + c*R + r;
	return id;
}