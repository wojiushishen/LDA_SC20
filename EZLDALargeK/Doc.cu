#include "Doc.cuh"

Document::Document(string argFilePrefix, int argNumChunks, int argMaxTLLength, int argmaxDocLength, int argWordLength) {

	filePrefix = argFilePrefix;
	numChunks = argNumChunks;
	maxTLLength = argMaxTLLength;
	maxDocLength = argmaxDocLength;
	wordLength = argWordLength;
	perplexityMid = new double[GridDim*BlockDim / 32];
	
}

void Document::loadDocument() {


	TLLengthVec = new int[numChunks];
	docLengthVec = new int[numChunks];
	numOfTokenVecD = new int[numChunks];
	numOfTokenVecS = new int[numChunks];

	ifstream docLength((filePrefix + string("/docLength.txt")).c_str(), ios::binary);//store max Doc and DT length
	ifstream TLLength((filePrefix + string("/TLLength.txt")).c_str(), ios::binary);
	ifstream TLSplit((filePrefix + string("/TLSplit.txt")).c_str(), ios::binary);

	for (int chunkId = 0; chunkId < numChunks; chunkId++) {

		TLLength >> TLLengthVec[chunkId];
		docLength >> docLengthVec[chunkId];
		TLSplit >> numOfTokenVecD[chunkId] >> numOfTokenVecS[chunkId];
		DocChunk tmpDocChunk(TLLengthVec[chunkId], docLengthVec[chunkId], wordLength);
		tmpDocChunk.CPUMemSet();
		tmpDocChunk.loadChunk(filePrefix, chunkId);
		docChunkVec.push_back(tmpDocChunk);

	}
	printf("All chunks loaded!");
	docLength.close();
	TLLength.close();

}

void Document::CPU2GPUPerplexity() {

	
	memset(perplexityMid, 0, GridDim*BlockDim / 32 * sizeof(double));
	cudaMemcpy(devicePerplexityMid, perplexityMid, (GridDim*BlockDim / 32) * sizeof(double), cudaMemcpyHostToDevice);

}


void Document::GPU2CPUPerplexity() {

	cudaMemcpy(perplexityMid, devicePerplexityMid, (GridDim*BlockDim / 32) * sizeof(double), cudaMemcpyDeviceToHost);
	sumPerplexity = 0.0;


	for (int i = 0; i < GridDim*BlockDim / 32; i++) {
		//printf("Perplexity:%f \n", h_PerplexityMid[i]);
		sumPerplexity += perplexityMid[i]/ 737869056.0;
	}

	printf("Parallel Perplexity:%f \n", sumPerplexity);



}



void Document::GPUMemAllocate() {

	cudaMalloc((void**)&deviceTLTopic, (maxTLLength) * sizeof(int));
	cudaMalloc((void**)&deviceTLDocCount, (maxDocLength) * sizeof(int));
	cudaMalloc((void**)&deviceTLDocOffset, (maxDocLength) * sizeof(int));
	cudaMalloc((void**)&deviceTLWordCount, (wordLength) * sizeof(int));
	cudaMalloc((void**)&deviceTLWordOffset, (wordLength) * sizeof(int));
	cudaMalloc((void**)&deviceMapWord2Doc, (maxTLLength) * sizeof(int));
	cudaMalloc((void**)&deviceMapDoc2Word, (maxTLLength) * sizeof(int));
	cudaMalloc((void**)&devicePerplexity, (maxTLLength) * sizeof(double));
	cudaMalloc((void**)&devicePerplexityMid, sizeof(double)*(GridDim*BlockDim / 32));
	
	cudaMalloc((void **)&d_blockCounter, sizeof(int)*(1));
	cudaMalloc((void **)&d_warpCounter, sizeof(int)*(1));
	cudaMalloc((void **)&d_dense, sizeof(int)*(GridDim*K));
	cudaMalloc((void **)&deviceWTHeadDense, sizeof(double)*(GridDim*K));


	TLMemory = ((3 * maxTLLength + 2 * maxDocLength + 2 * wordLength + GridDim*K) * sizeof(int) + (maxTLLength + GridDim*BlockDim / 32 + GridDim*K) * sizeof(double))/ 1000000000.0;

	printf("Token list memory usage:%f GB\n", TLMemory);


}


void Document::CPU2GPU(int argChunkId) {


	

	cudaMemcpy(deviceTLTopic, docChunkVec[argChunkId].TLTopic, (TLLengthVec[argChunkId]) * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(deviceTLDocCount, docChunkVec[argChunkId].TLDocCount, (docLengthVec[argChunkId]) * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(deviceTLDocOffset, docChunkVec[argChunkId].TLDocOffset, (docLengthVec[argChunkId]) * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(deviceTLWordCount, docChunkVec[argChunkId].TLWordCount, (wordLength) * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(deviceTLWordOffset, docChunkVec[argChunkId].TLWordOffset, (wordLength) * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(deviceMapWord2Doc, docChunkVec[argChunkId].mapWord2Doc, (TLLengthVec[argChunkId]) * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(deviceMapDoc2Word, docChunkVec[argChunkId].mapDoc2Word, (TLLengthVec[argChunkId]) * sizeof(int), cudaMemcpyHostToDevice);


}

void Document::GPU2CPU(int argChunkId) {

	cudaMemcpy(docChunkVec[argChunkId].TLTopic, deviceTLTopic, (TLLengthVec[argChunkId]) * sizeof(int), cudaMemcpyDeviceToHost);


}