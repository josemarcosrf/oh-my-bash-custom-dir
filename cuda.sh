# CUDA stuff
export CUDA_HOME=/usr/local/cuda    # requieres a soflink to cuda-8.0 or similar
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${CUDA_HOME}/lib64:${CUDA_HOME}/lib64/extras/CUPTI/lib64"
export PATH="${CUDA_HOME}/bin:$PATH"

