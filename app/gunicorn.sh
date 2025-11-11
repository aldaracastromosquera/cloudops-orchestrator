#!/usr/bin/env bash
set -e
exec gunicorn -w 2 -b 0.0.0.0:8000 main:app
