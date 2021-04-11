#!/bin/bash

# This is a quick and dirty cleanup to restore state of the base repo (ie, remove Bank of Anthos)

git clean -df
rm -rf bank-of-anthos.zip || true
rm -rf src/ || true