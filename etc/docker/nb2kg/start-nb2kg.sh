#!/bin/bash

export NB_PORT=${NB_PORT:-8888}
export GATEWAY_HOST=${GATEWAY_HOST:-localhost}
export KG_URL=${KG_URL:-http://${GATEWAY_HOST}:8888}
export KG_HTTP_USER=${KG_HTTP_USER:-jovyan}
export KG_REQUEST_TIMEOUT=${KG_REQUEST_TIMEOUT:-30}
export KERNEL_USERNAME=${KG_HTTP_USER}

echo "Starting nb2kg against gateway: " ${KG_URL}
echo "Nootbook port: " ${NB_PORT}
echo "Kernel user: " ${KERNEL_USERNAME}

CMD=${1:-"notebook"}
if [[ "${CMD}" == "lab" ]];
then
	jupyter serverextension enable --py jupyterlab --sys-prefix
elif [[ "${CMD}" != "notebook" ]];
then
	echo ""
	echo "usage: <docker run arguments> [notebook | lab]"
	echo "Entering shell..."
	/bin/bash
	exit 0
fi

jupyter ${CMD} \
  --NotebookApp.session_manager_class=nb2kg.managers.SessionManager \
  --NotebookApp.kernel_manager_class=nb2kg.managers.RemoteKernelManager \
  --NotebookApp.kernel_spec_manager_class=nb2kg.managers.RemoteKernelSpecManager \
  --no-browser \
  --NotebookApp.port=${NB_PORT} \
  --NotebookApp.ip=0.0.0.0
