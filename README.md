# Canvas Load Testing using JMeter 2.9 #

## Description ##


## Requirements ##
* Java
* Ruby 1.9
* Bundler

<pre>
    $ gem install bundler
</pre>

## Installation/Setup ##
1. Download canvas-load-test from github
<pre>
    $ git clone git://github.com/ronvs/canvas-load-test.git
</pre>
2. Download GEMS
<pre>
	$ cd canvas-load-test
	$ bundle install
</pre>
3. Run 'ruby setup.rb all'
<pre>
	Usage:  ruby setup.rb < all | sis_imports | discussions | content > [optional: URL]
	Example: ruby setup.rb content http://localhost/canvas/load-test-variables/index.html
</pre>	
4. Start JMeter
 * Standalone - 
<pre>
	sh startJMeter-gui.sh
</pre>	
 * Remote - 
<pre>
	sh startJMeter-server. &
</pre>	
