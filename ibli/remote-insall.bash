#!/bin/bash

# Make sure you have the alias setup (use `drush sa` too see the aliases).
drush @pantheon.ibli.dev sql-drop -y
drush @pantheon.ibli.dev si -y ibli --account-pass=admin
drush @pantheon.ibli.dev mi --all --user=1
