VagrantDevEnvironment
=====================

Vagrant based Linux development environment.

# Motivation
-------------
For a new developer, the usual way to start developing in an existing project is to read a manual on what and how to install the toolchain and libraries nedded or run a script which does it automatically. After some developing time the individual developer machines differ from each other due to personal preferences and additional tools installed. Over time a diverse ecosystem of developer and build machine configurations emerge. In such an ecosystem the “It works on my machine” problem is common. 
If a developer has to work on different projects in parallel the problem escalates.
A common solution is to work with different virtual machines. However as new tools and versions needs to be installed during the lifetime of a project the problem remains unsolved. New versions of VMs must be created and distributed to the developers in order to have common configurations across the development team or extensive scripts for setting up the environment must be created/updated.
DevOps shows promise to solve this problem with “Infrastructure as code”. [Vagrant](http://www.vagrantup.com/) and [Puppet](http://projects.puppetlabs.com/projects/puppet) are two widely used tools of the trade. 

# Goal
------------------
The goal of this project is to learn Vagrant and the Puppet language and to create a customizable Virtual Machine for the purpose of state of the art C++ development.

# Notes of warning
------------------
I’m still an absolute newbie with Vagrant and Puppet and the Puppet manifests I produce will probably not have the quality and not follow the coding standards expected by the puppet community. Further I’m still learning how to testdrive my specifcations and currently (blame me) no tests exist.
