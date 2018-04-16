#!/bin/bash

if [ ! -f /notebooks/anaconda3/bin/jupyter ]; then
   mv /notebooks.bak/* /notebooks/
fi

echo "export PATH=/usr/local/cuda-8.0/bin${PATH:+:${PATH}}" >> /etc/profile
echo "export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64\${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> /etc/profile
source /etc/profile && ldconfig

export SHELL=/bin/bash

/notebooks/anaconda3/bin/jupyter notebook --allow-root "$@"
