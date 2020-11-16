#!/bin/bash

mix openapi.spec.json --spec FsmWeb.ApiSpec && \
    python -m json.tool openapi.json > api/openapi.json && \
    rm openapi.json
