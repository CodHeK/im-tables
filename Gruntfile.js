'use strict';

var grunt = require('grunt');

grunt.loadNpmTasks('grunt-contrib-watch');
grunt.loadNpmTasks('grunt-contrib-coffee');
grunt.loadNpmTasks('grunt-contrib-copy');
grunt.loadNpmTasks('grunt-notify');
grunt.loadNpmTasks('grunt-run');

var env = process.env;

var serverPort = (grunt.option('port') || env.PORT || env.npm_package_config_port);

grunt.initConfig({
  watch: { // Hwat! This task lays out the dependency graph.
    coffee: {
      files: ['src/**', 'templates/**', 'package.json', 'test/indices/*', 'test/lib/*'],
      tasks: ['build'],
      options: {spawn: false}
    },
    less: {
      files: ['less/**'],
      tasks: ['run:lessc'],
      options: {spawn: false}
    }
  },
  coffee: {
    src: {
      expand: true,
      flatten: false,
      cwd: 'src',
      src: ['**/*.coffee'],
      dest: '.tmp/src',
      ext: '.js'
    }
  },
  copy: {
    js: {
      files: [
        {
          expand: true,
          cwd: '.tmp/src',
          src: ['**'],
          dest: 'build'
        }
      ]
    },
    templates: {
      files: [
        {
          expand: true,
          cwd: 'templates',
          src: ['**'],
          dest: '.tmp/src/templates'
        }
      ]
    }
  },
  run: {
    server: {
      cmd: 'serve',
      args: [
        '--port',
        serverPort
      ],
      options: {
        wait: false
      }
    },
    lessc: {
      exec: "lessc --include-path=less:node_modules less/main.less > dist/main.css"
    },
    bundle_test_indices: {
      cmd: './bin/bundle-test-indices'
    },
    clean: {
      cmd: './bin/clean'
    },
    inject_version: {
      cmd: './bin/inject-version.js'
    },
    inline_templates: {
      cmd: './bin/inline-templates'
    }
  },
  notify: {
    build: {
      options: {
        title: 'Task Complete',
        message: 'Built test indices'
      }
    },
    less: {
      options: {
        title: 'Task Complete',
        message: 'CSS compiled',
      }
    },
    server: {
      options: {
        message: 'Server is ready!'
      }
    }
  }
});

grunt.registerTask('clean', ['run:clean']);

grunt.registerTask('compile', ['-compile', '-post-compile']);
grunt.registerTask('-compile', ['coffee', 'copy:templates']);
grunt.registerTask('-post-compile', ['run:inject_version', '-inline_templates']);

// Copy src files to the build dir, and inline the templates.
grunt.registerTask('-inline_templates', ['copy:js', 'run:inline_templates']);

grunt.registerTask('bundle', [
  'run:bundle_test_indices'
]);

grunt.registerTask('build', [
  'clean',
  'compile',
  'run:lessc',
  'bundle'
]);

grunt.registerTask('serve', [
  'build',
  'run:server',
  'watch'
]);

grunt.registerTask('default', ['build']);
