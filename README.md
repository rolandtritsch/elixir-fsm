# Implementing a simple finite state machine

This repo implements a simple finite state machine.

The state machine models a simple job worker system.

[![](https://mermaid.ink/img/eyJjb2RlIjoic3RhdGVEaWFncmFtXG5cdFsqXSAtLT4gU2NoZWR1bGVkIDogc2NoZWR1bGVcbiAgWypdIC0tPiBJbml0aWFsaXplZCA6IHN0YXJ0XG4gIFNjaGVkdWxlZCAtLT4gSW5pdGlhbGl6ZWQgOiBzdGFydFxuICBJbml0aWFsaXplZCAtLT4gUnVubmluZyA6IHJ1blxuICBSdW5uaW5nIC0tPiBQcm9jZXNzaW5nIDogcHJvY2Vzc1xuICBQcm9jZXNzaW5nIC0tPiBGYWlsZWQgOiBmYWlsdXJlXG4gIFByb2Nlc3NpbmcgLS0-IFJ1bm5pbmcgOiBzdWNjZXNzXG4gIEZhaWxlZCAtLT4gWypdIDogZG9uZVxuICBSdW5uaW5nIC0tPiBbKl0gOiBkb25lXG5cblx0XHRcdFx0XHQiLCJtZXJtYWlkIjp7InRoZW1lIjoiZGVmYXVsdCJ9LCJ1cGRhdGVFZGl0b3IiOmZhbHNlfQ)](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoic3RhdGVEaWFncmFtXG5cdFsqXSAtLT4gU2NoZWR1bGVkIDogc2NoZWR1bGVcbiAgWypdIC0tPiBJbml0aWFsaXplZCA6IHN0YXJ0XG4gIFNjaGVkdWxlZCAtLT4gSW5pdGlhbGl6ZWQgOiBzdGFydFxuICBJbml0aWFsaXplZCAtLT4gUnVubmluZyA6IHJ1blxuICBSdW5uaW5nIC0tPiBQcm9jZXNzaW5nIDogcHJvY2Vzc1xuICBQcm9jZXNzaW5nIC0tPiBGYWlsZWQgOiBmYWlsdXJlXG4gIFByb2Nlc3NpbmcgLS0-IFJ1bm5pbmcgOiBzdWNjZXNzXG4gIEZhaWxlZCAtLT4gWypdIDogZG9uZVxuICBSdW5uaW5nIC0tPiBbKl0gOiBkb25lXG5cblx0XHRcdFx0XHQiLCJtZXJtYWlkIjp7InRoZW1lIjoiZGVmYXVsdCJ9LCJ1cGRhdGVFZGl0b3IiOmZhbHNlfQ)

## How to build this?

* create database directory with `mkdir data` and update `docker-compose.yml` accordingly
* start the database with `docker-compose up -d`
* install dependencies with `mix deps.get`
* create and migrate your database with `mix ecto.setup`
* install Node.js dependencies with `npm install` inside the `assets` directory
* start Phoenix endpoint with `mix phx.server`

## How to use it?

* run `state_machine_id=$(curl http://localhost:4000/create)`
* run `curl http://localhost:4000/update/${state_machine_id}?transition=start`
* run `curl http://localhost:4000/update/${state_machine_id}?transition=run`
* run `curl http://localhost:4000/retrieve/${state_machine_id}`
* run `curl http://localhost:4000/update/${state_machine_id}?transition=done`
* run `curl http://localhost:4000/delete/${state_machine_id}`
  * Note: this should fail because after the done transition the state machine has ceased to exist
