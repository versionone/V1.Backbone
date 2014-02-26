module.exports = function(grunt) {

  grunt.loadNpmTasks('grunt-mocha-test');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-docco');

  grunt.initConfig({
    watch: {
      scripts: {
        files: ['V1.Backbone.litcoffee', 'tests/**/*.coffee'],
        tasks: ["coffee:compile", 'uglify', "mochaTest"],
        options: { spawn: true }
      }
    },

    coffee: {
      compile: {
        files: {
          'V1.Backbone.js': 'V1.Backbone.litcoffee'
        }
      }
    },

    uglify: {
      scripts: {
        files: {
          'V1.Backbone.min.js': ['V1.Backbone.js']
        }
      }
    },

    mochaTest: {
      test: {
        options: {
          reporter: 'dot',
          require: 'coffee-script/register'
        },
        src: ['tests/**/*.coffee']
      }
    },
    docco: {
      main: {
        src: ['V1.Backbone.litcoffee'],
        options: {
          output: 'docs/'
        }
      }
    },    
  });

  grunt.registerTask('default', ["coffee:compile", 'uglify', "mochaTest", "docco"]);
};
