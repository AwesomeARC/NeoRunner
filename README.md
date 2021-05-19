<p align="center"><img src="./assets/logo.png" alt="logo" height="100px"></p>
<p align="center">Simple code runner script written in bash 4.3+</p>

# Introduction

NeoRunner is a simple, small and portable code runner script. Many text editors today come with built-in code runners and some others have plugins and extensions that can be downloaded and installed to enable this functionality. Being able to define custom snippets to compile/run code written in different languages, and having a simple interface to execute such snippets is a rather menial task. However, there seemed to be a striking lack of such a "simple code runner script" to enable a user to do this right from the command line.

This project aims to fill that void. It provides a simple and logical command line interface to compile/run code written in virtually any possible language, as per an executor map located, by default, at the script's config directory.

Currently, it only supports file extension-based executor maps. However, there are plans to add glob-based executor maps soon.

# Installation

NeoRunner provides a `Makefile` for easy installation.

1. Clone the repository

```
$ git clone https://github.com/AwesomeARC/NeoRunner.git
```

2. Navigate into the directory

```
$ cd NeoRunner
```

3. Use `make` to install the script

```
$ sudo make install
```

# Configuration

The recommended way to configure neorunner is through a JSON file, `executor_map_by_ext.json`, at the script's config directory (`$HOME/.config/nr/`). The script also uses a system-wide configuration file as fallback, located in `/usr/local/etc/nr/`. Users may choose to use a different configuration by specifying its path with the `-e` option.

A sample executor map has been provided at [config/executor\_map\_by\_ext.json](https://github.com/awesomearc/neorunner/blob/master/config/executor\_map\_by\_ext.json):

```json
{
    "c": "g++ $file_name -o $file_name_without_ext && ./$file_name_without_ext",
    "cpp": "g++ $file_name -o $file_name_without_ext && ./$file_name_without_ext",
    "rs": "rustc $file_name && ./$file_name_without_ext",
    "java": "javac $file_name && java $file_name_without_ext",
    "py": "python3 -u $file_name",
    "js": "node $file_name",
    "ts": "ts-node $file_name",
    "rb": "ruby $file_name",
    "pl": "perl $file_name",
    "hs": "runhaskell $file_name",
    "php": "php $file_name",
    "sc": "scala $file_name",
    "sh": "bash $file_name"
}
```

This file should be installed to the system-wide config directory automatically if the script was installed through `make`. Users may choose to modify this file however they wish.

