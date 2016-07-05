var gulp = require('gulp');
var sass = require('gulp-sass');
var autoprefixer = require('gulp-autoprefixer');
var cssmin = require('gulp-cssmin');
var rename = require('gulp-rename');
var browserSync = require('browser-sync');

var theme_name="custom";

var wp_dir='~/html/wordpress';
var theme_dir=wp_dir+ "/wp-content/themes/" + theme_name;

var scss_files_pattern=theme_dir + '/scss/*.scss';

gulp.task('sass', function () {
    console.log("-------sass--------");
    gulp.src(scss_files_pattern)
        //.pipe(sass({outputStyle: 'expanded'}))
        .pipe(sass())
        .pipe(autoprefixer(["last 2 version", "ie 8", "ie 7"]))
        .pipe(cssmin())
        .pipe(rename({suffix: '.min'}))
        .pipe(gulp.dest(theme_dir + '/css'))
        .pipe(browserSync.reload({stream: true}));
});

gulp.task('browser-sync', function () {
    console.log("-------browser-sync--------");
    browserSync({
        //proxy: "wordpress.local"
        proxy: "http://192.168.33.10/wordpress"
    });
});

gulp.task('bs-reload', function () {
    console.log("-------bs-reload--------");
    browserSync.reload();
});

gulp.task('default', ['browser-sync'], function () {
    console.log("watch:" + scss_files_pattern);
    gulp.watch(scss_files_pattern, ['sass']);
    gulp.watch(theme_dir + '*.php', ['bs-reload']);
});

