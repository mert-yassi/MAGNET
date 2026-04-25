#ifndef PARAMS_H_
#define PARAMS_H_

#define TIME
//#define VERIFY

#define ITER 100

#ifdef TIME
    #define N 10000 // N to match Figure 7 times
#else
    #define N 100000 // Larger N to plot a nicer distribution
#endif
#define LMD 64 // Security parameter lambda
#define PS 0.76 // Acceptance probability

#define NUM_SHARES 2 // Number of shares
#define MASK_ORDER NUM_SHARES - 1 // Masking order
#define w 32 // Word size
#define W 5 // ceil(log2(w-1))

#define rand_uint32() xoshiro_next()

extern int kap, l, mu, m, SIG;
extern double r, p, dlap_bias;

void init_parameters(int j);

#endif /* PARAMS_H_ */
