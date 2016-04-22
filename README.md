# Legalese [![Build Status](https://travis-ci.org/18F/legalese.svg?branch=master)](https://travis-ci.org/18F/legalese)

Experimental checker for legal text that determines whether 18F can use a third-party service or not. Checks the following:

* If the site has a Privacy Policy
* If the site has a Terms of Service, and if it contains the following clauses:
    * [Governing law](http://www.contractstandards.com/clauses/governing-law)
    * [Indemnification](http://www.startuplawtalk.com/what-is-indemnification/)

## Usage

Requires Ruby 1.9+.

1. Clone this repository and `cd` into the directory.
1. Create a `urls.txt` file with a list of sites to check, one on each line. 18F, for example, is collecting a list of potential services in [this spreadsheet](https://docs.google.com/spreadsheets/d/180JGMG8O13_R9VxSDLYDWGg0JSWa3Higy911RS-PeNk/edit#gid=0) (private; use the `URL` column).
1. Run

    ```bash
    bundle
    bundle exec ruby scan.rb
    ```
