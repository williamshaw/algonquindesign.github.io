module.exports = (grunt) ->

  grunt.initConfig

    svgmin:
      options:
        plugins: [{
          removeViewBox: false
        }]
      files:
        expand: true
        cwd: 'img'
        src: ['*.svg']
        dest: 'img'
        ext: '.svg'

    imageoptim:
      options:
        imageAlpha: true
        # jpegMini: true
        quitAfter: true
      compress:
        src: [
          'img'
        ]

    stylus:
      compile:
        options:
          paths: ['css']
          use: ['nib']
          import: ['nib']
          compress: true
          urlfunc: 'embedurl'
        files:
          'css/algonquindesign.min.css': [
            'css/*.styl'
          ]

    coffee:
      compile:
        files:
          'js/algonquindesign.coffee.js': [
            'js/*.coffee'
          ]

    uglify:
      minifiy:
        options:
          mangle: true
          compress: true
          preserveComments: 'some'
        files:
          'js/algonquindesign.min.js': [
            'js/js-src/$.min.js'
            'js/algonquindesign.coffee.js'
          ]

    parallel:
      dev:
        options:
          stream: true
        tasks: [
          {
            grunt: true
            args: ['watch']
          }
          {
            cmd: 'jekyll'
            args: ['serve', '--watch', '--baseurl', '']
          }
        ]

    watch:
      options:
        livereload: true
      stylus:
        options:
          livereload: false
        files: ['css/*.styl']
        tasks: ['stylus']
      coffee:
        files: ['js/*.coffee']
        tasks: ['coffee']
      css:
        files: ['_site/css/*.css']
      html:
        files: ['_site/*.html']

  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.registerTask 'build', [
    'svgmin'
    'imageoptim'
    'stylus'
    'coffee'
    'uglify'
  ]

  grunt.registerTask 'default', [
    'parallel:dev'
  ]
