'use strict';

/**
 * targeted router
 */

const { createCoreRouter } = require('@strapi/strapi').factories;

module.exports = createCoreRouter('api::targeted.targeted');
