# AkitaOnRails - based on Hextra Starter Template

I have tweaked the Starter Template for the AkitaOnRails Blog. Check their github repo for more info.

I will accept some pull requests, but do not make any massive changes, only tweaks.

## Local Development

Pre-requisites: [Hugo](https://gohugo.io/getting-started/installing/), [Go](https://golang.org/doc/install) and [Git](https://git-scm.com)

```shell 
# clone repository
git clone https://github.com/akitaonrails/akitaonrails.github.io.git

# add content

nvim content/2025/08/29/hello/index.md 

# generate index

cd content
ruby generate_index.rb

# build 
hugo 

# run server
hugo server --logLevel debug --disableFastRender -p 1313
```


# LICENSE-CC

Shield: [![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg
