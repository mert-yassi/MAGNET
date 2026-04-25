#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#include "params.h"
#include "utils.h"
#include "gadgets.h"
#include "masked_algorithms.h"

int main(void) {
    seed_xoshiro();
#ifdef TIME
    printf("\nRunning with Masking Order-%d, N = %d, lambda = %d, varying sigmas [2^0,...,2^10]:\n\n", MASK_ORDER, N, LMD);    
    for(int j = 0; j < 11; j++) {
        init_parameters(j);
        printf("sigma = %d\n", SIG);
#elif defined(VERIFY)
        init_parameters(4); // Change sigma accordingly (check params.c)
        printf("\nRunning with Masking Order-%d, N = %d, lambda = %d, sigma = %d:\n\n", MASK_ORDER, N, LMD, SIG);    
#endif
        // --- SHARED SETUP & ALLOCATION ---
        double geo_bias[kap], Bexp_bias[l];
        for(int i = 0; i < kap; ++i) geo_bias[i] = pow(p, (1 << i)) / (1 + pow(p, (1 << i)));
        for(int i = 0; i < l; ++i) Bexp_bias[i] = exp(-(1 << i) / r);
          
        uint32_t *p_lap = (uint32_t*)malloc((mu * NUM_SHARES) * sizeof(uint32_t));
        uint32_t *p_geo = (uint32_t*)malloc((kap * mu * NUM_SHARES) * sizeof(uint32_t));
        uint32_t *p_exp = (uint32_t*)malloc((l * mu * NUM_SHARES) * sizeof(uint32_t));
        uint32_t *samps = (uint32_t*)malloc((m * NUM_SHARES) * sizeof(uint32_t));
        
        bin_rep(p_lap, dlap_bias);
        bin_rep_arr(p_geo, kap, geo_bias);
        bin_rep_arr(p_exp, l, Bexp_bias);

        uint32_t one[NUM_SHARES] = {0}, mSIG[NUM_SHARES] = {0};
        one[0] = 1;
        mSIG[0] = -round(SIG);
        Refresh(one);
        Refresh(mSIG);
#ifdef TIME
        // --- EXECUTION: TIME MODE ---
        double start_t, end_t, runs[ITER];
        for(int i = 0; i < ITER; ++i) {
            start_t = clock();
            MAGNET(samps, mSIG, one, p_geo, p_exp, p_lap);
            end_t = clock();
            runs[i] = (double)(end_t - start_t) / CLOCKS_PER_SEC;
        }
        
        double med = calc_median(runs);
        printf("Median of %d runs: %.2f s\n\n", ITER, med);

        free(p_lap);
        free(p_geo);
        free(p_exp);
        free(samps);
    }
#elif defined(VERIFY)
    // --- EXECUTION: VERIFY MODE ---
    MAGNET(samps, mSIG, one, p_geo, p_exp, p_lap);

    FILE *outfile = fopen("samples.txt", "w");
    for (int i = 0; i < N; i++) fprintf(outfile, "%d ", (int32_t)FullXOR(&samps[i * NUM_SHARES]));
    fprintf(outfile, "%d ", (int32_t)(SIG * SIG));
    fprintf(outfile, "%d ", N);
    fclose(outfile);

    free(p_lap);
    free(p_geo);
    free(p_exp);
    free(samps);

    exit(system("python3 discretegauss.py")); // plotting samples using the code from "The Discrete Gaussian for Differential Privacy [CKS20]"
#endif     

    return 0;
}
