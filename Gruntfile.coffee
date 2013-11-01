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
          import: ['nib', 'common']
          compress: true
          urlfunc: 'embedurl'
        files:
          'css/algonquindesign.min.css': [
            'css/normalize.styl'
            'css/general.styl'
            'css/*.styl'
            '!css/common.styl'
          ]

    coffee:
      compile:
        files:
          'js/algonquindesign.coffee.js': [
            'js/*.coffee'
          ]

    uglify:
      prod:
        options:
          mangle: true
          compress: true
          preserveComments: 'some'
        files:
          'js/algonquindesign.min.js': [
            'js/$.min.js'
            'js/algonquindesign.coffee.js'
          ]

    concat:
      dev:
        files:
          'js/algonquindesign.min.js': [
            'js/$.min.js'
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
            args: [
              'serve'
              '--watch'
              '--config', '_config-local.yml'
            ]
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
        options:
          livereload: false
        files: ['js/*.coffee']
        tasks: ['coffee', 'concat:dev']
      css:
        files: ['_site/css/*.css']
      js:
        files: ['_site/js/*.js']
      html:
        files: ['_site/*.html']

  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.registerTask 'build', [
    'svgmin'
    'imageoptim'
    'stylus'
    'coffee'
    'uglify:prod'
  ]

  grunt.registerTask 'default', [
    'parallel:dev'
  ]
