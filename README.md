# Legalese

Experimental checker for legal text that determines whether 18F can use a third-party service or not.

## Usage

Requires Ruby 1.9+.

1. Clone this repository and `cd` into the directory.
1. Create a `domains.txt` file with a list of sites to check, one on each line. 18F, for example, is collecting a list of potential services in [this spreadsheet](https://docs.google.com/spreadsheets/d/180JGMG8O13_R9VxSDLYDWGg0JSWa3Higy911RS-PeNk/edit#gid=0) (private; use the `URL` column).
1. Run

    ```bash
    gem install nokogiri
    ruby scan.rb
    ```
