/**
 * sails-generate-backend
 *
 * Usage:
 * + Automatically called by `sails new`
 *
 * @type {Object}
 */

module.exports = {

  templatesDirectory: require('path').resolve(__dirname,'../templates'),

  before: require('./before'),

  targets: {

    '.': ['views'],
    './api/controllers': { folder: {}},
    './api/models': { folder: {}},
    './api/policies': { folder: {}},
    './api/services': { folder: {}},
    './api/responses': { folder: {}},

    './api/controllers/.gitkeep': { copy: '.gitkeep'},
    './api/models/.gitkeep': { copy: '.gitkeep'},
    './api/services/.gitkeep': { copy: '.gitkeep'},
    './config/connections.coffee': { copy: 'config/connections.coffee' },
    './config/models.coffee': { copy: 'config/models.coffee' },
    './config/blueprints.coffee': { copy: 'config/blueprints.coffee' },
    './config/bootstrap.coffee': { copy: 'config/bootstrap.coffee' },
    './config/cors.coffee': { copy: 'config/cors.coffee' },
    './config/csrf.coffee': { copy: 'config/csrf.coffee' },
    './config/http.coffee': { copy: 'config/http.coffee' },
    './config/globals.coffee': { copy: 'config/globals.coffee' },
    './config/i18n.coffee': { copy: 'config/i18n.coffee' },
    './config/local.coffee': { copy: 'config/local.coffee' },
    './config/log.coffee': { copy: 'config/log.coffee' },
    './config/policies.coffee': { copy: 'config/policies.coffee' },
    './config/routes.coffee': { copy: 'config/routes.coffee' },
    './config/sockets.coffee': { copy: 'config/sockets.coffee' },

    './config/session.coffee': { template: 'config/session.coffee' },
    './config/views.coffee': { template: 'config/views.coffee' },

    './config/locales/de.json': { copy: 'config/locales/de.json' },
    './config/locales/en.json': { copy: 'config/locales/en.json' },
    './config/locales/es.json': { copy: 'config/locales/es.json' },
    './config/locales/fr.json': { copy: 'config/locales/fr.json' },
    './config/locales/_README.md': { copy: 'config/locales/_README.md' },

    './api/policies/sessionAuth.coffee': { copy: 'api/policies/sessionAuth.coffee' },

    './api/responses/badRequest.coffee': { copy: 'api/responses/badRequest.coffee' },
    './api/responses/forbidden.coffee': { copy: 'api/responses/forbidden.coffee' },
    './api/responses/notFound.coffee': { copy: 'api/responses/notFound.coffee' },
    './api/responses/serverError.coffee': { copy: 'api/responses/serverError.coffee' },
    './api/responses/ok.coffee': { copy: 'api/responses/ok.coffee' },

    // Excluding `res.negotiate()` from the generated files for now,
    // since it's best if its definition is consistent between projects.
    // It can still be overridden by creating api/responses/negotiate.js.
    // './api/responses/negotiate.coffee': { copy: 'api/responses/negotiate.coffee' },

  }
};

