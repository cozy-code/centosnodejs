var gulp = require('gulp');
var sass = require('gulp-sass');
var autoprefixer = require('gulp-autoprefixer');
var cssmin = require('gulp-cssmin');
var rename = require('gulp-rename');
var browserSync = require('browser-sync');

var src='/home/vagrant/src';

gulp.task('sass', function () {
    gulp.src(src + '/wp/scss/*.scss')
        .pipe(sass())
        .pipe(autoprefixer(["last 2 version", "ie 8", "ie 7"]))
        .pipe(cssmin())
        .pipe(rename({suffix: '.min'}))
        .pipe(gulp.dest(src + '/wp/css'))
        .pipe(browserSync.reload({stream: true}));
});

gulp.task('browser-sync', function () {
    browserSync({
        //proxy: "wordpress.local"
        proxy: "http://192.168.33.10/wordpress"
    });
});

gulp.task('bs-reload', function () {
    browserSync.reload();
});

gulp.task('default', ['browser-sync'], function () {
    gulp.watch("~/src/wp/scss/*.scss", ['sass']);
    //gulp.watch("/path/to/wordpress/theme/*.php", ['bs-reload']);
});

