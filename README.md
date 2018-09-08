# The LARBS Post-Install Wizard

**NOTE TO PEOPLE WHO AREN'T LUKE:** This isn't ready for use yet. It's just up
on Github now for my convenience as I'm testing things. I'll say when it's
ready. You're welcome to check out the idea and provide feedback, but don't
expect it to work.

This is a brief dialog menu that allows the user to install additional programs
and change minor settings.

## The Backend

The `menu.sh` is the main interface. It reads the `choices.csv` file for the
package sets or other possible choices in the menu and constructs a `dialog`
menu out of them.

The user can then choose an option. The script will install the programs
corresponding to that choice's tag that are listed in `installable.csv`.

You can also set up wrapping scripts in `wrappers/`. For example, let's say the
user choices the "mutt wizard" option which is tagged with `E`. Once chosen,
the script will check to see if the files `wrappers/E.pre` and
`wrappers/E.post` exist. If `E.pre` exists, it will be run after the choice,
but before the installation. If `E.post` exists, it will be run after the
installation of the programs.

In the case of mutt-wizard for example, `E.pre` checks to see if the user
already has a `~/.config/mutt/` directory and files and will as to back them
up, then download the `mutt-wizard` repository which goes in its place.
`E.post` will give additional directions for using mutt-wizard.

## Possible extentions

Right now, the script only installs additional things. It might be worth it to
be able to log the options already run and make them undoable, etc.
