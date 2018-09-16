# How to contribute

Being an open source project means any help offered will be greatly appreciated, below is a quick run through of how you
can help

## Getting Started

* Fork the latest branch of the component you want to contribute to:

    * [api-manager](https://github.com/nebula-orchestrator/worker-manager) - the api endpoint through which Nebula is controlled, includes api-manager Dockerfile & entire code structure
    * [docs](https://github.com/nebula-orchestrator/docs) - docs (schematics, wishlist\todo's, and API doc)
    * [worker-manager](https://github.com/nebula-orchestrator/api-manager) - the worker manager that manages individual Nebula workers, includes worker-manager Dockerfile & entire code structure
    * [nebula-python-sdk](https://github.com/nebula-orchestrator/nebula-python-sdk) - a pythonic SDK for using Nebula
    * [nebula-cmd](https://github.com/nebula-orchestrator/nebula-cmd) - a CLI for using Nebula
    * [nebula-orchestrator.github.io](https://github.com/nebula-orchestrator/nebula-orchestrator.github.io) - the Jekyll based main website


* Make sure you have a [GitHub account](https://github.com/signup/free)
* Use virtualenv to install all requirements from the requirements.txt file
* Fix an issue \ add a feature
* Create a pull request

## Design philosophy 
Nebula is designed with the following philosophy in mind, any feature\pull requests will be judged against the following:

* Follow Linux philosophy and have each component do one thing & one thing only.
* Each component needs to be possible to be scaled out to extremely large sizes.
* Reliability is more important then shiny new features.
* No vendor\cloud lock-in, if it's only available in one cloud it will not be used.
* No latency sensitivity, assume workers to have a below average internet access and are in the other side of the world.

### Documentation

Nebula docs are hosted at [readthedocs](http://nebula.readthedocs.io/en/latest/) using [MkDocs](http://www.mkdocs.org/) for their creation, reading them is highly recommended
prior to making any pull requests

## What you can help with

* Documentation - everyone hates them but without them would you be able to figure out how to use Nebula?
* Bug fixes / feature requests - anything off github issues lists
* Submitting tickets - even if you don't have the time\knowledge to fix a bug just opening a github issue about it will greatly help
* Suggesting improvements
* Spreading the word

### Summary

* Your awesome for helping, thanks.

P.S.
Don't forget to add yourself to to CONTRIBUTORS.md file.