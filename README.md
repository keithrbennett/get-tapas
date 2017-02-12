# get-tapas #

Downloads Ruby Tapas screencast videos for paid subscribers.

Prerequisites:

* ruby (of course)
* curl (install with your package manager such as brew, yum, or apt-get)

Instructions:

```
gem install get-tapas
# Get the video download HTML text (see below.)
get-tapas [options]
```

This gem provides a script that _partially_ automates the process of
downloading Ruby Tapas screencasts en masse, eliminating the need to 
click each screencast's link individually.

## Getting the Required HTML Text

Here are the steps you will need to follow:

* Log in to https://www.rubytapas.com.
* Navigate to https://www.rubytapas.com/download-list, either by
inserting the URL above into the address bar, or by
selecting _Video Downloads_ from the _Episodes_ menu.
* View the page's source, in many browsers by pressing _Ctrl/Cmd-U_.
* Select all its text (_Ctrl/Cmd-A_).
* Copy that text to the clipboard (_Ctrl/Cmd-C_).
* You can either:
  * pipe the text from your clipboard into the get-tapas script using `pbpaste` 
  or whatever other clipboard paste command your system provides, 
  and specifying to the script that it should get the HTML 
  from standard input (`-i -`), or 
  * save the text to a file, as in `pbpaste > download_list.html`, 
  and specify that filename with `-i path/to/download_list.html`.


## Command Line Options

Running the script without any arguments will output the command line
options.  They're pretty self explanatory. For your convenience, here is
the output:

```
Usage: get-tapas [options]
    -d, --data_dir dir               Directory for downloaded files (default: .)
    -i, --input_spec spec            Filespec (or '-' for STDIN) containing Ruby Tapas download list page HTML
    -0, --min_episode_num number     Minimum episode number to download
    -9, --max_episode_num number     Maximum episode number to download
    -n, --[no-]no_op                 Don't download anything, just show what would have been downloaded.
    -r, --[no-]reverse               Reverse the list of input files to download most recent first
    -z, --sleep_interval seconds     Sleep this many seconds between files
    -h, --help                       Show this message
```

For your convenience, the output directory defaults to `$HOME/ruby-tapas`.