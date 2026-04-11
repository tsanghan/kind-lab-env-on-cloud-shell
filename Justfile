set shell := ["bash", "-c"]

run-kind:
    #!/usr/bin/env bash
    rundoc run -t vm#cloud -r 10 -p 2 -P 10 ./kind.md

run-tutorial:
    #!/usr/bin/env bash
    rundoc run -t vm#cloud -r 10 -p 2 -P 10 ./tutorial1.md

run-vm:
    #!/usr/bin/env bash
    # ChatGPT assisted
    byobu split-window -v
    byobu resize-pane -D 10
    byobu send-keys -t 0 "rundoc run -t vm -r 10 -p 2 -P 10 ./kind.md" C-m
    byobu send-keys -t 1 "sleep 180 && rundoc run -t vm -r 10 -p 2 -P 10 ./tutorial1.md" C-m
    byobu select-pane -t 1
