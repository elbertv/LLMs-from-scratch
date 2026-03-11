#!/bin/bash
# chmod +x activate.sh 
# previo a su ejecución
# source activate.sh

ENV_NAME="_pyinfo"

# 1. Levantar el entorno
source $ENV_NAME/bin/activate

# 2. Cambiar el prompt
export PS1="($ENV_NAME) >>> "