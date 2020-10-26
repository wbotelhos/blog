var gulp = require('gulp');

function install() {
  'use strict';

  return gulp.src('./package.json').pipe(require('gulp-install')());
}

function files(done) {
  'use strict';

  function destiny(filename) {
    if (/\.(css|sass|scss)$/.test(filename)) {
      return 'app/assets/stylesheets/vendor';
    }

    if (/\.(js|js.map)$/.test(filename)) {
      return 'app/assets/javascripts/vendor';
    }
  }

  var entries = [
    ['node_modules/jquery/dist/jquery.min.js'],
    ['node_modules/normalize.css/normalize.css'],
  ];

  for (var i = 0; i < entries.length; i++) {
    var file     = entries[i][0];
    var filename = entries[i][1] || file.split('/').pop();

    gulp.src(file).pipe(require('gulp-rename')(filename)).pipe(gulp.dest(destiny(filename)));
  }

  done();
};

function lint() {
  'use strict';

  var eslint = require('gulp-eslint');

  var files = [
    'app/assets/javascripts/**/*.js',
    '!app/assets/javascripts/vendor/*.js',
  ];

  return gulp.src(files).pipe(eslint()).pipe(eslint.formatEach()).pipe(eslint.failOnError());
};

exports.default = gulp.series(install, gulp.parallel(files, lint));
exports.install = install;
exports.files   = files;
exports.lint    = lint;
