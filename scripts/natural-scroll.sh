#!/bin/bash

## Script by Levi Figueira
## https://levifig.com

## Props to Maxwell Bland
## https://github.com/maxwell-bland/i3-natural-scrolling-and-tap

# Get id of pointer devices
# Adjust grep parameters to your needs
id=`xinput list | grep "pointer" | grep "Logitech" | cut -d'=' -f2 | cut -d'[' -f1`

for i in $id
do
  # Find property id of natural scrolling
  prop_id=`xinput list-props $i | grep "Natural Scrolling Enabled (" | cut -d'(' -f2 | cut -d')' -f1`
  
  # Set it to true
  xinput --set-prop $i $prop_id 1
done
