var gulp = require('gulp');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var path = require('path');
var minify_css = require('gulp-minify-css');
var runSequence = require('gulp-run-sequence');

gulp.task('compress_library_js', function() {
  return gulp.src([
    'public/js/jquery.min.js',
    'public/js/bootstrap.min.js',
    'public/js/modernizr-2.6.2.min.js',
    'public/js/main.js'
  ])
  .pipe(concat('core.min.js'))
  .pipe(gulp.dest('public/js'));
});

gulp.task('compress_css', function () {
  gulp.src([
    'public/css/icomoon.css',
    'public/css/style.css',
    'public/css/override.css',
    'public/css/workaround.css'
  ])
    .pipe(minify_css({compatibility: 'ie8'}))
    .pipe(concat('all.min.css', {newLine: '\n\n'}))
    .pipe(gulp.dest('public/css'));
});

gulp.task('precompile:assets', function(s){
  runSequence('compress_library_js','compress_css',s);
})