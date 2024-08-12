#!/bin/sh
certstrap init --common-name "zombieCA"
certstrap request-cert --common-name "zombie" -domain "localhost"
certstrap sign zombie --CA "zombieCA"


