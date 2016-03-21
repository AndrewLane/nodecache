module.exports = (grunt) ->
	# Project configuration.
	grunt.initConfig
		pkg: grunt.file.readJSON('package.json')
		banner: """
/*
 * <%= pkg.name %> <%= pkg.version %> ( <%= grunt.template.today( 'yyyy-mm-dd' )%> )
 * <%= pkg.homepage %>
 *
 * Released under the MIT license
 * <%= pkg.homepage %>/blob/master/LICENSE
 * 
 * Maintained by <%= pkg.maintainers.name %> ( <%= pkg.maintainers.url %> )
*/
"""
		regarde:
			module:
				files: ["_src/**/*.coffee"]
				tasks: [ "coffee:changed" ]
			
		coffee:
			options:
				banner: "<%= banner %>"
				
			changed:
				expand: true
				cwd: '_src'
				src:	[ '<% print( _.first( ((typeof grunt !== "undefined" && grunt !== null ? (_ref = grunt.regarde) != null ? _ref.changed : void 0 : void 0) || ["_src/nothing"]) ).slice( "_src/".length ) ) %>' ]
				# template to cut off `_src/` and throw on error on non-regrade call
				# CF: `_.first( grunt?.regarde?.changed or [ "_src/nothing" ] ).slice( "_src/".length )
				dest: ''
				ext: '.js'

			base:
				expand: true
				cwd: '_src',
				src: ["**/*.coffee"]
				dest: ''
				ext: '.js'

		clean:
			base:
				src: [ "lib", "test", "*.js" ]

		includereplace:
			pckg:
				options:
					globals:
						version: "<%= pkg.version %>"

					prefix: "@@"
					suffix: ''

				files:
					"index.js": ["index.js"]
					
		
		usebanner:
			options:
				banner: "<%= banner %>"
			base:
				files:
					"index.js": ["index.js"]
					"lib/node_cache.js": ["lib/node_cache.js"]
					"test/node_cache-test.js": ["test/node_cache-test.js"]
		
		run:
			options:
				wait: true

			main:
				cmd: "node_modules/expresso/bin/expresso"
				args: [ "test/node_cache-test.js" ]


	# Load npm modules
	grunt.loadNpmTasks "grunt-regarde"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-contrib-clean"
	grunt.loadNpmTasks "grunt-run"
	grunt.loadNpmTasks "grunt-include-replace"
	grunt.loadNpmTasks "grunt-banner"
	

	# just a hack until this issue has been fixed: https://github.com/yeoman/grunt-regarde/issues/3
	grunt.option('force', not grunt.option('force'))
	
	# ALIAS TASKS
	grunt.registerTask "watch", "regarde"
	grunt.registerTask "default", "build"
	grunt.registerTask "clear", [ "clean:base" ]
	grunt.registerTask "test", [ "build", "run:main" ]

	# build the project
	grunt.registerTask "build", [ "clear", "coffee:base", "usebanner:base", "includereplace:pckg" ]
	grunt.registerTask "build-dev", [ "clear", "coffee:base", "test" ]
