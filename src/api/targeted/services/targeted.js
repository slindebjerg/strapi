'use strict';

/**
 * targeted service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::targeted.targeted');
