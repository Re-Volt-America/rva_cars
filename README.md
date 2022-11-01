rva_cars/
===

Re-Volt America's Cars Pack.

## Usage
The rva_cars repository contains the following rake tasks:
  - `:clean`: Removes all unnecessary files from cars/, such as paintkits, extra folders, etc. Use it before pushing to this repo!
  - `:carboxes`: Takes all car boxes from cars/ and organises them into carboxes/. We use these for the website.

Packaging and versioning is handled at the top level repo for the rva pack [here](https://github.com/Re-Volt-America/rva).

Using `rake` on its own will execute all in its intended order: `:clean, :carboxes`.
