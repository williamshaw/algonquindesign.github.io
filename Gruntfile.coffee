module.exports = (grunt) ->

  devPort = 8080

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

    watch:
      options:
        livereload: true
      styles:
        files: ['css/*.css']
      stylus:
        options:
          livereload: false
        files: ['css/*.styl']
        tasks: ['stylus']

  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.registerTask 'build', [
    'svgmin'
    'imageoptim'
    'stylus'
  ]

  grunt.registerTask 'default', [
    'watch'
  ]
