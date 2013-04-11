# Canvas Load Testing using JMeter 2.9 #

## Description ##


## Requirements ##
* Java
* Ruby 1.9
* Bundler

$ gem install bundler
```

## Installation/Setup ##
* Download canvas-load-test from github
* Download GEMS
<pre>
	$ cd canvas-load-test
	$ bundle install
</pre>
* Run 'ruby setup.rb all'
<pre>
	Usage:  ruby setup.rb < all | sis_imports | discussions | content > [optional: URL]
	Example: ruby setup.rb content http://localhost/canvas/load-test-variables/index.html
</pre>	
* Start JMeter
 * Standalone - 
<pre>
	sh startJMeter-gui.sh
</pre>	
 * Remote - 
<pre>
	sh startJMeter-server.sh
</pre>	