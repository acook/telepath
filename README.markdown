Telepath
========

Spooky action at a distance.

[![Gem Version](https://badge.fury.io/rb/telepath.svg)](https://badge.fury.io/rb/telepath)
[![Build Status](https://travis-ci.org/acook/telepath.svg?branch=master)](https://travis-ci.org/acook/telepath)
[![Code Climate](https://codeclimate.com/github/acook/telepath/badges/gpa.svg)](https://codeclimate.com/github/acook/telepath)
[![Coverage Status](https://coveralls.io/repos/github/acook/telepath/badge.svg?branch=master)](https://coveralls.io/github/acook/telepath?branch=master)
[![Dependency Status](https://gemnasium.com/badges/github.com/acook/telepath.svg)](https://gemnasium.com/github.com/acook/telepath)

What the hell is this all about?
--------------------------------

Picture this: Half a dozen shells open. Some zsh, some bash, and some fish. Severals editors as well, a couple vim sessions, sublime, lightable.

How do you get information from one to another?

The clipboard, right? Some systems have multiple clipboards, and some apps even let you save your clipboard history.

But what if there was another way.

Another way for them to communicate near instantly, dare I say ... telepathically.

Passing silently through barriers like the T1000 from Terminator 2.

Or a ghost. A ghost is good too.

How does full text search sound? Pretty good, eh?

How about relative path correction between different working directories?

What about shared, persistant, distributed, fully decorated multi-client multi-host history?

Yeah thats pretty much what I thought. Now go change your pants, I'll still be here when you get back.


Installation & Setup
--------------------

### Install it!

```sh
gem install telepath
```

### Set it up!

Actually, thats pretty much it. Telepath just works.


Usage
-----

Here's the output of `tel --help`:

```sh
Usage:
    tel [OPTIONS] SUBCOMMAND [ARG] ...

Parameters:
    SUBCOMMAND                    subcommand
    [ARG] ...                     subcommand arguments

Subcommands:
    +, add                        Add item
    ?, lookup                     Look up item by pattern
    $, last                       Get most recent item
    @, index                      Get item from (reverse) index
    list                          List known containers and contents

Options:
    -h, --help                    print help
    -q, --quiet                   Only output when absolutely necessary. (default: $TELEPATH_QUIET, or false)
    -f, --file FILE               Filename of the Teleport store file. (default: $TELEPATH_FILE, or ".telepath.db")
    -p, --path PATH               Path where the the Teleport store file is located. (default: $TELEPATH_PATH, or "~")
```

Example
-------

Dump data into Telepath from Bash...

```bash
$ tel + "All the things!"
```

Use it in Vim...

```viml
:r ! tel $
```

Use it again in Zsh...

```zsh
∴ export which_things=$(tel $)
```

Manipulate it with `tr` in zsh and add the result back into Telepath...

```zsh
∴ tel $ | tr '[:lower:]' '[:upper:]' | tel +
```

And bring it back into Bash to combine it with the previous version...

```bash
$ echo $(tel $) $(tel @ 1) | tee result.txt | tel +
```


Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


Who made this anyway?
---------------------

I'm glad you asked!

    Anthony M. Cook 2013-2016

Inspired by this perl script: [oknowton/shstack](https://github.com/oknowton/shstack)


