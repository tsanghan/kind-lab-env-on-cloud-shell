set shell := ["bash", "-c"]

rundoc := require("rundoc")
byobu := require("byobu")

default:
    just -l
run-kind:
    #!/usr/bin/env bash
    {{rundoc}} run -t vm#cloud -r 10 -p 2 -P 10 ./kind.md

run-tutorial:
    #!/usr/bin/env bash
    {{rundoc}} run -t vm#cloud -r 10 -p 2 -P 10 ./tutorial1.md

run-vm:
    #!/usr/bin/env bash
    # ChatGPT assisted
    {{byobu}} split-window -v
    {{byobu}} resize-pane -D 10
    {{byobu}} send-keys -t 0 "clear; rundoc run -t vm -r 10 -p 2 -P 10 ./kind.md" C-m
    {{byobu}} send-keys -t 1 "clear; sleep 180 && rundoc run -t vm -r 10 -p 2 -P 10 ./tutorial1.md" C-m
    {{byobu}} select-pane -t 1

clean-vm:
    #!/usr/bin/env bash
    {{byobu}} kill-pane -t 0
    {{byobu}} send-keys -t 1 "kind delete clusters --all; sleep 5; clear" C-m

run-step7:
    #!/usr/bin/env bash
    {{byobu}} select-pane -t 1
    {{byobu}} resize-pane -U 30
    {{byobu}} send-key -t 1 "clear; rundoc run -t vm -r 10 -p 2 -P 10 -s 7 ./tutorial1.md; sleep 15 ; {{byobu}} resize-pane -D 30" C-m
