'use strict';

/**
 * targeted controller
 */

const { createCoreController } = require('@strapi/strapi').factories;

module.exports = createCoreController('api::targeted.targeted');
