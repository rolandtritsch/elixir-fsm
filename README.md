# Implementing a simple finite state machine

This repo implements a simple finite state machine.

The state machine models a simple job worker system.

[![STD](https://mermaid.ink/img/eyJjb2RlIjoic3RhdGVEaWFncmFtXG5cdFsqXSAtLT4gQ3JlYXRlZDogY3JlYXRlXG4gIENyZWF0ZWQgLS0-IFNjaGVkdWxlZCA6IHNjaGVkdWxlXG4gIENyZWF0ZWQgLS0-IEluaXRpYWxpemVkIDogc3RhcnRcbiAgU2NoZWR1bGVkIC0tPiBJbml0aWFsaXplZCA6IHN0YXJ0XG4gIEluaXRpYWxpemVkIC0tPiBSdW5uaW5nIDogcnVuXG4gIFJ1bm5pbmcgLS0-IFByb2Nlc3NpbmcgOiBwcm9jZXNzXG4gIFByb2Nlc3NpbmcgLS0-IEZhaWxlZCA6IGZhaWx1cmVcbiAgUHJvY2Vzc2luZyAtLT4gUnVubmluZyA6IHN1Y2Nlc3NcbiAgRmFpbGVkIC0tPiBbKl0gOiBkb25lXG4gIFJ1bm5pbmcgLS0-IFsqXSA6IGRvbmVcblxuXHRcdFx0XHRcdCIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0In0sInVwZGF0ZUVkaXRvciI6ZmFsc2V9)](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoic3RhdGVEaWFncmFtXG5cdFsqXSAtLT4gQ3JlYXRlZDogY3JlYXRlXG4gIENyZWF0ZWQgLS0-IFNjaGVkdWxlZCA6IHNjaGVkdWxlXG4gIENyZWF0ZWQgLS0-IEluaXRpYWxpemVkIDogc3RhcnRcbiAgU2NoZWR1bGVkIC0tPiBJbml0aWFsaXplZCA6IHN0YXJ0XG4gIEluaXRpYWxpemVkIC0tPiBSdW5uaW5nIDogcnVuXG4gIFJ1bm5pbmcgLS0-IFByb2Nlc3NpbmcgOiBwcm9jZXNzXG4gIFByb2Nlc3NpbmcgLS0-IEZhaWxlZCA6IGZhaWx1cmVcbiAgUHJvY2Vzc2luZyAtLT4gUnVubmluZyA6IHN1Y2Nlc3NcbiAgRmFpbGVkIC0tPiBbKl0gOiBkb25lXG4gIFJ1bm5pbmcgLS0-IFsqXSA6IGRvbmVcblxuXHRcdFx0XHRcdCIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0In0sInVwZGF0ZUVkaXRvciI6ZmFsc2V9)

## How to build this?

* create database directory with `mkdir data` and update `docker-compose.yml` accordingly
* start the database with `docker-compose up -d`
* install dependencies with `mix deps.get`
* create and migrate your database with `mix ecto.setup`
  * reset it with `mix ecto.reset`
  * prefix `mix` with `MIX_ENV=test` to create/reset the test database
* install Node.js dependencies with `npm install` inside the `assets` directory
* start Phoenix endpoint with `mix phx.server`

## How to use it?

* run `state_machine_id=$(curl http://localhost:4000/create)`
* run `curl http://localhost:4000/update/${state_machine_id}?transition=start`
* run `curl http://localhost:4000/update/${state_machine_id}?transition=run`
* run `curl http://localhost:4000/retrieve/${state_machine_id}`
* run `curl http://localhost:4000/update/${state_machine_id}?transition=done`
* run `curl http://localhost:4000/delete/${state_machine_id}`
  * note: this should fail because after the done transition the state machine has ceased to exist

You can also run these commands with `./scripts/run.sh`.

## How to switch between implementations?

* the repo features the following (tagged) implementations ...
  * 0.1.0-gen_statem - using gen_statem
  * 0.2.0-fsmx - using ecto/fsmx
  * 0.3.0-ecto_fsm - using ecto_fsm
* you can select one of these by checking out the tag and then build/run it as described above
  * note: after checking out the tag/switching the implementation you need to reset the database(s) with `MIX_ENV=test mix ecto.reset` and `MIX_ENV=dev mix ecto.reset`
