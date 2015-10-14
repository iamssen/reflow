var gulp = require('gulp')
var fl = require('flbuild')
var exec = require('done-exec')
var run = require('gulp-sequence')
var packageInfo = require('./package.json')

var config = new fl.Config()
config.setEnv('FLEX_HOME')
config.setEnv('PROJECT_HOME', __dirname)
config.setEnv('PLAYER_VERSION', '16.0')
config.setEnv('VERSION', packageInfo.version)
config.addExternalLibraryDirectory('$FLEX_HOME/frameworks/libs/player/$PLAYER_VERSION')
config.addExternalLibraryDirectory('$FLEX_HOME/frameworks/libs/')
config.addExternalLibraryDirectory('$FLEX_HOME/frameworks/libs/mx/')
config.addExternalLibraryDirectory('$FLEX_HOME/frameworks/locale/en_US/')
config.addSourceDirectory('$PROJECT_HOME/src')

gulp.task('create-library', function (done) {
	var lib = new fl.Lib(config)
	lib.createBuildCommand('$PROJECT_HOME/bin/reflow.$VERSION.swc', function (cmd) {
		exec(cmd).run(done)
	})
})

gulp.task('clear-cache', function (done) {
	exec('rm -rf .flbuild-cache').run(done)
})

gulp.task('default', run('create-library', 'clear-cache'))
