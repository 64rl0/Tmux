# Tmux Midway Cookie status

Enables displaying Midway Cookie information in Tmux.

## Installation

Clone the repo:

```shell
$ git clone https://github.com/
```

Add this line to the bottom of `.tmux.conf`:

```shell
run-shell ~/clone/path/midway.tmux
```

Reload TMUX environment:

```shell
# type this in terminal
$ tmux source-file ~/.tmux.conf
```

If format strings are added to `status-right`, they should now be visible.

## Usage

Add any of the supported format strings (see below) to the existing `status-right` tmux option.
Example:

```shell
# in .tmux.conf
set -g status-right '#{mw_cookie} '
```

## Customization

Here are all available options with their default values:

```shell
@mw_cookie_valid_color_fg "default" # foreground color when cookie is VALID.
@mw_cookie_valid_color_bg "default" # background color when cookie is VALID.

@mw_cookie_expiring_color_fg "default" # foreground color when cookie is about to expire, time can be set in the scripts folder of the plugin.
@mw_cookie_expiring_color_bg "default" # background color when cookie is about to expire, time can be set in the scripts folder of the plugin.

@mw_cookie_expired_color_fg "default" # foreground color when cookie is EXPIRED.
@mw_cookie_expired_color_bg "default" # background color when cookie is EXPIRED.

@mw_cookie_color_end_fg "default" # foreground reset color after formatting
@mw_cookie_color_end_bg "default" # background reset color after formatting
```

Note that these colors depend on your terminal / X11 config.

You can can customize each one of these options in your `.tmux.conf`, for example:

```shell
set -g @mw_cookie_valid_color_fg "#a6e3a1"
```

Don't forget to reload the tmux environment (`$ tmux source-file ~/.tmux.conf`) after you do this.
