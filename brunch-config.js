exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: {
        'js/app.js': [
          'web/static/js/app.js',
          /^web\/static\/vendor\/elm\//
        ],
        'js/vendor.js': [
          /^(?!web\/static\/(js\/app\.js|vendor\/elm\/))/
        ]
      }
    },
    stylesheets: {
      joinTo: 'css/app.css'
    },
    templates: {
      joinTo: 'js/app.js'
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to '/web/static/assets'. Files in this directory
    // will be copied to `paths.public`, which is 'priv/static' by default.
    assets: /^(web\/static\/assets)/,

    ignored: [
      /\/_/,
      /^web\/elm\/elm-stuff\//,
      /^web\/static\/css\/semantic\//
    ]
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      'web/static',
      'web/elm',
      'test/static'
    ],

    // Where to compile files to
    public: 'priv/static'
  },

  // Configure your plugins
  plugins: {
    only: [
      'elm-brunch',
      'babel-brunch',
      'javascript-brunch',
      'uglify-js-brunch',
      'less-brunch',
      'clean-css-brunch',
      'css-brunch'
    ],
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/]
    },
    elmBrunch: {
      elmFolder: 'web/elm',
      mainModules: [ 'PhoenixPoker.elm' ],
      outputFolder: '../static/vendor/elm'
    }
  },

  modules: {
    autoRequire: {
      'js/app.js': ['web/static/js/app']
    }
  },

  npm: {
    enabled: true,
    globals: {
      jQuery: 'jquery'
    },
    static: [
      'node_modules/phoenix_html/priv/static/phoenix_html.js'
    ]
  }
};
