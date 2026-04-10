set shell := ["bash", "-c"]

run-kind:
    rundoc run -t vm -r 10 -p 2 -P 10 ./kind.md

run-tutorial:
    rundoc run -t vm -r 10 -p 2 -P 10 ./tutorial1.md