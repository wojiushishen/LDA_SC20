
#include "WTAddKernel.cuh"
void WTAdditionKernel(WTAll &argWT, Document &argDoc) {


	unsigned int* deviceCounter;
	cudaMalloc(&deviceCounter, sizeof(unsigned int));
	cudaMemset(deviceCounter, 0, sizeof(unsigned int));

	int numOfWordS = argWT.blockCount + argWT.warpCount;
	int numOfWordD = argWT.wordLength - argWT.numOfWordS;

	/*int blockCounter = 0;
	int iterBlock = (argWT.numOfWordS - 1) / GridDim + 1;
	int* deviceWordLength;
	int numOfWordD = argWT.wordLength-argWT.numOfWordS;*/
	/*cudaMalloc((void**)&deviceWordLength, (1) * sizeof(int));
	
	cudaMemcpy(deviceWordLength, &argWT.numOfWordS, sizeof(int),cudaMemcpyHostToDevice);*/
	//for (int i = 0; i < iterBlock; i++) {
	//	cudaMemcpy(argDoc.d_blockCounter, &blockCounter, (1) * sizeof(int), cudaMemcpyHostToDevice);
	sparseMatrixAdd << <GridDim, BlockDim >> >(argWT.deviceWTCount, argWT.deviceWTOffset, argWT.deviceNZWTCount, argWT.deviceWTIndex, argWT.deviceWTValue, argWT.deviceChunkWTCount, argWT.deviceChunkWTOffset, argWT.deviceChunkNZWTCount, argWT.deviceChunkWTIndex, argWT.deviceChunkWTValue, argDoc.d_dense, argWT.numOfWordS, deviceCounter ,argWT.deviceWTRowSum, numOfWordD);
	H_ERR(cudaDeviceSynchronize());
	/*	blockCounter++;
	}*/


}