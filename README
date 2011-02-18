resque-publisher
----------------

by Michael Nutt <michael@nuttnet.net>


This resque plugin publishes to redis pubsub whenever a resque worker event (job added to queue,
worker started a job, job failed, etc) occurs.


Usage
=====

  class MyJob
    extend Resque::Plugins::Publisher
  
    ...
  end

Installation
============

`gem install resque-publisher` or if you are using bundler just add the following to your Gemfile:

  gem 'resque-publisher'


Acknowledgements
================

Much of the testing helper code was adapted from resque-retry by Luke Antins and Ryan Carver. 
(http://github.com/lantins/resque-retry)

Copyright
=========

The MIT License

Copyright (c) 2011 Michael Nutt 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
