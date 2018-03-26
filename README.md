# Config

Arch Linux config for Reeto Chatterjee. Dotfiles are organised into modules and managed with modman, the included module manager.

## Modman

Python 3 module manager for configuration modules.

### Modules
Modules are top-level folders which have a `config.json` file inside.

#### Project Structure

```
- Git Repo
| - Module 1
  | - config.json
  ... other modules resources
| - Module 2
  | - config.json
  ... other modules resources
| - Other Folder
  ...
```

#### `config.json`
The `config.json` file has the following format:

```json
{
    "init": false,
    "cleanup": false,
    "resources": {
        "file 1": "system location 1",
        ...
    },
    "dependencies": {
        "required": ["pkg1", ...],
        "optional": ["pkg2", ...]
    }
}
```

##### Field Names

* `init` - Boolean value indicating whether there is an init script to execute before module install. Stored under the module folder as `init.sh`.
* `cleanup` - Boolean value indicating whether there is a cleanup script to execute before module uninstall. Stored under the module folder as `cleanup.sh`.
* `resources` - A map of file names to system locations to to create and delete for the module. File names are relative to the module folder. System locations are relative to the user's home directory.
* `dependencies` - Package dependencies for the module.
    * `required` - List of packages to be explicitly installed.
    * `optional` - List of packages to be installed as dependencies.

### Commands

The top-level commands that are currently provided are:

* `install` - Install the specified module(s) into the system. This has 3 stages:
    1. Execute `init.sh` (if `init` is true).
    2. Install package dependencies (if `--deps` flag provided).
    3. Delete existing files and create symlinks to the module resources in the system.
* `uninstall` - Uninstall the specified modules(s). The opposite of install. This has 3 stages:
    1. Execute `cleanup.sh` (if `cleanup` is true).
    2. Remove package dependencies (if `--deps` flag provided).
    3. Delete existing files (*WARNING*: Will remove system files at the specified locations as well).
* `list` - List available modules

Full usage can be found from the command line using the `--help` or `-h` flags.

## Miscellaneous

The `misc` folder is the standard place to put non-module resources such as useful scripts and template config files.

