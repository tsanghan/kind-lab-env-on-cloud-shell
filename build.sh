#!/usr/bin/env bash

source ./versions.rc

envsubst < templates/README.md.tmpl > README.md
envsubst < templates/kind.md.tmpl > kind.md
envsubst < templates/tutorial1.md.tmpl > tutorial1.md