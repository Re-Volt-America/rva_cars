rva_cars/
===

Re-Volt America's Cars Pack.

## Usage
For developers, the packaging pipeline was built using Rake. The following tasks take care of compressing and versioning
the files included in the cars pack:
  - `:clean`: Removes all unnecessary files from cars/, such as paintkits, extra folders, etc. Use it before pushing to this repo!
  - `:package`: Packages the whole cars/ directory into a zip file.
  - `:carboxes`: Takes all car boxes from cars/ and organises them into carboxes/. We use these for the website.
  - `:version`: Generates a packages.json file, which is later used for distributing the pack via the [RVGL Launcher](https://re-volt.gitlab.io/rvgl-launcher/#download).

Using `rake` on its own will execute all in its intended order: `:clean, :package, :version`.
