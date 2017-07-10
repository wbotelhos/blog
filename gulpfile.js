var gulp = require('gulp');

gulp.task('install', function() {
  'use strict';

  gulp.src(['./package.json']).pipe(require('gulp-install')());
});

gulp.task('files', ['install'], function() {
  'use strict';

  var
    rename  = require('gulp-rename'),
    entries = [
      ['node_modules/jquery/dist/jquery.min.js'],
      ['node_modules/normalize.css/normalize.css'],
      ['node_modules/pygments-css/default.css', 'pygments.css']
    ];

  function dest(filename) {
    if (/\.(css|sass|scss)$/.test(filename)) {
      return 'app/assets/stylesheets/vendor';
    }

    if (/\.(js)$/.test(filename)) {
      return 'app/assets/javascripts/vendor';
    }

    if (/\.(eot|svg|ttf|woff|woff2)$/.test(filename)) {
      return 'app/assets/fonts/vendor';
    }
  }

  for (var i = 0; i < entries.length; i++) {
    var
      file     = entries[i][0],
      filename = entries[i][1] || file.split('/').pop();

    gulp
    .src(file)
    .pipe(rename(filename))
    .pipe(gulp.dest(dest(filename)));
  }
});

gulp.task('lint', ['files'], function() {
  'use strict';

  var eslint = require('gulp-eslint');

  var src = [
    './app/assets/javascripts/**/*.js',
    '!./app/assets/javascripts/vendor/*.js'
  ]

  gulp
    .src(src)
    .pipe(eslint())
    .pipe(eslint.formatEach())
    .pipe(eslint.failOnError());
});

gulp.task('default', ['lint'], function(done) {
  'use strict';
});
