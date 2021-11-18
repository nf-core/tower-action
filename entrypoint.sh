#!/bin/sh

# Health check - print basic settings
tw info

# Print the params input to a file
echo $PARAMETERS > params.json

# Hack to convert profiles JSON to csv
echo $CONFIG_PROFILES | jq -r '. | @csv' | sed 's/"//g'

# Launch the pipeline
tw launch $PIPELINE \
    --params=params.json \
    ${WORKDIR:+"--work-dir=$WORKDIR"} \
    ${TOWER_COMPUTE_ENV:+"--compute-env=$TOWER_COMPUTE_ENV"} \
    ${REVISION:+"--revision=$REVISION"} \
    ${CONFIG_PROFILES:+"--profile=$CONFIG_PROFILES"}
