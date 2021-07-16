#!/bin/bash

set -e

mix ecto.setup

DEBUG=0 mix phx.server