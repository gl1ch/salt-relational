salt-relational
===============

I have decided to build out two seperate Salt State repositories in order to accomplish things in different ways. This repository represents the way I initially decided to build out my Salt environment with the following goals in mind:
 * Ease of use
  * All states should be written using YAML/JINJA to make it easy for other users to follow / re-write
 * Centralized / Relational build
  * These states are written so that individual servers can be centrally managed by pillar
  * States are built to relate to one another (or at least an attempt has been made)

While this repository represents a relational build, I am going to be working on putting together a second repository with a detached view of things that would be more useful when building "stateless" machines for cloud architectures. I am betting that between the two methodologies I should end up with something that can be combined to accomodate most situations.

I will also try and write doc's to help explain things on my web site: http://www.nineproductions.com

Thanks and hope this helps

Andrew
http://www.nineproductions.com
