set shell := ["bash", "-c"]

run-kind-vm:
    rundoc run -t vm -r 10 -p 2 -P 10 ./kind.md

run-tutorial-vm:
    rundoc run -t vm -r 10 -p 2 -P 10 ./tutorial1.md

run-kind:
    #!/usr/bin/env bash
    rundoc run -t vm#cloud -r 10 -p 2 -P 10 ./kind.md

run-tutorial:
    #!/usr/bin/env bash
    rundoc run -t vm#cloud -r 10 -p 2 -P 10 ./tutorial1.md