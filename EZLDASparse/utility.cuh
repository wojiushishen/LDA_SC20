#ifndef _UTILITY_H_
#define _UTILITY_H_


#include<iostream>
#include<string>
#include <stdio.h>
#include <stdlib.h>

#include<vector>
#include<map>
#include<numeric>

#include <cuda_runtime.h>
#include <cuda.h>
#include <cuda_runtime.h>

#include <curand.h>
#include <curand_kernel.h>
#include <ctime> 
//#include <windows.h>  

#include <fstream>
#include<algorithm>
#include "Argument.cuh"



using namespace std;



__global__ void WT_Update_Kernel(unsigned short int *d_a, int* deviceTLWordCount, int* deviceTLWordOffset, int *d_count, unsigned short int *d_index, unsigned short int *d_value, int *d_slotcount, int *d_slotoffset, int *d_row_sum, unsigned int *d_counter_0, int d_token_amount_0, int *d_dense, int numOfTokenD);

__global__ void DT_Update_Kernel(int *d_Index, unsigned short int *d_a, int *d_count, int *d_slotcount, int *d_slotoffset, int *d_sparse_slotcount, int *d_sparse_slotoffset, unsigned int *d_counter_0, int argD, int *d_dense, long long int* deviceMaxSecTopic, int* deviceDTIndexValue);
//__global__ void WTDen_Update_Kernel(unsigned short int *deviceTopic, int *deviceWTDense, int *deviceTLCount, int *deviceTLOffset, int *deviceWTOffset, int numOfWordD, unsigned int* deviceCounter);

//__global__ void sparseMatrixAdd(int* argCount0, int* argOffset0, int* argNZCount0, unsigned short int* argIndex0, unsigned short int* argValue0, int* argCount1, int* argOffset1, int* argNZCount1, unsigned short int* argIndex1, unsigned short int* argValue1, int* argDense, int argNumRows, unsigned int* deviceCounter, int* argWTRowSum, int numOfWordD);
//__global__ void MaxTopicDense_Update_Kernel(unsigned short int* deviceWordMaxTopic, unsigned short int* deviceWordSecondMaxTopic, int *deviceWTDense, int *deviceTLCount, int *deviceTLOffset, int *deviceWTOffset, int numOfWordD, unsigned int* deviceCounter, int *deviceWTRowSum, int wordLength, float beta, unsigned short int* deviceWordThirdMaxTopic, long long int* deviceMaxSecTopic, float* deviceQArray, float* deviceWordMaxProb, float* deviceWordSecondMaxProb, float* deviceWordThirdMaxProb);

__global__ void MaxTopicSparse_Update_Kernel(unsigned short int* deviceWordMaxTopic, unsigned short int* deviceWordSecondMaxTopic, int *deviceTLCount, int *deviceTLOffset, int *deviceWTOffset, int numOfWordD, unsigned int* deviceCounter, int *deviceWTRowSum, int wordLength, int numOfWordS, int* d_WordListOffset, int* d_SparseWTCount, unsigned short int* d_SparseWTIndex, unsigned short int* d_SparseWTValue, float beta, unsigned short int* deviceWordThirdMaxTopic, long long int* deviceMaxSecTopic, float* deviceQArray, float* deviceWordMaxProb, float* deviceWordSecondMaxProb, float* deviceWordThirdMaxProb, float alpha);

//__global__ void LDAKernelTrain(float alpha, float beta, int* d_Index, unsigned short int* d_TopicIndex, int* d_SparseDTCount, int* d_TokenCountDT, int* d_TokenOffsetDT, int* d_DocListCount, int* d_DocListOffset, int* d_SparseWTCount, unsigned short int* d_SparseWTIndex, unsigned short int* d_SparseWTValue, int* d_TokenCount, int* d_TokenOffset, int* d_WordListCount, int* d_WordListOffset, int* d_WTRowSum, unsigned int* d_blockCounter, int*d_DocIndex, int D, int W, float* d_Perplexity, curandState *randState, float *WTHeadDense, int numOfWordD, int numOfWordS,  unsigned short int* deviceWordMaxTopic, unsigned short int* deviceWordSecondMaxTopic, long long int* deviceMaxSecTopic, int* deviceDTIndexValue);

__global__ void LDAKernelTrainD(float alpha, float beta, int* d_Index, unsigned short int* d_TopicIndex, int* d_SparseDTCount, int* d_TokenCountDT, int* d_TokenOffsetDT, int* d_DocListCount, int* d_DocListOffset, int* deviceNZWTCount, unsigned short int* deviceWTIndex, unsigned short int* deviceWTValue, int* d_TokenCount, int* d_TokenOffset, int* d_WordListCount, int* d_WordListOffset, int* d_WTRowSum, unsigned int* d_blockCounter, int*d_DocIndex, int D, int W, float* d_Perplexity, curandState *randState, float *WTHeadDense, int numOfWordD, unsigned short int* deviceWordMaxTopic, unsigned short int* deviceWordSecondMaxTopic, float* deviceMaxProb, float* deviceThresProb,float* deviceTimeRecord, int tokenSegment, float* deviceRandomfloat, int* deviceEffectiveTokenIndex, int* deviceNewTokenCount, int* deviceDTIndexValue,long long int* deviceMaxSecTopic, float* deviceQArray);

__global__ void LDATrainPerplexityReduce(float *perplexity, float numOfTokens, float* devicePerplexityAve);
__global__ void initRandState(curandState *state);


//__global__ void WTDen_Sum_Update_Kernel(int *deviceWTDense, int *deviceWTRowSum, int *deviceWTOffset, int numOfWordD);

//__global__ void UpdateProbKernelTrainD(float alpha, float beta, int* d_Index, unsigned short int* d_TopicIndex, int* d_SparseDTCount, int* d_TokenCountDT, int* d_TokenOffsetDT, int* d_DocListCount, int* d_DocListOffset, int* d_WTDense, int* d_WTDenseCopy, int* d_TokenCount, int* d_TokenOffset, int* d_WordListCount, int* d_WordListOffset, int* d_WTRowSum, unsigned int* d_blockCounter, int*d_DocIndex, int D, int W, float* d_Perplexity, curandState *randState, float *WTHeadDense, int numOfWordD,  unsigned short int* deviceWordMaxTopic, unsigned short int* deviceWordSecondMaxTopic, float* deviceMaxProb, float* deviceThresProb,  unsigned short int* deviceWordThirdMaxTopic, float* deviceRandomfloat, int* deviceEffectiveTokenIndex, int* deviceNewTokenCount, int* deviceMaxSecTopic, float* deviceQArray, float* deviceWordMaxProb, float* deviceWordSecondMaxProb, float* deviceWordThirdMaxProb, int tokenSegment);
//__device__ short atomicAddShort(short* address, short val);
//__global__ void UpdateProbKernelTrainD0(float alpha, float beta, int* d_Index, unsigned short int* d_TopicIndex, int* d_SparseDTCount, int* d_TokenCountDT, int* d_TokenOffsetDT, int* d_DocListCount, int* d_DocListOffset, int* d_WTDense, int* d_WTDenseCopy, int* d_TokenCount, int* d_TokenOffset, int* d_WordListCount, int* d_WordListOffset, int* d_WTRowSum, unsigned int* d_blockCounter, int*d_DocIndex, int D, int W, float* d_Perplexity, curandState *randState, float *WTHeadDense, int numOfWordD,  unsigned short int* deviceWordMaxTopic, unsigned short int* deviceWordSecondMaxTopic, float* deviceMaxProb, float* deviceThresProb,  unsigned short int* deviceWordThirdMaxTopic, float* deviceRandomfloat, int* deviceEffectiveTokenIndex, int* deviceNewTokenCount, int* deviceMaxSecTopic, float* deviceQArray, float* deviceWordMaxProb, float* deviceWordSecondMaxProb, float* deviceWordThirdMaxProb, int tokenSegment, unsigned short int* deviceTotalTokenCount);
__global__ void UpdateProbKernelTrainD1(float alpha, float beta, int* d_Index, unsigned short int* d_TopicIndex, int* d_SparseDTCount, int* d_TokenCountDT, int* d_TokenOffsetDT, int* d_DocListCount, int* d_DocListOffset, int* d_TokenCount, int* d_TokenOffset, int* d_WordListCount, int* d_WordListOffset, int* d_WTRowSum, unsigned int* d_blockCounter, int*d_DocIndex, int D, int W, float* d_Perplexity, curandState *randState, float *WTHeadDense, int numOfWordD,  unsigned short int* deviceWordMaxTopic, unsigned short int* deviceWordSecondMaxTopic, float* deviceMaxProb, float* deviceThresProb,  unsigned short int* deviceWordThirdMaxTopic, float* deviceRandomfloat, int* deviceEffectiveTokenIndex, int* deviceNewTokenCount, long long int* deviceMaxSecTopic, float* deviceQArray, float* deviceWordMaxProb, float* deviceWordSecondMaxProb, float* deviceWordThirdMaxProb, int tokenSegment,int* deviceNZWTCount, unsigned short int* deviceWTIndex, unsigned short int* deviceWTValue, int* deviceWTRowSum);
//__global__ void UpdateProbKernelTrainD2(float alpha, float beta, int* d_Index, unsigned short int* d_TopicIndex, int* d_SparseDTCount, int* d_TokenCountDT, int* d_TokenOffsetDT, int* d_DocListCount, int* d_DocListOffset, int* d_WTDense, int* d_WTDenseCopy, int* d_TokenCount, int* d_TokenOffset, int* d_WordListCount, int* d_WordListOffset, int* d_WTRowSum, unsigned int* d_blockCounter, int*d_DocIndex, int D, int W, float* d_Perplexity, curandState *randState, float *WTHeadDense, int numOfWordD,  unsigned short int* deviceWordMaxTopic, unsigned short int* deviceWordSecondMaxTopic, float* deviceMaxProb, float* deviceThresProb,  unsigned short int* deviceWordThirdMaxTopic, float* deviceRandomfloat, int* deviceEffectiveTokenIndex, int* deviceNewTokenCount, int* deviceMaxSecTopic, float* deviceQArray, float* deviceWordMaxProb, float* deviceWordSecondMaxProb, float* deviceWordThirdMaxProb, int tokenSegment);
__global__ void WTRow_Sum_Update_Kernel(int *deviceNZWTCount, int *deviceWTOffset, unsigned short int *deviceWTIndex, unsigned short int* deviceWTValue, int* deviceWTRowSum, int wordLength);

#endif
