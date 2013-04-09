<h1>Canvas Load Testing using JMeter 2.9</h1>

<h3>Description</h3>


<h3>Requirements</h3>
* Java
* Ruby 1.9
* Bundler
```
$ gem install bundler
```

<h3>Installation/Setup</h3>
* Download canvas-load-test from github
* Download GEMS
```
$ cd canvas-load-test
$ bundle install
```
* Run 'ruby setup.rb all'
** Usage:  ruby setup.rb < all | sis_imports | discussions | content >
* Start JMeter
** Standalone - 
```
sh startJMeter-gui.sh
```
** Remote - 
```
sh startJMeter-server.sh
```

<h3>Commands</h3>
