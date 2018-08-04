#!/bin/bash

# Add explanation.

menufile="$HOME/.larbs-wizard/choices.csv"
progsfile="$HOME/.larbs-wizard/installable.csv"
specdir="$HOME/.larbs-wizard/wrappers"

tmpdir=$(mktemp -d)

# Construct menu file.  For some reasons, it's easier to constuct it on the fly
# than use eval and such.
echo "dialog --title \"LARBS Post-Install Wizard\" --menu \"What would you like to do?\" 15 45 8 \\" > $tmpdir/menu.sh
echo $(cut -d, -f1,2 "$menufile" | sed -e "s/,/ \"/g;s/$/\"/g")" \\" >> $tmpdir/menu.sh
echo "2>$tmpdir/choice" >> $tmpdir/menu.sh

# Get user input of what packages to install.
bash $tmpdir/menu.sh
chosen=$(cat $tmpdir/choice)
[[ $chosen == "" ]] && clear && exit

# In addition to installing the tagged programs, you can have scripts that run
# either before or after the installation.  To do this, you need only create a
# file in ~/.larbs-wizard/.specific/Z.pre (or Z.post).  `Z` here is the tag of
# the programs.

[[ -f  $specdir/$chosen.pre ]] && bash $specdir/$chosen.pre

# Quit script if preinstall script returned error or if user ended it.
[[ ! $? -eq 0 ]] && clear &&  exit

clear
# Run the `packerwrapper` script on all the programs tagged with the chosen tag
# in the progs file.
packer -S $(grep "^$chosen" "$progsfile" | cut -d ',' -f2)

# Post installation script.
[[ -f  $specdir/$chosen.post ]] && bash $specdir/$chosen.post
