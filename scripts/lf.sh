#!/bin/sh

env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest
