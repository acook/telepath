Telepath
========

Spooky action at a distance.

[![Gem Version](https://badge.fury.io/rb/telepath.png)](http://badge.fury.io/rb/telepath)
[![Build Status](https://travis-ci.org/acook/telepath.png?branch=master)](https://travis-ci.org/acook/telepath)
[![Code Climate](https://codeclimate.com/github/acook/telepath.png)](https://codeclimate.com/github/acook/telepath)
[![Dependency Status](https://gemnasium.com/acook/telepath.png)](https://gemnasium.com/acook/telepath)

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

There's currently just 2 commands (more on their way!), here's the output of `tel --help`:

```sh
Usage:
    tel [OPTIONS] SUBCOMMAND [ARG] ...

Parameters:
    SUBCOMMAND                    subcommand
    [ARG] ...                     subcommand arguments

Subcommands:
    +                             Add item to Telepath
    =                             Grab item from Telepath

Options:
    -q, --quiet                   Only output when absolutely necessary.
    -h, --help                    print help
```

Example
-------

Dump data into Telepath from Bash...

```bash
$ tel + "All the things!"
```

Use it in Vim...

```viml
:r ! tel =
```

Use it again in Zsh...

```zsh
∴ export which_things=$(tel =)
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

    Anthony M. Cook 2013

Inspired by this perl script: [oknowton/shstack](https://github.com/oknowton/shstack)


